# frozen_string_literal: true
require "test_helper"

class LoopedPaliWordSmokeTest < ActiveSupport::TestCase
  setup do
    LoopedPaliWord.ingest_all
  end

  test "exactly 400 records" do
    assert_equal 400, LoopedPaliWord.all.count
  end

  test "indexes are off-by-one" do
    assert_equal 0, LoopedPaliWord.first.index
    assert_equal 399, LoopedPaliWord.last.index
  end

  test "translations" do
    ts = LoopedPaliWord.find_by(pali: "dullabho").translations
    assert_equal "rare, difficult attainment", ts.find {|t| t.language == "eng"}.text
    assert_equal "raro, difícil de se atingir", ts.find {|t| t.language == "por"}.text
  end

  test "publishing" do
    # 2012-07-30T00:00:01
    travel_to Time.utc(2012, 07, 30, 00, 00, 01)
    LoopedPaliWord.publish_daily!
    puts PaliWord.first.inspect
    assert_models PaliWord.new(pali: "obhāsetvā", original_pali: "obhāsetvā", original_url: nil, published_at: DateTime.parse("2012-07-30T16:11:02Z")),
                  PaliWord.first
  end
end