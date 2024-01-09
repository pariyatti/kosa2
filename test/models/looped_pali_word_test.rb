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

  test "renders json from as_json" do
    travel_to Time.utc(2008, 1, 1, 0, 0, 0)
    pali_word = create(:pali_word)
    #puts pali_word.to_json.inspect
    assert_equal strip_uuid("{\"id\":\"25598756-5c18-43bb-8117-833e024a5159\",\"pali\":\"mātā\",\"translations\":[{\"id\":\"28501325-7889-45a0-8be8-8233ee6e3966\",\"language\":\"eng\",\"translation\":\"mother\"},{\"id\":\"7770b2b2-55ff-4e4a-b07a-4d737e70bf08\",\"language\":\"por\",\"translation\":\"mãe\"}],\"published_date\":\"2007-12-30\",\"published_at\":\"2007-12-30T00:00:00.000Z\",\"created_at\":\"2008-01-01T00:00:00.000Z\",\"updated_at\":\"2008-01-01T00:00:00.000Z\",\"type\":\"pali_word\",\"url\":\"http://kosa-test.pariyatti.app/api/v1/today/pali_word/25598756-5c18-43bb-8117-833e024a5159.json\",\"header\":\"Pāli Word of the Day\",\"bookmarkable\":true,\"shareable\":true,\"audio\":{\"url\":\"\"}}"),
                 strip_uuid(pali_word.to_json)
  end
end
