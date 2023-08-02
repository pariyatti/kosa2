
require 'rufus-scheduler'

# NOTE: inspect Process.pid now to see that the Rufus Scheduler boots
# before Puma goes into cluster mode; jobs all run in the master process
s = Rufus::Scheduler.singleton

s.every '1s' do
  f = LoopedPaliWord.first # TODO: follow schedule
  f.publish! if f
end
