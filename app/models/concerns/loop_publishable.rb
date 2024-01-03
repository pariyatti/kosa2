# frozen_string_literal: true
using RefinedDate
using RefinedDateTime

module LoopPublishable
  extend ActiveSupport::Concern

  class_methods do
    def publish_daily!
      puts "Running #{human_name} 'publish_daily!' @ #{Time.now}"
      publish_nth(DateTime.now.utc)
    end

    def publish_specific!(date)
      raise TypeError("#{date} is not a Date.") unless date.instance_of?(Date)
      publish_nth(date.to_datetime)
    end

    def publish_nth(utc_datetime)
      count = self.all.count
      logger.info("#### Ignoring. Zero #{name} found.") and return if count == 0

      card = transcribe_nth(to_publish_time(utc_datetime), count)
      if recently_published?(card)
        logger.info "#### Ignoring. '#{card.naturalkey_value}' was recently published."
        return
      end
      logger.info "#### Saving."
      card.save!
    end

    def to_publish_time(utc_datetime)
      DateTime.parse(utc_datetime.change(publish_at_time).to_formatted_s(:kosa))
    end

    def transcribe_nth(pub_time, count)
      index = which_card(pub_time, count)
      puts "index is: #{index}"
      looped = self.where(index: index).sole
      card = looped.transcribe(pub_time)
      logger.info "#### Today's #{human_name} is: #{card.naturalkey_value}"
      return card
    end

    def which_card(now, count)
      now.whole_days_since(PERL_EPOCH)
        .then {|day_offset| day_offset % count }
    end

    def recently_published?(card)
      existing = self.already_published(card).order(published_at: :desc)
      puts "existing? #{existing.empty?}"
      return existing.exists? && existing.first.published_at.whole_days_since(card.published_at) < 2
    end
  end

end
