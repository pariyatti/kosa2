# frozen_string_literal: true

class PaliWord < ApplicationRecord
  include Nameable
  has_many :translations, class_name: 'PaliWordTranslation', dependent: :destroy, autosave: true

  def main_key
    self.pali
  end

  def to_json
    { id: self.id,
      pali: self.pali,
      translations: self.translations.map {|t| t.attributes.slice("id", "language", "translation") },
      published_at: self.published_at,
      created_at: self.created_at,
      updated_at: self.updated_at,
      type: "pali_word",
      url: "TODO", # TODO: self-reference URL
      header: "Pāli Word of the Day",
      bookmarkable: true,
      shareable: true,
      audio: {url: ""}
    }
  end
end
