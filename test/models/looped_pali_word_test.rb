require "test_helper"

class LoopedPaliWordTest < ActiveSupport::TestCase

  test "validates ingestion found translations for each language" do
    LoopedPaliWord.create!(pali: "bhagga", translations: [LoopedPaliWordTranslation.new(language: "eng", text: "broken")])
    assert_raises(RuntimeError) { LoopedPaliWord.validate_ingest! }
  end

end
