require 'uri'
require 'open-uri'
using RefinedString

class LoopedWordsOfBuddha < ApplicationRecord
  self.implicit_order_column = "created_at"
  include Nameable
  include LoopIngestable
  include LoopPublishable
  has_many :translations, class_name: 'LoopedWordsOfBuddhaTranslation', dependent: :destroy
  has_one_attached :audio
end
