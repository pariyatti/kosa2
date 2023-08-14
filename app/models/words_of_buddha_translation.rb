# == Schema Information
#
# Table name: words_of_buddha_translations
#
#  id                 :uuid             not null, primary key
#  language           :string
#  translation        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  words_of_buddha_id :uuid             not null, indexed
#
class WordsOfBuddhaTranslation < ApplicationRecord
  self.implicit_order_column = "created_at"
  belongs_to :words_of_buddha
end
