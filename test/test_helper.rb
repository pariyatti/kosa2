ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def assert_models(exp, act, msg = nil)
    exp.id = act.id = nil
    exp.created_at = act.created_at = nil
    exp.updated_at = act.updated_at = nil
    assert_equal(exp, act, msg)
  end
end
