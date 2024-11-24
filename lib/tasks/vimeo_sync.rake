# frozen_string_literal: true

namespace :kosa do
  namespace :video do

    desc "Sync Vimeo metadata"
    task sync: [:environment] do
      # log_file     = Rails.root.join("log", "#{Rails.env}.log")
      # Rails.logger = ActiveSupport::Logger.new(log_file)
      # Rails.logger.extend(ActiveSupport::Logger.broadcast(ActiveSupport::Logger.new(STDOUT)))

      puts "Syncing Vimeo metadata in [#{Rails.env}]... (this will take a few minutes)"
      json = Video.download_vimeo_json
      Video.sync_vimeo_json(json)
    end

  end
end
