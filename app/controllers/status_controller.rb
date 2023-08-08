require 'uri'
require 'open-uri'

class StatusController < ApplicationController
  def ping
    render body: "pong", mime_type: Mime::Type.lookup("text/plain")
  end

  def test_connection(url)
    begin
      test_file = URI.open(url)
    rescue
      return false
    else
      return true
    ensure
      test_file.delete if test_file
    end
  end

  def status
    test_url = "http://download.pariyatti.org/dohas/001_Doha.mp3"
    conn = test_connection(test_url)
    o = { timestamp: Time.now,
          mailer_status: {mailer_status: true, mailer_ok: true},
          pariyatti_status: {test_url: test_url,
                             test_file: conn, pariyatti_ok: conn}}
    render :json => o
  end
end
