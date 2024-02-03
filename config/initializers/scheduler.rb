
require 'rufus-scheduler'

# do not schedule when Rails is run from its console, for a test/spec, or from a Rake task
return if defined?(Rails::Console) || Rails.env.test? || File.split($PROGRAM_NAME).last == 'rake'

# NOTE: inspect Process.pid now to see that the Rufus Scheduler boots
# before Puma goes into cluster mode; jobs all run in the master process
s = Rufus::Scheduler.singleton

so_often = if Rails.env.development?
             '1m'
           elsif Rails.env.production?
             '1h'
           elsif Rails.env.staging?
             '1h'
           else
             '1h'
           end

s.every so_often do
  LoopedPaliWord.publish_tomorrow!
  LoopedDoha.publish_tomorrow!
  LoopedWordsOfBuddha.publish_tomorrow!
end
