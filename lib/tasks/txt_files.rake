# frozen_string_literal: true

namespace :kosa do
  namespace :txt do

    desc "Ingest TXT files"
    task ingest: [:environment] do
      # log_file     = Rails.root.join("log", "#{Rails.env}.log")
      # Rails.logger = ActiveSupport::Logger.new(log_file)
      # Rails.logger.extend(ActiveSupport::Logger.broadcast(ActiveSupport::Logger.new(STDOUT)))

      puts "Ingesting TXT files in [#{Rails.env}]... (this will take a few minutes)"
      LoopedPaliWord.ingest_all
      LoopedDoha.ingest_all
      LoopedWordsOfBuddha.ingest_all
    end

    desc "Remove TXT files"
    task :clean do
      sh("./bin/kosa-clean-txt-files.sh")
    end

    desc "Clone TXT files from GitHub"
    task :clone do
      sh("./bin/kosa-clone-txt-files.sh")
    end

    # TODO: txt_prod, txt_trunc_prod
  end

  # TODO: ~/.kosa, ~/.kosa/secrets, ~/.kosa/ansible-password
end
