class LoopedPaliWord < ApplicationRecord
  include Ingestable
  has_many :translations, class_name: 'LoopedPaliWordTranslation', dependent: :destroy

  def self.ingest_all
    conf = Rails.application.config_for(:looped_cards)[:txt_feeds][:pali_word]
    conf[:languages].each do |lang|
      ingest(conf[:filemask].gsub("%s", lang), lang)
    end
  end

  def self.parse(line)
    line.split('—').map(&:strip)
  end

  def self.insert(lang, pair)
    lpw = LoopedPaliWord.find_or_create_by!(pali: pair.first, original_pali: pair.first)
    lpw.safe_set_index!
    lpw.translations.find_or_create_by!(language: lang, text: pair.second)
    lpw
  end

end
