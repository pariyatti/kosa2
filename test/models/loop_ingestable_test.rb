require "test_helper"
using RefinedString

class LoopIngestableTest < ActiveSupport::TestCase
  test "strips non-standard whitespace" do
    assert_equal "this has junk in it", "\u00A0this has junk in it\u00A0".encode('utf-8').trim
  end
end