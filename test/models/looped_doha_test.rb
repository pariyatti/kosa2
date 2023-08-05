require "test_helper"

class LoopedDohaTest < ActiveSupport::TestCase

  setup do
    LoopedDoha.skip_downloads = false
  end

  test "validates ingestion found translations for each language" do
    LoopedDoha.create!(doha: "Dharam ditto si", translations: [LoopedDohaTranslation.new(language: "eng", translation: "broken")])
    assert_raises(RuntimeError) { LoopedDoha.validate_ingest! }
  end

  test "downloads mp3 and attaches it" do
    LoopedDoha.ingest(file_fixture("doha_citta_mp3_eng.txt"), "eng")
    assert_equal "054_Doha.mp3", LoopedDoha.first.audio.filename.to_s
    assert LoopedDoha.first.audio.audio?
  end

  test "does not download mp3 for non-english languages" do
    LoopedDoha.ingest(file_fixture("doha_citta_mp3_eng.txt"), "eng")
    earlier = LoopedDoha.first.audio.blob
    LoopedDoha.ingest(file_fixture("doha_citta_mp3_por.txt"), "por")
    assert_equal earlier, LoopedDoha.first.audio.blob
  end

end
