# frozen_string_literal: true

FactoryBot.define do
  factory :words_of_buddha do
    words { "etaṃ buddhāna sāsanaṃ" }
    #noinspection RailsParamDefResolve
    translations  { [ association(:words_of_buddha_translation_eng, strategy: :build),
                      association(:words_of_buddha_translation_por, strategy: :build) ] }
    published_at { Time.parse("2007-12-30T00:00:00Z") }
    published_date { Date.new(2007, 12, 30) }
    after(:build) do |wob|
      #noinspection RubyResolve
      wob.audio.attach(
        io: File.open(Rails.root.join('test', 'fixtures', 'files', 'dhammapada_25_374.mp3')),
        filename: 'dhammapada_25_374.mp3',
        content_type: 'audio/mpeg'
      )
    end
  end
end
