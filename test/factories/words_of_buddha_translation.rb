# frozen_string_literal: true

FactoryBot.define do
  factory :words_of_buddha_translation do
    language { "por" }
    translation  { "este é o ensinamento dos Budas" }
    published_at { Time.parse("2007-12-30T00:00:00Z") }
  end

  factory :words_of_buddha_translation_eng, parent: :words_of_buddha_translation do
    language { "eng" }
    translation { "this is the teaching of the Buddhas" }
  end

  factory :words_of_buddha_translation_por, parent: :words_of_buddha_translation do
    language { "por" }
    translation  { "este é o ensinamento dos Budas" }
  end
end
