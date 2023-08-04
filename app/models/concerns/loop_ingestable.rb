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
      # TODO: consider only looking up by :doha / :pali / :words
      ld = self.where(record.except(:translations)).first_or_initialize
      unless ld.new_record?
        logger.debug "Existing #{human_name} found: #{ld.entry_key} — appending translations"
      end
      ld.safe_set_index!
      ld.save!

      ldt = ld.translations.where(record[:translations].first).first_or_initialize
      unless ldt.new_record?
        logger.debug "Duplicate #{record[:translations].first[:language]} found: #{ld.entry_key} — replacing translation"
      end
      ldt.save!
      ld
    end

  end

end
