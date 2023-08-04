require 'uri'
require 'open-uri'
using RefinedString

class LoopedDoha < ApplicationRecord
  self.implicit_order_column = "created_at"
  include Nameable
  include LoopIngestable
  include LoopPublishable
  has_many :translations, class_name: 'LoopedDohaTranslation', dependent: :destroy
  has_one_attached :audio

  def self.validate_ingest!
    raise NotImplementedError
  end

  def self.publish_at_time
    # 09:11:02am PST +08:00 from UTC = 16:11:02
    { hour: 17, min: 11, sec: 2 }
  end

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

  def self.already_published(card)
    Doha.where(doha: card.doha)
  end

  def download_attachment!
    url = self.original_audio_url
    file = URI.open(url)
    filename = File.basename(URI.parse(url).path)
    self.audio.attach(io: file, filename: filename, content_type: 'audio/mpeg')
  end

  def transcribe(pub_time)
    raise NotImplementedError
  end

  def entry_key
    self.doha
  end

end
