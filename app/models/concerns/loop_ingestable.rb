# frozen_string_literal: true
using RefinedString

module LoopIngestable
  extend ActiveSupport::Concern

  included do
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
      # TODO: consider only looking up by :doha / :pali / :words
      ld = self.where(entry_attr_key => record[entry_attr_key]).first_or_initialize
      unless ld.new_record?
        logger.debug "Existing #{human_name} found: #{ld.entry_attr_value} — appending translations"
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
        logger.debug "Duplicate #{lang[:language]} found: #{ld.entry_attr_value} — replacing translation"
      end
      ldt.save!
      ld
    end

  end

end
