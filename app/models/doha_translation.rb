# == Schema Information
#
# Table name: doha_translations
#
#  id          :uuid             not null, primary key
#  language    :string
#  translation :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  doha_id     :uuid             not null, indexed
#
class DohaTranslation < ApplicationRecord
  belongs_to :doha
end
