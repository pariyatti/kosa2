# frozen_string_literal: true

require "test_helper"
require 'vimeo_me2'

class SyncVideosTest < ActiveSupport::TestCase
  def setup
    # Do nothing
  end

  def teardown
    # Do nothing
  end

  test "try it out" do
    # path = Video.download_vimeo_json
    # puts path
  end

  smoke_test "confirm we get the correct number of results from the vimeo API" do
    @user = VimeoMe2::User.new(Rails.application.credentials.vimeo_authenticated_token, 'pariyatti')
    videos = @user.get_full_video_list
    assert_equal 200, @user.client.last_request.code
    assert_equal 217, videos.length # this value will change whenever a new video is uploaded
  end
end
