# frozen_string_literal: true

require "test_helper"
require 'vimeo_me2'

class SyncVideosTest < ActiveSupport::TestCase

  smoke_test "confirm we get the correct number of results from the vimeo API" do
    @user = VimeoMe2::User.new(Rails.application.credentials.vimeo_authenticated_token, 'pariyatti')
    json = @user.get_full_video_list
    assert_equal 200, @user.client.last_request.code
    assert_equal 217, json['data'].length # this value will change whenever a new video is uploaded
  end

end
