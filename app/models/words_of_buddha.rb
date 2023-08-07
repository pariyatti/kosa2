class WordsOfBuddha < ApplicationRecord
  self.implicit_order_column = "created_at"
  include Nameable
  has_many :translations, class_name: 'WordsOfBuddhaTranslation', dependent: :destroy
  has_one_attached :audio
  naturalkey_column :words
end
