# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'devise'
require 'support/factory_bot'
require_relative 'support/controller_macros'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  # JavaScript support
  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless
  end

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include Warden::Test::Helpers

  config.extend ControllerMacros, :type => :controller
  config.extend ControllerMacros, :type => :feature
  config.extend ControllerMacros, :type => :system
end

# Shoulda::Matchers.configure do |config|
#   config.integrate do |with|
#     with.test_framework :rspec
#     with.library :rails
#   end
# end
