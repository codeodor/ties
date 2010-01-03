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

Ties takes a multi-megabyte Rails production log file and outputs only the entries you're interested in.

To run Ties via source, you'll need [Shoes](http://github.com/shoes/shoes/downloads). Once installed,
just run `shoes ties.rb`.  Otherwise, you can 
[download the MacOS, Windows, or Linux executable binaries](http://github.com/codeodor/ties/downloads)