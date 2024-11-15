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
    ENV['VIMEO_AUTHENTICATED_TOKEN'] = '2102488a59bd9aefdc7cae80b9a0be02'
    @user = VimeoMe2::User.new(ENV['VIMEO_AUTHENTICATED_TOKEN'], 'pariyatti')
    videos = @user.get_full_video_list
    puts "videos: #{videos.length}"
    assert_equal 200, @user.client.last_request.code
  end
end
