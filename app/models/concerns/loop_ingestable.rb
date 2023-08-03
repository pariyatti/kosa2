# frozen_string_literal: true

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
    def ingest(f, lang)
      logger.info "#{human_name} TXT: started ingesting file '#{f}' for lang '#{lang}'"
      File.read(f).split('~').map { |entry| parse(entry) }.each { |entry| insert(lang, entry) }
    end
  end

end
