class LoopedPaliWord < ApplicationRecord
  include Nameable
  include Ingestable
  has_many :translations, class_name: 'LoopedPaliWordTranslation', dependent: :destroy

  def self.ingest_all
    conf[:languages].each do |lang|
      ingest(conf[:filemask].gsub("%s", lang), lang)
    end
  end

  def self.validate_ingest!
    LoopedPaliWord.all.each do |lpw|
      ts = lpw.translations
      diff = {actual: ts, expected: conf[:languages]}
      raise "TXT translation count did not match!\n\n#{diff}" if ts.count != conf[:languages].count
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

  def self.conf
    Rails.application.config_for(:looped_cards)[:txt_feeds][:pali_word]
  end

end
