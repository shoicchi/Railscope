# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
env :PATH, ENV['PATH']
require File.expand_path(File.dirname(__FILE__) + "/environment")
set :output, "log/monthly_add.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

 every 1.day, :at => '11:00 am' do#1.day, :at => '00:00 am'
 	#runner "Point.monthly_add", :environment => "development"
 	rake "point:monthly_add", :environment => "development"
 end

# every :minute do
#   command "echo 'you can use raw cron syntax too'", :environment => "development"
# end