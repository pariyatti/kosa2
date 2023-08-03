# frozen_string_literal: true

class PaliWord < ApplicationRecord
  include Nameable
  has_many :translations, class_name: 'PaliWordTranslation', dependent: :destroy, autosave: true

  def main_key
    self.pali
  end

  def ==(other)
    self.pali == other.pali && self.original_pali == other.original_pali && self.original_url == other.original_url && self.published_at == other.published_at
  end
end
