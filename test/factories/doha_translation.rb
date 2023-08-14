# frozen_string_literal: true

FactoryBot.define do
  factory :doha_translation do
    language { "por" }
    translation  { "Que as chuvas caiam na estação devida" }
    published_at { Time.parse("2007-12-30T00:00:00Z") }
  end

  factory :doha_translation_eng, parent: :doha_translation do
    language { "eng" }
    translation { "May the rains fall in due season" }
  end

  factory :doha_translation_por, parent: :doha_translation do
    language { "por" }
    translation  { "Que as chuvas caiam na estação devida" }
  end
end
