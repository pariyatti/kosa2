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

  def self.parse(line)
    raise NotImplementedError
  end

  def self.insert(lang, pair)
    raise NotImplementedError
  end

  def self.conf
    Rails.application.config_for(:looped_cards)[:txt_feeds][:doha]
  end

  def self.already_published(card)
    Doha.where(doha: card.doha)
  end

  def transcribe(pub_time)
    raise NotImplementedError
  end

end
