# frozen_string_literal: true

class ScheduledDailyPublishService
  def initialize(scheduler)
    @scheduler = scheduler
  end

  def start
    so_often = if Rails.env.development?
                 '1m'
               elsif Rails.env.production?
                 '1h'
               elsif Rails.env.staging?
                 '1h'
               else
                 '1h'
               end

    @scheduler.every so_often do
      LoopedPaliWord.publish_tomorrow!
      LoopedDoha.publish_tomorrow!
      LoopedWordsOfBuddha.publish_tomorrow!
    end
  end
end
