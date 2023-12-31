# == Schema Information
#
# Table name: txt_feeds
#
#  id          :uuid             not null, primary key
#  entry       :text
#  language    :text             indexed => [sha1_digest]
#  sha1_digest :text             indexed => [language]
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class TxtFeed < ApplicationRecord
  validates :sha1_digest, uniqueness: { scope: :language }

  def self.register!(entry_text, lang)
    # it's a bit wasteful to record the entire text blob of the entry, but
    # this is a very small amount of data, Postgres is fast, and it's probably
    # going to save us some grief some day to have the actual text to debug. -sd
    TxtFeed.create!(sha1_digest: digest_for(entry_text), entry: entry_text, language: lang)
  end

  def self.registered?(entry_text, lang)
    TxtFeed.find_by(sha1_digest: digest_for(entry_text), language: lang)
  end

  def self.digest_for(entry_text)
    Digest::SHA1.hexdigest(entry_text)
  end
end
