class Doha < ApplicationRecord
  self.implicit_order_column = "created_at"
  include Routing
  include Nameable
  has_many :translations, class_name: 'DohaTranslation', dependent: :destroy, autosave: true
  has_one_attached :audio
  naturalkey_column :doha

  def to_json
    { id: self.id,
      doha: self.doha,
      translations: self.translations.map {|t| t.attributes.slice("id", "language", "translation") },
      published_at: self.published_at,
      created_at: self.created_at,
      updated_at: self.updated_at,
      type: "doha",
      url: doha_url(self, :json),
      header: "Daily Dhamma Verse",
      bookmarkable: true,
      shareable: true,
      audio: { path: rails_blob_path(self.audio, disposition: "attachment", only_path: true),
               url: polymorphic_url(self.audio)
              },
      original_doha: self.original_doha,
      original_url: self.original_url,
      original_audio_url: self.original_audio_url
    }
  end
end
