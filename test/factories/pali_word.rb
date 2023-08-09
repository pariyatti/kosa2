# frozen_string_literal: true

FactoryBot.define do
  factory :pali_word do

    pali { "mātā" }
    translations  { [ association(:pali_word_translation_eng, strategy: :build),
                      association(:pali_word_translation_por, strategy: :build) ] }
    published_at { Time.parse("2007-12-30T00:00:00Z") }
  end
end
