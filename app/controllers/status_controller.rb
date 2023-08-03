class StatusController < ApplicationController
  def ping
    render body: "pong", mime_type: Mime::Type.lookup("text/plain")
  end

  def status
    o = { timestamp: Time.now,
          mailer_status: {mailer_status: true, mailer_ok: true},
          # TODO: make this test downloads from d.p.o:
          pariyatti_status: {test_url: "http://download.pariyatti.org/dohas/001_Doha.mp3",
                             test_file: true, pariyatti_ok: true}}
    render :json => o
  end
end
