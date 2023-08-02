# frozen_string_literal: true

class PaliWordTranslation < ApplicationRecord
  include Nameable
  belongs_to :pali_word

end
