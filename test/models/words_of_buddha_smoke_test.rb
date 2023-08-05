require "test_helper"

class WordsOfBuddhaTest < ActiveSupport::TestCase

  setup do
    LoopedWordsOfBuddha.skip_downloads = true
    LoopedWordsOfBuddha.ingest_all
  end

  test "exactly 169 records" do
    assert_equal 169, LoopedWordsOfBuddha.all.count
  end

  test "all have 7 languages" do
    LoopedWordsOfBuddha.all.each do |lwob|
      assert_equal 7, lwob.translations.count, "LoopedWordsOfBuddha = #{lwob.inspect}\nTranslations = #{lwob.translations.inspect}"
    end
  end

end
