# frozen_string_literal: true

FactoryBot.define do
  factory :pali_word_translation do
    language { "por" }
    translation  { "mãe" }
    published_at { Time.parse("2007-12-30T00:00:00Z") }
  end

  factory :pali_word_translation_eng, parent: :pali_word_translation do
    language { "eng" }
    translation { "mother" }
  end

  factory :pali_word_translation_por, parent: :pali_word_translation do
    language { "por" }
    translation  { "mãe" }
  end
end
