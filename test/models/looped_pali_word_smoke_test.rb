# frozen_string_literal: true
require "test_helper"

class LoopedPaliWordSmokeTest < ActiveSupport::TestCase

  # NOTE: LoopedPaliWord does not use 'smoke_setup' and 'smoke_test'
  #       because it does not need to download any MP3s.
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
    travel_to Time.utc(2012, 7, 30, 0, 0, 1)
    LoopedPaliWord.publish_tomorrow!
    puts PaliWord.first.inspect
    assert_models PaliWord.new(pali: "tenupasaṅkami", original_pali: "tenupasaṅkami", original_url: nil,
                               published_at: DateTime.parse("2012-07-31T00:00:00Z"),
                               published_date: Date.new(2012, 7, 31)),
                  PaliWord.first
  end

  test "publishing 2023" do
    travel_to Time.utc(2023, 8, 2, 0, 0, 1)
    LoopedPaliWord.publish_tomorrow!
    assert_models PaliWord.new(pali: "pubbe", original_pali: "pubbe", original_url: nil,
                               published_at: DateTime.parse("2023-08-03T00:00:00Z"),
                               published_date: Date.new(2023, 8, 3)),
                  PaliWord.first
  end

  test "publish 2023-07-30" do
    LoopedPaliWord.publish_specific!(Date.new(2023, 7, 30))
    assert_equal 1, PaliWord.count
    pali = "bālānaṃ"
    assert_equal pali, PaliWord.first.pali
  end

end
