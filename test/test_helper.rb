ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def assert_models(exp, act, msg = nil)
    exp_hash = exp.attributes.except("id").except("created_at").except("updated_at")
    act_hash = act.attributes.except("id").except("created_at").except("updated_at")
    assert_equal(exp_hash, act_hash, msg)
  end
end
