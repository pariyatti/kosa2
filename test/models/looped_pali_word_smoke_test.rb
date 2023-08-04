# frozen_string_literal: true
require "test_helper"

class LoopedPaliWordSmokeTest < ActiveSupport::TestCase
  setup do
    LoopedPaliWord.ingest_all
  end

  test "exactly 400 records" do
    assert_equal 400, LoopedPaliWord.all.count
  end

  test "all have 2 languages" do
    LoopedPaliWord.all.each do |lpw|
      assert_equal 2, lpw.translations.count
    end
  end

  test "indexes are off-by-one" do
    assert_equal 0, LoopedPaliWord.first.index
    assert_equal 399, LoopedPaliWord.last.index
  end

  test "translations" do
    ts = LoopedPaliWord.find_by(pali: "dullabho").translations
    assert_equal "rare, difficult attainment", ts.find {|t| t.language == "eng"}.translation
    assert_equal "raro, difícil de se atingir", ts.find {|t| t.language == "por"}.translation
  end

  test "publishing 2012" do
    # 2012-07-30T00:00:01
    travel_to Time.utc(2012, 7, 30, 0, 0, 1)
    LoopedPaliWord.publish_daily!
    puts PaliWord.first.inspect
    assert_models PaliWord.new(pali: "obhāsetvā", original_pali: "obhāsetvā", original_url: nil, published_at: DateTime.parse("2012-07-30T16:11:02Z")),
                  PaliWord.first
  end

  test "publishing 2023" do
    # 2012-07-30T00:00:01
    travel_to Time.utc(2023, 8, 3, 0, 0, 1)
    LoopedPaliWord.publish_daily!
    puts PaliWord.first.inspect
    assert_models PaliWord.new(pali: "pubbe", original_pali: "pubbe", original_url: nil, published_at: DateTime.parse("2023-08-03T16:11:02Z")),
                  PaliWord.first
  end
end
