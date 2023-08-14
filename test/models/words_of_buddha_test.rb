require "test_helper"

class WordsOfBuddhaTest < ActiveSupport::TestCase

  test "audio attachment renders as mp3 url in json" do
    wob = create(:words_of_buddha)
    url = "https://download.pariyatti.org/dwob/dhammapada_11_154.mp3"
    file = URI.open(url)
    filename = File.basename(URI.parse(url).path)
    wob.audio.attach(io: file, filename: filename, content_type: 'audio/mpeg')
    assert_attachment_path "/rails/active_storage/blobs/redirect/ID-WAS-HERE/dhammapada_11_154.mp3?disposition=attachment",
                           wob.to_json[:audio][:path]
    assert_attachment_url "http://kosa-test.pariyatti.app/rails/active_storage/blobs/redirect/ID-WAS-HERE/dhammapada_11_154.mp3",
                          wob.to_json[:audio][:url]
  end

end
