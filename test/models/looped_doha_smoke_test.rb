# frozen_string_literal: true
require "test_helper"

class LoopedDohaSmokeTest < ActiveSupport::TestCase

  setup do
    LoopedDoha.ingest_all
  end

  test "exactly 400 records" do
    assert_equal 122, LoopedDoha.all.count
  end

  test "all have 4 languages" do
    LoopedDoha.all.each do |ld|
      assert_equal 4, ld.translations.count, "LoopedDoha = #{ld.inspect}\nTranslations = #{ld.translations.inspect}"
    end
  end

end
