# frozen_string_literal: true

FactoryBot.define do
  factory :doha do

    doha { "Barase barakhā samaya para" }
    #noinspection RailsParamDefResolve
    translations  { [ association(:doha_translation_eng, strategy: :build),
                      association(:doha_translation_por, strategy: :build) ] }
    published_at { Time.parse("2007-12-30T00:00:00Z") }
  end
end
