# == Schema Information
#
# Table name: doha_translations
#
#  id           :uuid             not null, primary key
#  language     :string
#  published_at :datetime
#  translation  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  doha_id      :uuid             not null, indexed
#
class DohaTranslation < ApplicationRecord
  belongs_to :doha, autosave: true
  has_paper_trail
  validates_presence_of :language, :translation, :published_at

  def as_json(options=nil)
    {
      id: self.id,
      language: self.language,
      translation: self.translation
    }
  end
end
