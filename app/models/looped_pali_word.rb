using RefinedString

class LoopedPaliWord < ApplicationRecord
  self.implicit_order_column = "created_at"
  include Nameable
  include LoopIngestable
  include LoopPublishable
  has_many :translations, class_name: 'LoopedPaliWordTranslation', dependent: :destroy

  def self.validate_ingest!
    LoopedPaliWord.all.each do |lpw|
      ts = lpw.translations
      diff = {actual: ts, expected: conf[:languages]}
      raise "TXT translation count did not match!\n\n#{diff}" if ts.count != conf[:languages].count
    end
  end

  def self.publish_at_time
    # 08:11:02am PST +08:00 from UTC = 16:11:02
    { hour: 16, min: 11, sec: 2 }
  end

  def self.parse(line, lang)
    # TODO: return a record, not an array
    blocks = line.split('—').map(&:trim)
    { pali: blocks[0],
      original_pali: blocks[0],
      translations: [{language: lang, translation: blocks[1]}] }
  end

  def self.insert(record, lang)
    lpw = LoopedPaliWord.find_or_create_by!(record.except(:translations))
    lpw.safe_set_index!
    lpw.translations.find_or_create_by!(record[:translations].first)
    lpw
  end

  def self.conf
    Rails.application.config_for(:looped_cards)[:txt_feeds][:pali_word]
  end

  def self.already_published(card)
    PaliWord.where(pali: card.pali)
  end

  def transcribe(pub_time)
    pw = PaliWord.new(pali: self.pali, original_pali: self.original_pali, original_url: self.original_url, published_at: pub_time)
    translations.each do |t|
      pw.translations.build(language: t.language, translation: t.translation)
    end
    pw
  end

end
