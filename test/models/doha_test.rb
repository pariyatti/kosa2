#noinspection RubyResolve
require "test_helper"

class DohaTest < ActiveSupport::TestCase

  test "audio attachment renders as mp3 url in json" do
    doha = create(:doha)
    url = "https://download.pariyatti.org/dohas/108_Doha.mp3"
    file = URI.open(url)
    path = URI.parse(url).path
    #noinspection RubyMismatchedArgumentType
    filename = File.basename(path)
    #noinspection RubyResolve
    doha.audio.attach(io: file, filename: filename, content_type: 'audio/mpeg')
    assert_attachment_path "/rails/active_storage/blobs/redirect/ID-WAS-HERE/108_Doha.mp3?disposition=attachment",
                           doha.to_json[:audio][:path]
    assert_attachment_url "http://kosa-test.pariyatti.app/rails/active_storage/blobs/redirect/ID-WAS-HERE/108_Doha.mp3",
                          doha.to_json[:audio][:url]
  end

end
