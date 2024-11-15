FactoryBot.define do
  factory :video do
    uri { "MyString" }
    name { "MyString" }
    description { "MyText" }
    link { "MyString" }
    player_embed_url { "MyString" }
    duration { 1 }
    width { 1 }
    height { 1 }
    language { "MyString" }
    embed_html { "MyString" }
    created_time { "2024-11-15 17:07:18" }
    modified_time { "2024-11-15 17:07:18" }
    release_time { "2024-11-15 17:07:18" }
    privacy_view { "MyString" }
    privacy_embed { "MyString" }
    privacy_download { false }
    picture_base_link { "MyString" }
    tags { "MyText" }
    play_stats { 1 }
    status { "MyString" }
  end
end
