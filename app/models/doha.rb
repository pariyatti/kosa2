# == Schema Information
#
# Table name: dohas
#
#  id                 :uuid             not null, primary key
#  doha               :text
#  original_audio_url :string
#  original_doha      :text
#  original_url       :string
#  published_at       :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Doha < ApplicationRecord
  include Ordered
  include Routing
  include Nameable
  has_paper_trail
  has_many :translations, class_name: 'DohaTranslation', dependent: :destroy, autosave: true
  has_one_attached :audio
  naturalkey_column :doha
  validates_presence_of :doha, :translations, :published_at

  def as_json(options=nil)
    {
      id: self.id,
      doha: self.doha,
      translations: self.translations.as_json,
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
