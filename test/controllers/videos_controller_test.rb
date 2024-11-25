require "test_helper"

class VideosControllerTest < ActionDispatch::IntegrationTest
  test "gets all videos from index" do
    create(:video)
    create(:video)
    get '/api/v1/library/videos.json' # :format doesn't work in integration tests
    assert_response :success
    assert_equal 2, JSON.parse(@response.body).length
  end

  test "finds a videos via simple search api" do
    create(:video)
    create(:video, description: "Something about Anatha Pindaka")
    get videos_search_v1_url, params: { q: "Anath" }
    assert_response :success
    assert_equal 1, JSON.parse(@response.body).length
  end

  test "finds two videos by name and description via search api" do
    create(:video)
    create(:video, name: "Anatha Pindaka's Story")
    create(:video, description: "Something about Anatha Pindaka")
    get videos_search_v1_url, params: { q: "Anath" }
    assert_response :success
    assert_equal 2, JSON.parse(@response.body).length
  end

  test "search api ignores case" do
    create(:video)
    create(:video, name: "Anatha Pindaka's Story")
    create(:video, description: "Something about Anatha Pindaka")
    get videos_search_v1_url, params: { q: "anath" }
    assert_response :success
    assert_equal 2, JSON.parse(@response.body).length
  end
end
