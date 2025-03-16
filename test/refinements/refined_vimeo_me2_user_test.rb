# frozen_string_literal: true

require "test_helper"
require 'vimeo_me2'
using RefinedVimeoMe2User

class RefinedVimeoMe2UserTest < ActiveSupport::TestCase

  smoke_test "confirm we get the correct number of results from the vimeo API" do
    if Rails.application.credentials.vimeo_authenticated_token.nil?
      raise "FAIL: vimeo_authenticated_token isn't set. Do you have './config/master.key' set?"
    end
    @user = VimeoMe2::User.new(Rails.application.credentials.vimeo_authenticated_token, 'pariyatti')
    json = @user.get_full_video_list

    assert_equal 200, @user.client.last_request.code
    assert_equal 221, json['data'].length # this value will change whenever a new video is uploaded
  end

  test "removes unlisted and disabled videos from results" do
    raw_json = JSON.parse(file_fixture("vimeo_api_response.json").read)
    @user = VimeoMe2::User.new(Rails.application.credentials.vimeo_authenticated_token, 'pariyatti')
    json = @user.remove_private(raw_json)
    assert_equal 221, json['data'].length
  end
end
