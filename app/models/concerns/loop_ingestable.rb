# frozen_string_literal: true
require 'uri'
require 'open-uri'
using RefinedString

module LoopIngestable
  extend ActiveSupport::Concern

  included do
    def append_translation!(lang)
      ldt = self.translations.where(lang).first_or_initialize
      unless ldt.new_record?
        logger.debug "Duplicate #{lang[:language]} found: #{self.naturalkey_value} — replacing translation"
      end
      ldt.save!
    end

    def download_audio_attachment!
      url = self.original_audio_url
      file = URI.open(url)
      filename = File.basename(URI.parse(url).path) # TODO: test for nil path
      #noinspection RubyResolve
      self.audio.attach(io: file, filename: filename, content_type: 'audio/mpeg')
    end

    def set_index!
      max = self.class.maximum(:index)
      self.index = max ? max + 1 : 0
    end

    def safe_set_index!
      return if self.index
      self.transaction do
        set_index!
        save!
      end
    end
  end

  class_methods do
    def skip_downloads=(v)
      @skip_downloads = v if Rails.env.test?
    end

    def skip_downloads
      @skip_downloads
    end

    def ingest_all
      puts "\nIngesting #{human_name}..."
      conf[:languages].each do |lang|
        ingest(conf[:filemask].gsub("%s", lang), lang)
      end
      puts "\nDone."
    end

    def ingest(f, lang)
      print_logged "\n#{human_name} TXT: started ingesting file '#{f}' for lang '#{lang}'"
      entries = File.read(f).split('~')
      logger.info "Processing #{entries.count} #{human_name} from TXT."
      entries.map { |entry| parse(entry.trim, lang) }
             .each.with_index(1) do |record, i|
               print_progress
               logger.debug "Attempting insert of #{i} / #{entries.count}"
               insert(record)
             end
    end

    def print_logged(msg)
      puts msg
      logger.info msg
    end

    def print_progress
      print "."
      STDOUT.flush
    end

    def marker_for(lang)
      marker_pair = conf[:markers].find {|m| m[:language] == lang} || raise("No #{human_name} marker for language '#{lang}'")
      raw = marker_pair[:marker]
      "#{raw}: "
    end

    def insert(record)
      lang = record[:translations].first
      ld = self.where(naturalkey_name => record[naturalkey_name]).first_or_initialize
      unless ld.new_record?
        logger.debug "Existing #{human_name} found: #{ld.naturalkey_value} — appending translations"
      end
      if lang[:language] == "eng"
        ld.assign_attributes(record.except(:translations))
        ld.download_attachment! unless skip_downloads
      end

      ld.append_translation!(lang)
      ld.safe_set_index!
      ld.save!
      ld
    end

    def validate_ingest!
      self.all.each do |looped_card|
        ts = looped_card.translations
        diff = {actual: ts, expected: conf[:languages]}
        raise "TXT translation count did not match!\n\n#{diff}" if ts.count != conf[:languages].count
      end
    end

  end


end
