# frozen_string_literal: true

class PaliWord < ApplicationRecord
  self.implicit_order_column = "created_at"
  include Routing
  include Nameable
  has_many :translations, class_name: 'PaliWordTranslation', dependent: :destroy, autosave: true
  naturalkey_column :pali

  def to_json
    { id: self.id,
      pali: self.pali,
      translations: self.translations.map {|t| t.attributes.slice("id", "language", "translation") },
      published_at: self.published_at,
      created_at: self.created_at,
      updated_at: self.updated_at,
      type: "pali_word",
      url: pali_word_url(self, :json),
      header: "Pāli Word of the Day",
      bookmarkable: true,
      shareable: true,
      audio: {url: ""}
    }
  end
end
