# frozen_string_literal: true

module LoopPublishable
  extend ActiveSupport::Concern

  class_methods do
    def publish_daily!
      puts "Running #{human_name} 'publish_daily!' @ #{Time.now}"
      count = self.all.count
      if count > 0
        publish_nth(count)
      else
        logger.info "#### Zero #{name} found."
      end
    end

    def publish_nth(count)
      now = DateTime.now.utc
      pub_time = now.change(publish_at_time).to_formatted_s(:kosa)
      index = which_card(pub_time, count)
      card = self.where(index: index).sole.transcribe(pub_time)
      existing = self.already_published(card).order(published_at: :desc)
      puts "index is: #{index}"
      logger.info "#### Today's #{human_name} is: #{card.main_key}"
      if existing.empty? || days_between(existing.first.published_at, pub_time) > 2
        card.save!
      else
        logger.info "#### Ignoring. '#{card.main_key}' already exists within a 2-day window."
      end
    end

    def days_between(big, small)
      (big.to_date - small.to_date)
        .then {|day_fraction| day_fraction.to_i.abs }
    end

    def which_card(now, count)
      days_between(Date.parse(PERL_EPOCH), now)
        .then {|day_offset| day_offset % count }
    end

  end

end
