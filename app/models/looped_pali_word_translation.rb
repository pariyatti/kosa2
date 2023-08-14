class LoopedPaliWordTranslation < ApplicationRecord
  belongs_to :looped_pali_word
  validates_presence_of :language, :translation

end
