# frozen_string_literal: true

namespace :kosa do
  desc "Ingest TXT files"
  task ingest_txt: [:environment] do
    # log_file     = Rails.root.join("log", "#{Rails.env}.log")
    # Rails.logger = ActiveSupport::Logger.new(log_file)
    # Rails.logger.extend(ActiveSupport::Logger.broadcast(ActiveSupport::Logger.new(STDOUT)))

    puts "Ingesting TXT files in [#{Rails.env}]... (this will take a few minutes)"
    LoopedPaliWord.ingest_all
    LoopedDoha.ingest_all
    LoopedWordsOfBuddha.ingest_all
  end
end
