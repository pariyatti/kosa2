# == Schema Information
#
# Table name: words_of_buddhas
#
#  id                 :uuid             not null, primary key
#  citebook           :string
#  citebook_url       :string
#  citepali           :string
#  citepali_url       :string
#  original_audio_url :string
#  original_url       :string
#  original_words     :text
#  published_at       :datetime
#  words              :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class WordsOfBuddha < ApplicationRecord
  include Ordered
  include Routing
  include Nameable
  has_paper_trail
  has_many :translations, class_name: 'WordsOfBuddhaTranslation', dependent: :destroy, autosave: true
  has_one_attached :audio
  naturalkey_column :words
  validates_presence_of :words, :translations, :published_at

  def as_json(options=nil)
    {
      id: self.id,
      words: self.words,
      translations: self.translations.as_json,
      published_at: self.published_at,
      created_at: self.created_at,
      updated_at: self.updated_at,
      type: "words_of_buddha",
      url: words_of_buddha_url(self, :json),
      header: "Words of the Buddha",
      bookmarkable: true,
      shareable: true,
      audio: { path: rails_blob_path(self.audio, disposition: "attachment", only_path: true),
               url: url_for(self.audio)
      },
      original_words: self.original_words,
      original_url: self.original_url,
      original_audio_url: self.original_audio_url,
      citepali: self.citepali,
      citepali_url: self.citepali_url,
      citebook: self.citebook,
      citebook_url: self.citebook_url
    }
  end
end
