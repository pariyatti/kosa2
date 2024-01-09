# frozen_string_literal: true
#noinspection RubyResolve
require "test_helper"

class LoopedDohaSmokeTest < ActiveSupport::TestCase

  smoke_setup do
    Rails.logger.level = 2
    LoopedDoha.ingest_all
  end

  teardown do
    Rails.logger.level = 0
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
    assert_equal doha_text, Doha.first.doha
    assert_models Doha.new(doha: doha_text,
                           original_doha: nil, original_url: nil,
                           original_audio_url: "https://download.pariyatti.org/dohas/086_Doha.mp3",
                           published_date: Date.new(2012, 7, 30),
                           published_at: DateTime.parse("2012-07-30T17:11:02Z")),
                  Doha.first
  end

  smoke_test "publish 2023-07-30" do
    LoopedDoha.publish_specific!(Date.new(2023, 7, 30))
    assert_equal 1, Doha.count
    doha_text = "Bīte kṣaṇa ko yāda kara, \nmata birathā akuḷāya. \nBītā dhana to mila sake, \nbītā kṣaṇa nahīṅ āya. \n\nBīte kṣaṇa ko yāda kara, \nmata birathā akuḷāya. \nBītā dhana to phir mila, \nbītā kṣaṇa nahīṅ āya."
    assert_equal doha_text, Doha.first.doha
  end

end
