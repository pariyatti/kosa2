require "test_helper"

class LoopedPaliWordTest < ActiveSupport::TestCase
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

  test "TODO: translations" do
    LoopedPaliWord.first.translations.inspect
  end

  test "TODO: other" do
    LoopedPaliWord.all.each {|lpw| puts lpw.inspect }
  end
end
