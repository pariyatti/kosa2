# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

Rails.application.configure do
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_options = { from: 'no-reply@kosa-test.pariyatti.app' }
  config.action_mailer.default_url_options = { host: 'kosa-test.pariyatti.app' }
end
