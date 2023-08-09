# frozen_string_literal: true
#noinspection RubyResolve
require "test_helper"

class LoopedDohaSmokeTest < ActiveSupport::TestCase

  smoke_setup do
    LoopedDoha.ingest_all
  end

  smoke_test "exactly 122 records" do
    assert_equal 122, LoopedDoha.all.count
  end

  smoke_test "all have 4 languages" do
    LoopedDoha.all.each do |ld|
      assert_equal 4, ld.translations.count, "LoopedDoha = #{ld.inspect}\nTranslations = #{ld.translations.inspect}"
    end
  end

  smoke_test "publishing 2012" do
    doha_text = "Bhogata bhogata bhogate, \nbandhana bandhate jāṅya. \nDekhata dekhata dekhate, \nbandhana khulate jāṅya. \n\nBhogata bhogata bhogate, \nGanthey bandhate jāṅya. \nDekhata dekhata dekhate, \nGanthey khulate jāṅya."
    # 2012-07-30T00:00:01
    travel_to Time.utc(2012, 7, 30, 0, 0, 1)
    LoopedDoha.publish_daily!
    puts Doha.first.inspect
    assert_equal doha_text, Doha.first.doha
    assert_models Doha.new(doha: doha_text,
                           original_doha: nil, original_url: nil,
                           original_audio_url: "https://download.pariyatti.org/dohas/086_Doha.mp3", published_at: DateTime.parse("2012-07-30T17:11:02Z")),
                  Doha.first
  end

end
