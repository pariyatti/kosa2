# == Schema Information
#
# Table name: looped_dohas
#
#  id                 :uuid             not null, primary key
#  doha               :text
#  index              :bigint
#  original_audio_url :string
#  original_doha      :text
#  original_url       :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
using RefinedString

class LoopedDoha < ApplicationRecord
  include Ordered
  include Nameable
  include LoopIngestable
  include LoopPublishable
  has_paper_trail
  #noinspection RailsParamDefResolve
  has_many :translations, class_name: 'LoopedDohaTranslation', dependent: :destroy, autosave: true
  has_one_attached :audio
  naturalkey_column :doha
  validates_presence_of :doha, :translations
  validates_uniqueness_of :doha

  def self.from_blocks(blocks, lang)
    { doha: blocks[0],
      original_audio_url: blocks[1],
      translations: [{language: lang, translation: blocks[2]}] }
  end

  def self.parse(entry, lang)
    marker = marker_for(lang)
    entry.split(marker)
         .then {|split| split.map(&:trim) }
         .then {|cleaned| [cleaned.first, cleaned.second]}
         .then {|repaired| [repaired.first] + repaired.second.split(/\n\s*\n/, 2)}
         .then {|blocks| from_blocks(blocks.map(&:trim), lang) }
  end

  def self.conf
    Rails.application.config_for(:looped_cards)[:txt_feeds][:doha]
  end

  def self.publish_at_time
    # 09:11:02am PST +08:00 from UTC = 17:11:02
    { hour: 17, min: 11, sec: 2 }
  end

  def self.already_published(card)
    Doha.where(doha: card.doha)
  end

  def download_attachment!
    download_audio_attachment!
  end

  def transcribe(pub_time)
    doha = Doha.new(doha: self.doha,
                    original_doha: self.original_doha,
                    original_url: self.original_url,
                    original_audio_url: self.original_audio_url,
                    published_at: pub_time)
    raise "Looped audio not attached" unless self.audio.attached?
    doha.audio.attach(self.audio.blob)
    translations.each do |t|
      doha.translations.build(language: t.language, translation: t.translation, published_at: pub_time)
    end
    doha
  end

end
