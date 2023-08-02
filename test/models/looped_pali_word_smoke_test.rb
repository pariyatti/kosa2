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

end