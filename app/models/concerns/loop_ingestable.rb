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
               insert(record, lang)
             end
    end

    def marker_for(lang)
      marker_pair = conf[:markers].find {|m| m[:language] == lang} || raise("No #{human_name} marker for language '#{lang}'")
      raw = marker_pair[:marker]
      "#{raw}: "
    end
  end

end