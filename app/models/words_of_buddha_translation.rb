class WordsOfBuddhaTranslation < ApplicationRecord
  self.implicit_order_column = "created_at"
  belongs_to :words_of_buddha
end
