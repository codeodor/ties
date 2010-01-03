require 'date'
Shoes.app(:title=>'Ties: Rails Log Filter', :width=>800, :height=>620) do 
  @main_form = flow(:margin=>20) do 
    @filename = ""
    stack(:width=>'33%') do
      para strong "Path to Rails production.log:" 
    end
    stack(:width=>'67%') do 
      filename_field = edit_line(:width=>'98%') 
      filename_field.text = '/Users/sam/Desktop/lpprodcopy.txt'
      flow do 
        load_button = button("Load Log")
        load_button.click do
          @day_select.items = []
          @month_select.items = []
          @year_select.items = []
          @progress_complete.hide
          load_log(filename_field.text)
        end
        para "Progress: "
        @log_loading_progress_bar = progress.displace(0,5)
        @progress_complete = para "Complete!"
        @progress_complete.hide
      end
    end

    stack { para strong "Date Info" }

    stack(:width=>'33%') do
      para "Choose a year:"
    end
    stack(:width=>'67%') do 
      @year_select = list_box
      @year_select.change do |ys|
        @day_select.items = []
        @month_select.items = []
        @month_select.items = [""] + @log[ys.text.to_i].keys.sort.map{|x| Date::MONTHNAMES[x]} unless ys.text == ""
      end
    end


    stack(:width=>'33%') do
      para "Choose a month:"
    end
    stack(:width=>'67%') do 
      @month_select = list_box
      @month_select.change do |ms|
        @day_select.items = []
        @day_select.items = [""] + @log[@year_select.text][Date::MONTHNAMES.index(ms.text)].keys.sort unless ms.text == ""
      end
    end


    stack(:width=>'33%') do
      para "Choose a day:"
    end
    stack(:width=>'67%') do 
      @day_select = list_box
      @day_select.change do |ds|
        # nada yet
      end
    end


    stack { para strong "\nController / Action Info" }
    stack(:width=>'25%') do
      para "Controller:"
    end
    stack(:width=>'25%') do
      controller_field = edit_line(:width=>'95%')
    end
    stack(:width=>'25%') do
      para "Action:"
    end
    stack(:width=>'25%') do
      action_field = edit_line(:width=>'94%')
    end

    stack { para strong "\nURL / Exception Info" }
    stack(:width=>'25%') do
      para "URL Contains:"
    end
    stack(:width=>'25%') do
      url_field = edit_line(:width=>'95%')
    end
    stack(:width=>'25%') do
      para "Exception Present?"
    end
    stack(:width=>'25%') do
      @exception_present_checkbox = check
      @exception_present_checkbox.displace(0,5)
    end


    stack { para strong("\nOther Information\n"), "Search the entirety of each log entry for parameters, values, or whatever. Feel free to use regex." }
    stack(:width=>'33%') do
      para "Search for Whatever:"
    end
    stack(:width=>'67%') do
      @whatever_field = edit_line(:width=>'98%')
    end

    
    stack(:width=>'33%') do
      para "Output filename:"
    end
    stack(:width=>'67%') do
      @save_filename_field = edit_line(:width=>'98%')   
    end
        
    stack(:width=>'100%', :border=>'black') do
      filter_button = button("Find Log Entries", :right=>10)
      filter_button.click do
        if ready_to_go?
          filter_log_entries
        else
          alert("Please make sure the log file is loaded, \nthe date information is filled out, and \nthe output filename is filled out.")
        end
      end
    end
  end #main form flow
  
  # This doesn't seem to work because the strings can get too long
  #@results_form = flow(:margin=>20) do
  #  @results_field = edit_box :width => '98%', :height => '530'
  #  @results_field.displace(0, -30)
    #@results_field = para
  #end
  #@results_form.hide
  
  ###### Auxiliary Functions ######
  def filter_log_entries
    #@main_form.hide
    #@results_form.show
    results = ""
    @log[@year_select.text][Date::MONTHNAMES.index(@month_select.text)][@day_select.text].each do |entry|
      results += entry[:all_info].to_s + "\n\n"
    end
    #@results_field.text = results
    File.open(@save_filename_field.text, "w") do |file|
      file.write results
    end
    alert("File '#{@save_filename_field.text}' written.")
  end
  
  
  def ready_to_go?
    dates_selected = @year_select.text.to_s.length > 0 && @month_select.text.to_s.length > 0 && @day_select.text.to_s.length > 0
    @log_loaded && dates_selected && @save_filename_field.text.to_s.length > 0
  end
  
  
  def load_log(filename)
    require 'log_parser'
    @log = {}
    @log_loaded = false
    log_parser = LogParser.new
    Thread.new do
      @log = log_parser.parse_and_return(filename) 
    end
    progress_animation = animate do 
      @log_loading_progress_bar.fraction = log_parser.percent_complete
      if log_parser.percent_complete >= 1.0
        progress_animation.stop
        @progress_complete.show
        @year_select.items = [""] + @log.keys.sort
        @log_loaded = true
      end
    end  
  end

end
