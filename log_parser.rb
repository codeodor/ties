require 'time'
class LogParser
  attr_accessor :percent_complete
  
  def parse_and_return(log_filename)
    requests = {}
    this_request = {}
    collect = false
    count = 0
    total_size = File.size(log_filename)
    processed_size = 0
    @percent_complete = 0
    File.open(log_filename) do |file|
      file.each_line do |line|
        if line.index("Processing") == 0
          count += 1
          @percent_complete = processed_size.to_f / total_size.to_f
          if count > 1
            # end processing
            this_request[:all_info].strip!
            last_line = this_request[:all_info].split("\n")[-1]
            final_info = last_line.split(" ")
            if final_info[0] == "Completed"
              this_request[:total_time] = final_info[2].to_i

              subtime_info_exists = last_line.split("|")[0].split("(")[1]
              if subtime_info_exists
                subtime_info = last_line.split("|")[0].split("(")[1].split(")")[0]
                subtime_info.split(',').each do |subtime_token|
                  this_request.merge eval('{:' + subtime_token.gsub(":","_time.to_sym=>").downcase.gsub(' ','') + '}')
                end
              end

              http_response_and_url = last_line.split("|")[1..-1].join("|").split(" ")
              http_response = http_response_and_url[0..1].join(" ")
              url = http_response_and_url[-1].gsub(/[\[\]]/, '')

              this_request[:http_status] = http_response
              this_request[:url] = url

              this_request[:exception] = false
            else
              this_request[:exception] = true
            end
          end

          this_request = {}

          ip_date_data = line.split("(")[1].split(" ")

          ip = ip_date_data[1]

          date = Time.parse(ip_date_data[3])
          time = ip_date_data[4].split(")")[0]
          requests[date.year] ||= {}
          requests[date.year][date.month] ||= {}
          requests[date.year][date.month][date.day] ||= []

          http_method = ip_date_data[5].gsub(/[\[\]]/, "")

          controller_action = line.split(" ")[1]
          controller = controller_action.split('#')[0]
          action = controller_action.split('#')[1]

          this_request = {}
          this_request[:ip] = ip
          this_request[:http_method] = http_method
          this_request[:controller] = controller
          this_request[:action] = action 

          requests[date.year][date.month][date.day] << this_request

          collect = true    
        end

        if line.index("  Parameters:") == 0
          this_request[:parameters] = eval(line.sub('Parameters:',''))
        end

        this_request[:all_info] ||= ""
        this_request[:all_info] << line
        processed_size += line.length
      end
    end
    #require 'pp'
    #PP.pp requests
    @percent_complete = 1.0
    return requests
  end
end
