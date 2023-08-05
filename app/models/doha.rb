class Doha < ApplicationRecord
  self.implicit_order_column = "created_at"
  include Nameable
  has_many :translations, class_name: 'DohaTranslation', dependent: :destroy, autosave: true
  has_one_attached :audio

  def main_key
    self.doha
  end

  def to_json
    { id: self.id,
      doha: self.doha,
      translations: self.translations.map {|t| t.attributes.slice("id", "language", "translation") },
      published_at: self.published_at,
      created_at: self.created_at,
      updated_at: self.updated_at,
      type: "doha",
      url: "TODO", # TODO: self-reference URL
      header: "Daily Dhamma Verse",
      bookmarkable: true,
      shareable: true,
      audio: {url: ""}, # TODO: url_for(self.audio)
      original_doha: self.original_doha,
      original_url: self.original_url,
      original_audio_url: self.original_audio_url
    }
  end
end
