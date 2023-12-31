FactoryBot.define do
  factory :txt_feed do
    sha1_digest { "MyString" }
    entry { "MyText" }
  end
end
