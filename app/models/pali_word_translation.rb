# frozen_string_literal: true

class PaliWordTranslation < ApplicationRecord
  include Nameable
  belongs_to :pali_word
  validates_presence_of :language, :translation, :published_at

end
