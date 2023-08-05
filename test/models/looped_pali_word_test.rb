require "test_helper"

class LoopedPaliWordTest < ActiveSupport::TestCase

  test "validates ingestion found translations for each language" do
    LoopedPaliWord.create!(pali: "bhagga", translations: [LoopedPaliWordTranslation.new(language: "eng", translation: "broken")])
    assert_raises(RuntimeError) { LoopedPaliWord.validate_ingest! }
  end

  test "permits broken TXT files with multiple emdash chars per line" do
    broken_line = file_fixture('pali_word_multiple_emdash.txt').read
    assert_equal "vīta + soka = free from + grief — this emdash is illegal",
                 LoopedPaliWord.parse(broken_line, "eng")[:translations].first[:translation]
  end

end
