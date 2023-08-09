# frozen_string_literal: true
require "test_helper"

class ApiControllerApprovalTest < ActionDispatch::IntegrationTest

  # TODO: more than 3 cards - just use fixtures?

  test "approve as of 2023-08-08" do
    # NOTE: consider after(:build) instead of :strategy -
    #       https://github.com/thoughtbot/factory_bot_rails/issues/232
    p1 = create(:pali_word)
    p2 = create(:pali_word, pali: "zig")

    puts p1.inspect
    puts p2.inspect
  end

end
