
require 'rufus-scheduler'

# do not schedule when Rails is run from its console, for a test/spec, or from a Rake task
return if defined?(Rails::Console) || Rails.env.test? || File.split($PROGRAM_NAME).last == 'rake'

# NOTE: inspect Process.pid now to see that the Rufus Scheduler boots
# before Puma goes into cluster mode; jobs all run in the master process
s = Rufus::Scheduler.singleton

# NOTE: we have to use to_prepare because initializers can't refer to reloadable constants otherwise
Rails.application.config.to_prepare do
  ScheduledDailyPublishService.new(s).start
  ScheduledVideoSyncService.new(s).start
end
