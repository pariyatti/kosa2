require "test_helper"
using RefinedString

class LoopIngestableTest < ActiveSupport::TestCase
  test "strips non-standard whitespace" do
    assert_equal "this has junk in it", "\u00A0this has junk in it\u00A0".encode('utf-8').trim
  end

  test "ingest is idempotent" do
    filemask = file_fixture_str('idempotent_pali_words_one_loop_%s.txt')
    LoopedPaliWord.ingest_all_from(filemask)
    first = LoopedPaliWord.find_sole_by(pali: "ālokite")
    LoopedPaliWord.ingest_all_from(filemask)
    last = LoopedPaliWord.where(pali: "ālokite").last
    assert_equal first.updated_at, last.updated_at
  end

  test "idempotent ingest permits duplicates across languages" do
    # ...because sometimes English translations show up in other language files, verbatim.
    filemask = file_fixture_str('idempotent_repeat_pali_words_one_loop_%s.txt')
    LoopedPaliWord.ingest_all_from(filemask)
    sampanno = LoopedPaliWord.find_sole_by(pali: "sampanno")
    assert_equal 2, sampanno.translations.count
  end
end