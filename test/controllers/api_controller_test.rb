require "test_helper"
using RefinedHash

class ApiControllerTest < ActionDispatch::IntegrationTest
  test "should get today" do
    LoopedPaliWord.ingest_all
    travel_to Time.utc(2023, 8, 3, 0, 0, 1)
    LoopedPaliWord.publish_daily!

    pubbe = JSON.parse(file_fixture("pali_word_pubbe.json").read)
    get api_today_url
    assert_response :success
    # TODO: url won't match even once we have a route for it, but be aware it
    #       should exist eventually
    exp = strip_ids! pubbe.except("url")
    act = strip_ids! JSON.parse(response.body).first.except("url")
    assert_model_hashes exp, act
  end

  def strip_ids!(j)
    # TODO: ultimately, we should assert that ids are UUIDs (at least)
    j["translations"].each {|t| t.delete("id")}
    j
  end
end
