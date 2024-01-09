# frozen_string_literal: true
using RefinedDate
using RefinedDateTime

module LoopPublishable
  extend ActiveSupport::Concern

  included do
    def to_publish_time(date)
      #DateTime.parse(utc_datetime.change(publish_at_time).to_formatted_s(:kosa))
      DateTime.parse(date.to_datetime.utc.to_formatted_s(:kosa))
    end
  end

  class_methods do
    def publish_tomorrow!
      puts "Running #{human_name} 'publish_tomorrow!' @ #{Time.now}"
      publish_nth(Date.today.next_day)
    end

    def publish_daily!
      puts "Running #{human_name} 'publish_daily!' @ #{Time.now}"
      publish_nth(Date.today)
    end

    def publish_specific!(date)
      raise TypeError("#{date} is not a Date.") unless date.instance_of?(Date)
      publish_nth(date)
    end

    def publish_nth(date)
      count = self.all.count
      logger.info("#### Ignoring. Zero #{name} found.") and return if count == 0

      card = transcribe_nth(date, count)
      if recently_published?(card)
        logger.info "#### Ignoring. '#{card.naturalkey_value}' was recently published."
        return
      end
      logger.info "#### Saving."
      card.save!
    end

    def transcribe_nth(date, count)
      index = which_card(date, count)
      logger.debug "#### index is: #{index}"
      looped = self.where(index: index).sole
      card = looped.transcribe(date)
      logger.info "#### Today's #{human_name} is: #{card.naturalkey_value}"
      return card
    end

    def which_card(date, count)
      date.whole_days_since(PERL_EPOCH)
        .then {|day_offset| day_offset % count }
    end

    def recently_published?(card)
      existing = self.already_published(card).order(published_at: :desc)
      logger.debug "#### existing? #{existing.exists?}"
      print_progress existing.exists? ? "x" : "."
      return existing.exists? && existing.first.published_date.whole_days_since(card.published_date) < 2
    end
  end
end
