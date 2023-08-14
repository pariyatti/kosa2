# frozen_string_literal: true

FactoryBot.define do
  factory :words_of_buddha do

    words { "etaṃ buddhāna sāsanaṃ" }
    #noinspection RailsParamDefResolve
    translations  { [ association(:words_of_buddha_translation_eng, strategy: :build),
                      association(:words_of_buddha_translation_por, strategy: :build) ] }
    published_at { Time.parse("2007-12-30T00:00:00Z") }
  end
end
