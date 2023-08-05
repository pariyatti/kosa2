require "test_helper"
using RefinedHash

class ApiControllerTest < ActionDispatch::IntegrationTest
  test "should get today" do
    # TODO: this is just to run tests on an airplane without wifi
    LoopedDoha.skip_downloads = true

    LoopedPaliWord.ingest_all
    LoopedDoha.ingest_all
    travel_to Time.utc(2023, 8, 3, 0, 0, 1)
    LoopedPaliWord.publish_daily!
    LoopedDoha.publish_daily!

    get api_today_url
    assert_response :success
    puts response.body
    json_body = JSON.parse(response.body)
    puts json_body.inspect

    pubbe = JSON.parse(file_fixture("pali_word_pubbe.json").read)
    # TODO: url won't match even once we have a route for it, but be aware it
    #       should exist eventually
    exp = strip_ids! pubbe.except("url")
    act = strip_ids! json_body.first.except("url")
    assert_model_hashes exp, act

    naekarama = JSON.parse(file_fixture("doha_naekarama.json").read)
    exp = strip_ids! naekarama.except("url")
    act = strip_ids! json_body.second.except("url")
    assert_model_hashes exp, act
  end

  def strip_ids!(j)
    # TODO: ultimately, we should assert that ids are UUIDs (at least)
    j["translations"].each {|t| t.delete("id")}
    j
  end
end
