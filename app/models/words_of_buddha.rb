class WordsOfBuddha < ApplicationRecord
  self.implicit_order_column = "created_at"
  include Nameable
  has_many :translations, class_name: 'WordsOfBuddhaTranslation', dependent: :destroy
  has_one_attached :audio
  naturalkey_column :words

  def to_json
    { id: self.id,
      words: self.words,
      translations: self.translations.map {|t| t.attributes.slice("id", "language", "translation") },
      published_at: self.published_at,
      created_at: self.created_at,
      updated_at: self.updated_at,
      type: "words_of_buddha",
      url: "TODO", # TODO: self-reference URL
      header: "Words of the Buddha",
      bookmarkable: true,
      shareable: true,
      audio: {url: ""}, # TODO: url_for(self.audio)
      original_words: self.original_words,
      original_url: self.original_url,
      original_audio_url: self.original_audio_url
    }
  end
end
