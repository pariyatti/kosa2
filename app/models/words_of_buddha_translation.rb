# == Schema Information
#
# Table name: words_of_buddha_translations
#
#  id                 :uuid             not null, primary key
#  language           :string
#  published_at       :datetime
#  translation        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  words_of_buddha_id :uuid             not null, indexed
#
class WordsOfBuddhaTranslation < ApplicationRecord
  belongs_to :words_of_buddha, autosave: true
  validates_presence_of :language, :translation, :published_at

  def as_json(options=nil)
    {
      id: self.id,
      language: self.language,
      translation: self.translation
    }
  end
end
