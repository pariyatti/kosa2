require "test_helper"

class LoopedWordsOfBuddhaTest < ActiveSupport::TestCase

  test "validates ingestion found translations for each language" do
    LoopedWordsOfBuddha.create!(words: "Sabbapāpassa akaraṇaṃ", translations: [LoopedWordsOfBuddhaTranslation.new(language: "eng", translation: "broken")])
    assert_raises(RuntimeError) { LoopedWordsOfBuddha.validate_ingest! }
  end

  test "duplicates audio" do
    LoopedWordsOfBuddha.ingest(file_fixture("words_of_buddha_yatoyato_mp3_eng.txt"), "eng")
    assert_equal 1, LoopedWordsOfBuddha.count
    LoopedWordsOfBuddha.publish_daily!
    assert_equal "dhammapada_25_374.mp3", WordsOfBuddha.first.audio.filename.to_s
    assert WordsOfBuddha.first.audio.audio?
  end

  test "renders words of buddha json from as_json" do
    travel_to Time.utc(2008, 1, 1, 0, 0, 0)
    expected = "{\"id\":\"UUID-WAS-HERE\",\"words\":\"etaṃ buddhāna sāsanaṃ\",\"translations\":[{\"id\":\"UUID-WAS-HERE\",\"language\":\"eng\",\"translation\":\"this is the teaching of the Buddhas\"},{\"id\":\"UUID-WAS-HERE\",\"language\":\"por\",\"translation\":\"este é o ensinamento dos Budas\"}],\"published_at\":\"2007-12-30T00:00:00.000Z\",\"created_at\":\"2008-01-01T00:00:00.000Z\",\"updated_at\":\"2008-01-01T00:00:00.000Z\",\"type\":\"words_of_buddha\",\"url\":\"http://kosa-test.pariyatti.app/api/v1/today/words_of_buddha/UUID-WAS-HERE.json\",\"header\":\"Words of the Buddha\",\"bookmarkable\":true,\"shareable\":true,\"audio\":{\"path\":\"/rails/active_storage/blobs/redirect/ID-WAS-HERE/dhammapada_25_374.mp3?disposition=attachment\",\"url\":\"http://kosa-test.pariyatti.app/rails/active_storage/blobs/redirect/ID-WAS-HERE/dhammapada_25_374.mp3\"},\"original_words\":null,\"original_url\":null,\"original_audio_url\":null,\"citepali\":null,\"citepali_url\":null,\"citebook\":null,\"citebook_url\":null}"
    wob = create(:words_of_buddha)
    #puts wob.to_json.inspect
    assert_equal strip_uuid(strip_activestorage_id(expected)),
                 strip_uuid(strip_activestorage_id(wob.to_json))
  end
end
