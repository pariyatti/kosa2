class Doha < ApplicationRecord
  self.implicit_order_column = "created_at"
  include Nameable
  has_many :translations, class_name: 'DohaTranslation', dependent: :destroy, autosave: true
  has_one_attached :audio

  def main_key
    self.doha
  end
end
