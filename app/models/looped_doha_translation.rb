# == Schema Information
#
# Table name: looped_doha_translations
#
#  id             :uuid             not null, primary key
#  language       :string
#  translation    :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  looped_doha_id :uuid             not null, indexed
#
class LoopedDohaTranslation < ApplicationRecord
  belongs_to :looped_doha, autosave: true
  validates_presence_of :language, :translation
end
