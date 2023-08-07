ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

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
    # TODO: url won't match even once we have a route for it, but be aware it
    #       should exist eventually
    exp2 = strip_ids! exp.except("url")
    act2 = strip_ids! act.except("url")
    assert_model_hashes exp2, act2
  end

  def strip_ids!(j)
    # TODO: ultimately, we should assert that ids are UUIDs (at least)
    j["translations"].each {|t| t.delete("id")}
    j
  end
end
