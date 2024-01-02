# frozen_string_literal: true

# == Schema Information
#
# Table name: pali_word_translations
#
#  id           :uuid             not null, primary key
#  language     :string
#  published_at :datetime
#  translation  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  pali_word_id :uuid             not null, indexed
#
class PaliWordTranslation < ApplicationRecord
  include Nameable
  belongs_to :pali_word, autosave: true
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
