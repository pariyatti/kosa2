# frozen_string_literal: true

namespace :kosa do
  namespace :looped do

    desc "Retroactively publish looped cards (set MONTHS env var)"
    task publish: [:environment] do
      # log_file     = Rails.root.join("log", "#{Rails.env}.log")
      # Rails.logger = ActiveSupport::Logger.new(log_file)
      # Rails.logger.extend(ActiveSupport::Logger.broadcast(ActiveSupport::Logger.new(STDOUT)))

      n_months = ENV['MONTHS'].to_i
      puts "Publishing #{n_months} months of looped cards in [#{Rails.env}]..."
      puts n_months
      date_range = (Date.today - n_months.months)..Date.today
      date_range.each do |date|
        LoopedPaliWord.publish_specific!(date)
        LoopedDoha.publish_specific!(date)
        LoopedWordsOfBuddha.publish_specific!(date)
      end
    end

  end
end
