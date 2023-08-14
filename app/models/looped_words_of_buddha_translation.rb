# == Schema Information
#
# Table name: looped_words_of_buddha_translations
#
#  id                        :uuid             not null, primary key
#  language                  :string
#  translation               :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  looped_words_of_buddha_id :uuid             not null, indexed
#
class LoopedWordsOfBuddhaTranslation < ApplicationRecord
  belongs_to :looped_words_of_buddha, autosave: true
  validates_presence_of :language, :translation
end
