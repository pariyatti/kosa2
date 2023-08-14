# == Schema Information
#
# Table name: looped_pali_word_translations
#
#  id                  :uuid             not null, primary key
#  language            :string
#  translation         :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  looped_pali_word_id :uuid             not null, indexed
#
class LoopedPaliWordTranslation < ApplicationRecord
  belongs_to :looped_pali_word, autosave: true
  validates_presence_of :language, :translation

end
