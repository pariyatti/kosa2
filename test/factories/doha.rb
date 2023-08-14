# frozen_string_literal: true

FactoryBot.define do
  factory :doha do
    doha { "Barase barakhā samaya para" }
    #noinspection RailsParamDefResolve
    translations  { [ association(:doha_translation_eng, strategy: :build),
                      association(:doha_translation_por, strategy: :build) ] }
    published_at { Time.parse("2007-12-30T00:00:00Z") }
    after(:build) do |doha|
      doha.audio.attach(
        io: File.open(Rails.root.join('test', 'fixtures', 'files', '054_Doha.mp3')),
        filename: '054_Doha.mp3',
        content_type: 'audio/mpeg'
      )
    end
  end
end
