ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
using RefinedHash

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def self.smoke_setup(&block)
    if ENV["RAILS_TEST_ENV"] == "smoke" || ENV["TEAMCITY_RAKE_RUNNER_MODE"] == 'idea'
      setup(&block)
    end
  end

  def self.smoke_test(name, &block)
    if ENV["RAILS_TEST_ENV"] == "smoke" || ENV["TEAMCITY_RAKE_RUNNER_MODE"] == 'idea'
      test(name, &block)
    end
  end

  def assert_models(exp, act, msg = nil)
    assert_model_hashes(exp.attributes, act.attributes)
  end

  def assert_model_hashes(exp, act, msg = nil)
    exp_hash = exp.except("id").except("created_at").except("updated_at")
    act_hash = act.except("id").except("created_at").except("updated_at")
    exp_hash.keys.each do |k|
      if exp_hash[k] == act_hash[k]
        exp_hash.except! k
        act_hash.except! k
      end
    end
    assert_equal(exp_hash, act_hash, msg)
  end

  def assert_json(exp, act, msg = nil)
    exp2 = exp.update_key("url") {|u| strip_uuid(u) }
      .update_key("audio") {|a| nil }
      .then {|e| strip_ids!(e) }
    act2 = act.update_key("url") {|u| strip_uuid(u) }
      .update_key("audio") {|a| nil }
      .then {|a| strip_ids!(a) }
    assert_model_hashes exp2, act2
  end

  def assert_attachment_path(exp, act, msg = nil)
    exp2 = strip_attachment_path_id exp
    act2 = strip_attachment_path_id act
    assert_equal exp2, act2
  end

  def assert_attachment_url(exp, act, msg = nil)
    exp2 = strip_attachment_url_id exp
    act2 = strip_attachment_url_id act
    assert_equal exp2, act2
  end

  def strip_ids!(j)
    j["translations"].each_with_index do |t, i|
      j["translations"][i] = t.update_key("id") {|id| strip_uuid(id) }
    end
    j
  end

  def strip_uuid(s)
    s.gsub(/[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}/, "UUID-WAS-HERE")
  end

  def strip_attachment_path_id(s)
    return unless s
    s.gsub(/(\/rails\/active_storage\/blobs\/redirect\/).*(\/[a-zA-Z0-9_]+\.mp3\?disposition=attachment)/, '\1ID-WAS-HERE\2')
  end

  def strip_attachment_url_id(s)
    return unless s
    s.gsub(/(http:\/\/kosa-test\.pariyatti\.app\/rails\/active_storage\/blobs\/redirect\/).*(\/[a-zA-Z0-9_]+\.mp3)/, '\1ID-WAS-HERE\2')
  end

end
