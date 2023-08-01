require "test_helper"

class LoopedPaliWordTest < ActiveSupport::TestCase
  test "ingestion" do
    LoopedPaliWord.ingest_all
  end
end
