#noinspection RubyResolve
require "test_helper"

class LoopedWordsOfBuddhaSmokeTest < ActiveSupport::TestCase

  smoke_setup do
    Rails.logger.level = 2
    LoopedWordsOfBuddha.ingest_all
  end

  teardown do
    Rails.logger.level = 0
  end

  smoke_test "exactly 169 records" do
    assert_equal 169, LoopedWordsOfBuddha.all.count
  end

  smoke_test "all have 7 languages" do
    LoopedWordsOfBuddha.all.each do |lwob|
      assert_equal 7, lwob.translations.count, "LoopedWordsOfBuddha = #{lwob.inspect}\nTranslations = #{lwob.translations.inspect}"
    end
  end

  smoke_test "publishing 2012" do
    words_text = "Yo ca dhammamabhiññāya\ndhammamaññāya paṇḍito,\nrahadova nivāte ca\nanejo vūpasammati."
    # 2012-07-30T00:00:01
    travel_to Time.utc(2012, 7, 30, 0, 0, 1)
    LoopedWordsOfBuddha.publish_daily!
    puts WordsOfBuddha.first.inspect
    assert_equal words_text, WordsOfBuddha.first.words
    assert_models WordsOfBuddha.new(words: words_text,
                                    original_words: nil, original_url: nil,
                                    original_audio_url: "https://download.pariyatti.org/dwob/itivuttaka_3_92.mp3",
                                    citepali: "Itivuttaka 3.92",
                                    citepali_url: "https://tipitaka.org/romn/cscd/s0504m.mul2.xml#para92",
                                    citebook: "Gemstones of the Good Dhamma, compiled and translated by Ven. S. Dhammika",
                                    citebook_url: "https://store.pariyatti.org/Gemstones-of-the-Good-Dhamma-WH342-4_p_1679.html",
                                    published_at: DateTime.parse("2012-07-30T15:11:02Z")),
                  WordsOfBuddha.first
  end

  smoke_test "publish 2023-07-30" do
    LoopedWordsOfBuddha.publish_specific!(Date.new(2023, 7, 30))
    assert_equal 1, WordsOfBuddha.count
    words = "Sabbhireva samāsetha,\nsabbhi kubbetha santhavaṃ.\nSataṃ saddhammamaññāya\npaññā labbhati nāññato."
    assert_equal words, WordsOfBuddha.first.words
  end

end
