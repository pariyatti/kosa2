require "test_helper"

class StatusControllerTest < ActionDispatch::IntegrationTest
  test "should get ping" do
    get status_ping_url
    assert_response :success
  end

  test "should get status" do
    get status_status_url
    assert_response :success
  end
end
