# frozen_string_literal: true

class PaliWord < ApplicationRecord
  include Nameable
  has_many :translations, class_name: 'PaliWordTranslation', dependent: :destroy, autosave: true

  def main_key
    self.pali
  end

end
