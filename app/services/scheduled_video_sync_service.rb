# frozen_string_literal: true

class ScheduledVideoSyncService
  def initialize(scheduler)
    @scheduler = scheduler
  end

  def start
    cronline = if Rails.env.development?
                 '59 * * * *' # NOTE: run every N minutes, if you want to test
               elsif Rails.env.production?
                 '5 0 * * *'
               elsif Rails.env.staging?
                 '5 0 * * *'
               else
                 '5 0 * * *'
               end

    @scheduler.cron(cronline) do
      puts "Syncing Vimeo metadata in [#{Rails.env}]... (this will take a few minutes)"
      json = Video.download_vimeo_json
      Video.sync_json_to_db!(json)
    end
  end
end
