require "test_helper"

class VideosControllerTest < ActionDispatch::IntegrationTest
  test "gets all videos from index" do
    create(:video)
    create(:video)
    get '/api/v1/library/videos.json'
    assert_response :success
    assert_equal 2, JSON.parse(@response.body).length
  end

  test "finds videos via simple search api" do
    # TODO: next up
  end
end
