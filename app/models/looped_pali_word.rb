# == Schema Information
#
# Table name: looped_pali_words
#
#  id            :uuid             not null, primary key
#  index         :bigint
#  original_pali :string
#  original_url  :string
#  pali          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
using RefinedString

class LoopedPaliWord < ApplicationRecord
  include Ordered
  include Nameable
  include LoopIngestable
  include LoopPublishable
  has_paper_trail
  has_many :translations, class_name: 'LoopedPaliWordTranslation', dependent: :destroy, autosave: true
  naturalkey_column :pali
  validates_presence_of :pali, :translations
  validates_uniqueness_of :pali

  def self.parse(entry, lang)
    blocks = entry.split('—', 2).map(&:trim)
    { pali: blocks[0],
      original_pali: blocks[0],
      translations: [{language: lang, translation: blocks[1]}] }
  end

  def self.conf
    Rails.application.config_for(:looped_cards)[:txt_feeds][:pali_word]
  end

  def self.publish_at_time
    # 08:11:02am PST +08:00 from UTC = 16:11:02
    { hour: 16, min: 11, sec: 2 }
  end

  def self.already_published(card)
    PaliWord.where(pali: card.pali)
  end

  def download_attachment!
  end

  def transcribe(pub_time)
    pw = PaliWord.new(pali: self.pali,
                      original_pali: self.original_pali,
                      original_url: self.original_url,
                      published_at: pub_time)
    translations.each do |t|
      pw.translations.build(language: t.language, translation: t.translation, published_at: pub_time)
    end
    pw
  end

end
