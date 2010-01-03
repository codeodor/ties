The Problem
===========
I've browsed plenty of [Rails log analyzers](http://www.google.com/search?q=rails+log+analyzer) 
that help me find performance bottlenecks and potential improvements. But what I really need is a 
faster way to filter my logs to trace user sessions for support purposes. Maybe it's just me, but 
I've got apps where users report problems that make no sense, where their data gets lost, and who 
can't tell me what they did. Add to that the fact that I've got the same app running on dozens of 
different sites, and you can see why performance analyzers aren't what I'm looking for to solve my 
problem. 

How is Ties the solution?
=========================
Enter the path to a Ruby on Rails production log file, click the "Load Log" button and it reads in 
the file. Then, choose from the years, months, and days of requests in that file. Tell Ties which 
controller, action, and URL you are interested in. Finally, decide if you only want to see the log 
entries which contain an exception, enter a regular expression to search the params, plus the output 
filename and click a button to filter the log entries you care to see. 

![Screenshot of Ties](http://www.codeodor.com/images/ties_screen_full.png)

Ties takes a many-megabyte Rails production log file and outputs only the entries you're interested in.

Running Ties
============
You can 
[download the MacOS, Windows, or Linux executable binaries](http://github.com/codeodor/ties/downloads) here
at github.

Otherwise, if you want to run Ties via source, you'll need [Shoes](http://github.com/shoes/shoes/downloads). Once installed,
just run `shoes ties.rb` from the directory where the Ties source code is located.  

What's missing in the initial release?
======================================
*	_Keyboard Shortcuts_: Shoes leaves it to the programmer to implement keyboard shortcuts, so while familiar actions like Copy (ctrl-C) and Paste (ctrl-V) are available via the mouse, I have yet to implement them on the keyboard.

*	_Error Handling_: It's minimal. If you enter a non-existent file, or non-Rails-production file, who knows what will happen?

*	_Crazy web-of-a-graph_: My intent is to build the data model such that you can search most items in approximately O(1) time. Right now, you drill down to the day in constantish time, and after that it becomes linear search.

*	_Testing on all platforms and Rails versions_: I've only tested it on Mac OS 10.5.8 (Leopard), using straight log files from Rails 2.2 on Ruby 1.8.6 and 1.8.7. That being said, Shoes is supposed to work on Windows and Linux as well, and I've not noticed any major differences in the log files between Rails versions, so you might find it works great for you too. If not, I encourage you to [let me know](http://www.codeodor.com/Contact.cfm) and I'll fix it up quick for you. (Please have a sample log file available if possible.)

