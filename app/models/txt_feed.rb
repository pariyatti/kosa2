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
  has_paper_trail
  validates :sha1_digest, uniqueness: { scope: :language }

  def self.for(entry_text, lang)
    feed = self.where(sha1_digest: digest_for(entry_text), language: lang).first_or_initialize
    # it's a bit wasteful to record the entire text blob of the entry, but
    # this is a very small amount of data, Postgres is fast, and it's probably
    # going to save us some grief some day to have the actual text to debug. -sd
    feed.entry = entry_text
    feed
  end

  def register!
    save!
  end

  def registered?
    not new_record?
  end

  def self.digest_for(entry_text)
    Digest::SHA1.hexdigest(entry_text)
  end
end
