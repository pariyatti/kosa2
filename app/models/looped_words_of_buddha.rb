# == Schema Information
#
# Table name: looped_words_of_buddhas
#
#  id                 :uuid             not null, primary key
#  citebook           :string
#  citebook_url       :string
#  citepali           :string
#  citepali_url       :string
#  index              :bigint
#  original_audio_url :string
#  original_url       :string
#  original_words     :text
#  published_at       :datetime
#  words              :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
using RefinedString

class LoopedWordsOfBuddha < ApplicationRecord
  self.implicit_order_column = "created_at"
  include Nameable
  include LoopIngestable
  include LoopPublishable
  #noinspection RailsParamDefResolve
  has_many :translations, class_name: 'LoopedWordsOfBuddhaTranslation', dependent: :destroy
  has_one_attached :audio
  naturalkey_column :words

  def self.from_blocks(blocks, lang)
    { words: blocks[0],
      original_audio_url: blocks[1],
      translations: [{language: lang, translation: blocks[2]}],
    }
  end

  def self.shred_citations(text)
    text.split(/\n/).map {|line| line.trim }
  end

  def self.from_cite_blocks(blocks)
    { citepali: blocks[0],
      citepali_url: URI.parse(blocks[1]).to_s,
      citebook: blocks[2] || "",
      citebook_url: blocks[3] ? URI.parse(blocks[3]).to_s || "" : ""
    }
  end

  def self.parse(entry, lang)
    marker = marker_for(lang)
    entry.split(marker)
         .then {|split| split.map(&:trim) }
         .then {|cleaned| [cleaned.first, cleaned.second]}
         .then {|repaired| [repaired.first] + repaired.second.split(/\n\s*\n/)}
         .then {|all_blocks| [all_blocks.take(all_blocks.count-1), shred_citations(all_blocks.last)]}
         .then do |main_blocks, cite_blocks|
           from_blocks(main_blocks.map(&:trim), lang).merge(from_cite_blocks(cite_blocks.map(&:trim)))
         end
  end

  def self.conf
    Rails.application.config_for(:looped_cards)[:txt_feeds][:words_of_buddha]
  end

  def self.publish_at_time
    # 07:11:02am PST +08:00 from UTC = 15:11:02
    { hour: 15, min: 11, sec: 2 }
  end

  def self.already_published(card)
    WordsOfBuddha.where(words: card.words)
  end

  def download_attachment!
    download_audio_attachment!
  end

  def transcribe(pub_time)
    wob = WordsOfBuddha.new(words: self.words,
                            citepali: self.citepali,
                            citepali_url: self.citepali_url,
                            citebook: self.citebook,
                            citebook_url: self.citebook_url,
                            original_words: self.original_words,
                            original_url: self.original_url,
                            original_audio_url: self.original_audio_url,
                            published_at: pub_time)
    raise "Looped audio not attached" unless self.audio.attached?
    wob.audio.attach(self.audio.blob)
    translations.each do |t|
      wob.translations.build(language: t.language, translation: t.translation)
    end
    wob
  end

end
