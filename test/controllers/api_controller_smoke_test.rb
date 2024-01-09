require "test_helper"
using RefinedHash

class ApiControllerSmokeTest < ActionDispatch::IntegrationTest

  smoke_test "should get today (v1) and tomorrow (v2)" do

    LoopedPaliWord.ingest_all
    LoopedDoha.ingest_all
    LoopedWordsOfBuddha.ingest_all
    travel_to Time.utc(2023, 8, 3, 0, 0, 1)
    LoopedPaliWord.publish_daily!
    LoopedDoha.publish_daily!
    LoopedWordsOfBuddha.publish_daily!
    LoopedPaliWord.publish_tomorrow!
    LoopedDoha.publish_tomorrow!
    LoopedWordsOfBuddha.publish_tomorrow!

    get api_today_v1_url
    assert_response :success
    # puts response.body
    json_body = JSON.parse(response.body)
    puts json_body.inspect

    appam = JSON.parse(file_fixture("words_of_buddha_appam.json").read)
    assert_json appam, json_body[0]
    naekarama = JSON.parse(file_fixture("doha_naekarama.json").read)
    assert_json naekarama, json_body[1]
    pubbe = JSON.parse(file_fixture("pali_word_pubbe.json").read)
    assert_json pubbe, json_body[2]

    get api_today_v2_url
    json_body2 = JSON.parse(response.body)
    yoga = JSON.parse(file_fixture("words_of_buddha_yoga.json").read)
    assert_json yoga, json_body2[0]
    dekha = JSON.parse(file_fixture("doha_dekha.json").read)
    assert_json dekha, json_body2[1]
    katapunnata = JSON.parse(file_fixture("pali_word_katapunnata.json").read)
    assert_json katapunnata, json_body2[2]
  end

end
