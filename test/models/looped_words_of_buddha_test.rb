require "test_helper"

class LoopedWordsOfBuddhaTest < ActiveSupport::TestCase

  test "validates ingestion found translations for each language" do
    LoopedWordsOfBuddha.create!(words: "Sabbapāpassa akaraṇaṃ", translations: [LoopedWordsOfBuddhaTranslation.new(language: "eng", translation: "broken")])
    assert_raises(RuntimeError) { LoopedWordsOfBuddha.validate_ingest! }
  end

end
