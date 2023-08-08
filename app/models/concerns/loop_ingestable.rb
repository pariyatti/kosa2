# frozen_string_literal: true
require 'uri'
require 'open-uri'
using RefinedString

module LoopIngestable
  extend ActiveSupport::Concern

  included do
    def download_audio_attachment!
      url = self.original_audio_url
      file = URI.open(url)
      filename = File.basename(URI.parse(url).path)
      self.audio.attach(io: file, filename: filename, content_type: 'audio/mpeg')
    end

    def set_index!
      max = self.class.maximum(:index)
      self.index = max ? max + 1 : 0
      save!
    end

    def safe_set_index!
      set_index! unless self.index
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
      conf[:languages].each do |lang|
        ingest(conf[:filemask].gsub("%s", lang), lang)
      end
    end

    def ingest(f, lang)
      logger.info "#{human_name} TXT: started ingesting file '#{f}' for lang '#{lang}'"
      entries = File.read(f).split('~')
      logger.info "Processing #{entries.count} #{human_name} from TXT."
      entries.map { |entry| parse(entry.trim, lang) }
             .each.with_index(1) do |record, i|
               logger.debug "Attempting insert of #{i} / #{entries.count}"
               insert(record)
             end
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
      end
      ld.safe_set_index!
      ld.save!
      if lang[:language] == "eng"
        ld.download_attachment! unless skip_downloads
      end

      ldt = ld.translations.where(lang).first_or_initialize
      unless ldt.new_record?
        logger.debug "Duplicate #{lang[:language]} found: #{ld.naturalkey_value} — replacing translation"
      end
      ldt.save!
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
