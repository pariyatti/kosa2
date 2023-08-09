require "test_helper"
using RefinedHash

class ApiControllerSmokeTest < ActionDispatch::IntegrationTest
  smoke_test "should get today" do

    LoopedPaliWord.ingest_all
    LoopedDoha.ingest_all
    LoopedWordsOfBuddha.ingest_all
    travel_to Time.utc(2023, 8, 3, 0, 0, 1)
    LoopedPaliWord.publish_daily!
    LoopedDoha.publish_daily!
    LoopedWordsOfBuddha.publish_daily!

    get api_today_url
    assert_response :success
    puts response.body
    json_body = JSON.parse(response.body)
    puts json_body.inspect

    pubbe = JSON.parse(file_fixture("pali_word_pubbe.json").read)
    assert_json pubbe, json_body[0]
    naekarama = JSON.parse(file_fixture("doha_naekarama.json").read)
    assert_json naekarama, json_body[1]
    appam = JSON.parse(file_fixture("words_of_buddha_appam.json").read)
    assert_json appam, json_body[2]
  end

end
