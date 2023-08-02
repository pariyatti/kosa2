# frozen_string_literal: true

module Ingestable
  extend ActiveSupport::Concern

  class_methods do
    def ingest(f, lang)
      logger.info "#{name} TXT: started ingesting file '#{f}' for lang '#{lang}'"
      File.read(f).split('~').map { |entry| parse(entry) }.each { |entry| insert(lang, entry) }
    end
  end

end
