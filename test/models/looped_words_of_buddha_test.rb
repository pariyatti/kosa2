require "test_helper"

class LoopedWordsOfBuddhaTest < ActiveSupport::TestCase

  test "validates ingestion found translations for each language" do
    LoopedWordsOfBuddha.create!(words: "Sabbapāpassa akaraṇaṃ", translations: [LoopedWordsOfBuddhaTranslation.new(language: "eng", translation: "broken")])
    assert_raises(RuntimeError) { LoopedWordsOfBuddha.validate_ingest! }
  end

  test "duplicates audio" do
    LoopedWordsOfBuddha.ingest(file_fixture("words_of_buddha_yatoyato_mp3_eng.txt"), "eng")
    assert_equal 1, LoopedWordsOfBuddha.count
    LoopedWordsOfBuddha.publish_nth(1)
    assert_equal "dhammapada_25_374.mp3", WordsOfBuddha.first.audio.filename.to_s
    assert WordsOfBuddha.first.audio.audio?
  end

end
