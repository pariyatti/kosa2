require "test_helper"

class LoopedDohaTest < ActiveSupport::TestCase

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

  test "duplicates audio" do
    LoopedDoha.ingest(file_fixture("doha_citta_mp3_eng.txt"), "eng")
    assert_equal 1, LoopedDoha.count
    LoopedDoha.publish_nth(1)
    assert_equal "054_Doha.mp3", Doha.first.audio.filename.to_s
    assert Doha.first.audio.audio?
  end

  test "renders doha json from as_json" do
    travel_to Time.utc(2008, 1, 1, 0, 0, 0)
    expected = "{\"id\":\"UUID-WAS-HERE\",\"doha\":\"Barase barakhā samaya para\",\"translations\":[{\"id\":\"UUID-WAS-HERE\",\"language\":\"eng\",\"translation\":\"May the rains fall in due season\"},{\"id\":\"UUID-WAS-HERE\",\"language\":\"por\",\"translation\":\"Que as chuvas caiam na estação devida\"}],\"published_at\":\"2007-12-30T00:00:00.000Z\",\"created_at\":\"2008-01-01T00:00:00.000Z\",\"updated_at\":\"2008-01-01T00:00:00.000Z\",\"type\":\"doha\",\"url\":\"http://kosa-test.pariyatti.app/api/v1/today/doha/UUID-WAS-HERE.json\",\"header\":\"Daily Dhamma Verse\",\"bookmarkable\":true,\"shareable\":true,\"audio\":{\"path\":\"/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaEpJaWt6TXpWbU0yVTRaaTFoTWpFM0xUUTFOak10T0RsaU1DMDFNMkU0WlRjNVltVXpNR01HT2daRlZBPT0iLCJleHAiOm51bGwsInB1ciI6ImJsb2JfaWQifX0=--34f980b2edebdb6111940955eccce4209eda307a/054_Doha.mp3?disposition=attachment\",\"url\":\"http://kosa-test.pariyatti.app/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaEpJaWt6TXpWbU0yVTRaaTFoTWpFM0xUUTFOak10T0RsaU1DMDFNMkU0WlRjNVltVXpNR01HT2daRlZBPT0iLCJleHAiOm51bGwsInB1ciI6ImJsb2JfaWQifX0=--34f980b2edebdb6111940955eccce4209eda307a/054_Doha.mp3\"},\"original_doha\":null,\"original_url\":null,\"original_audio_url\":null}"
    doha = create(:doha)
    #puts doha.to_json.inspect
    assert_equal strip_uuid(strip_activestorage_id(expected)),
                 strip_uuid(strip_activestorage_id(doha.to_json))
  end
end
