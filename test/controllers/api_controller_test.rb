# frozen_string_literal: true
#noinspection RubyResolve
require "test_helper"

class ApiControllerTest < ActionDispatch::IntegrationTest

  test "reverse chronological order as of 2023-08-08" do
    # NOTE: consider after(:build) instead of :strategy -
    #       https://github.com/thoughtbot/factory_bot_rails/issues/232

    w1 = create(:words_of_buddha, words: "Sukho viveko tuṭṭhassa,\nsutadhammassa passato.\nAbyāpajjaṃ sukhaṃ loke --\npāṇabhūtesu saṃyamo.",
                published_at: Time.parse("2023-08-07T00:00:01.000Z"),
                published_date: Date.parse("2023-08-07"))
    p1 = create(:pali_word, pali: "sippa",
                published_at: Time.parse("2023-08-07T00:00:02.000Z"),
                published_date: Date.parse("2023-08-07"))
    d1 = create(:doha, doha: "Tṛṣā jaḍa se khoda kara, \nanāsakta bana jāṅya. \nBhava bandhana se chuṭana kā, \nyahī eka upāya.",
                published_at: Time.parse("2023-08-07T00:00:03.000Z"),
                published_date: Date.parse("2023-08-07"))

    w2 = create(:words_of_buddha, words: "Na tena paṇḍito hoti\nyāvatā bahu bhāsati.\nKhemī, averī abhayo\n‘‘paṇḍito’’ti pavuccati.",
                published_at: Time.parse("2023-08-08T00:00:01.000Z"),
                published_date: Date.parse("2023-08-08"))
    p2 = create(:pali_word, pali: "vinayo",
                published_at: Time.parse("2023-08-08T00:00:02.000Z"),
                published_date: Date.parse("2023-08-08"))
    d2 = create(:doha, doha: "Bhogata bhogata bhogate, \nbandhana bandhate jāṅya. \nDekhata dekhata dekhate, \nbandhana khulate jāṅya. \n\nBhogata bhogata bhogate, \nGanthey bandhate jāṅya. \nDekhata dekhata dekhate, \nGanthey khulate jāṅya.",
                published_at: Time.parse("2023-08-08T00:00:03.000Z"),
                published_date: Date.parse("2023-08-08"))

    w2 = create(:words_of_buddha, words: "In the future.",
                published_at: Time.parse("2023-08-09T00:00:01.000Z"),
                published_date: Date.parse("2023-08-09"))
    p2 = create(:pali_word, pali: "future",
                published_at: Time.parse("2023-08-09T00:00:02.000Z"),
                published_date: Date.parse("2023-08-09"))
    d2 = create(:doha, doha: "In the future.",
                published_at: Time.parse("2023-08-09T00:00:03.000Z"),
                published_date: Date.parse("2023-08-09"))


    travel_to Time.utc(2023, 8, 8, 0, 0, 1)
    get api_today_v1_url
    assert_response :success
    json_body = JSON.parse(response.body)
    assert_equal ["doha", "pali_word", "words_of_buddha", "doha", "pali_word", "words_of_buddha"],
                 json_body.map {|card| card['type'] }
    assert_equal "Bhogata bhogata bhogate, \nbandhana bandhate jāṅya. \nDekhata dekhata dekhate, \nbandhana khulate jāṅya. \n\nBhogata bhogata bhogate, \nGanthey bandhate jāṅya. \nDekhata dekhata dekhate, \nGanthey khulate jāṅya.", json_body[0]['doha']
    assert_equal "vinayo", json_body[1]['pali']
    assert_equal "Na tena paṇḍito hoti\nyāvatā bahu bhāsati.\nKhemī, averī abhayo\n‘‘paṇḍito’’ti pavuccati.", json_body[2]['words']
    assert_equal "Tṛṣā jaḍa se khoda kara, \nanāsakta bana jāṅya. \nBhava bandhana se chuṭana kā, \nyahī eka upāya.", json_body[3]['doha']
    assert_equal "sippa", json_body[4]['pali']
    assert_equal "Sukho viveko tuṭṭhassa,\nsutadhammassa passato.\nAbyāpajjaṃ sukhaṃ loke --\npāṇabhūtesu saṃyamo.", json_body[5]['words']

    get api_today_v2_url
    assert_response :success
    json_body2 = JSON.parse(response.body)
    assert_equal ["doha", "pali_word", "words_of_buddha", "doha", "pali_word", "words_of_buddha", "doha", "pali_word", "words_of_buddha"],
                 json_body2.map {|card| card['type'] }
  end

end
