class LoopedPaliWord < ApplicationRecord
  include Ingestable
  has_many :looped_pali_word_translations, dependent: :destroy

  def self.ingest_all
    conf = Rails.application.config_for(:looped_cards)[:txt_feeds][:pali_word]
    conf[:languages].each do |lang|
      ingest(conf[:filemask].gsub("%s", lang), lang)
    end
  end
end
