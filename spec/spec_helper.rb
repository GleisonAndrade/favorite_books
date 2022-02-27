require 'simplecov'
# require 'capybara/rspec'

SimpleCov.start do
  add_group 'Config', 'config'
  add_group 'Controllers', 'app/controllers'
  add_group 'Libs', 'lib'
  add_group 'Models', 'app/models'
  add_group 'Policies', 'app/policies'
  add_group 'Serializers', 'app/serializers'
  add_group 'Specs', 'spec'
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    # expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

# Capybara.register_driver :chrome_headless do |app|
#   Capybara::Selenium::Driver.new app,
#     browser: :chrome,
#     clear_session_storage: true,
#     clear_local_storage: true,
#     capabilities: [Selenium::WebDriver::Chrome::Options.new(
#       args: %w[headless disable-gpu no-sandbox window-size=1024,768],
#     )]
# end
