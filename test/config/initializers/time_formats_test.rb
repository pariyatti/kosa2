# frozen_string_literal: true

require "test_helper"

class TimeFormatsTest < ActiveSupport::TestCase
  test "default Time.to_fs should be ISO / kosa" do
    assert_equal "2012-07-30T11:11:02Z", DateTime.parse("2012-07-30T11:11:02Z").to_fs
  end

  test "default Date.to_fs should be ISO / kosa" do
    assert_equal "2004-07-30", Date.new(2004, 07, 30).to_fs
  end
end
