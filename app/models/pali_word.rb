# frozen_string_literal: true

# == Schema Information
#
# Table name: pali_words
#
#  id            :uuid             not null, primary key
#  index         :bigint
#  original_pali :string
#  original_url  :string
#  pali          :string
#  published_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class PaliWord < ApplicationRecord
  include Ordered
  include Routing
  include Nameable
  has_paper_trail
  has_many :translations, class_name: 'PaliWordTranslation', dependent: :destroy, autosave: true
  naturalkey_column :pali
  validates_presence_of :pali, :translations, :published_at

  def as_json(options=nil)
    { id: self.id,
      pali: self.pali,
      translations: self.translations.as_json,
      published_at: self.published_at,
      created_at: self.created_at,
      updated_at: self.updated_at,
      type: "pali_word",
      url: pali_word_url(self, :json),
      header: "Pāli Word of the Day",
      bookmarkable: true,
      shareable: true,
      audio: {url: ""} # Pali Words do not include audio yet
    }
  end
end
