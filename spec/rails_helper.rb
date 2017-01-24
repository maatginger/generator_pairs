ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'database_cleaner'
require 'capybara-screenshot/rspec'
require 'support/factory_girl'
require 'factory_girl_rails'


Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }


ActiveRecord::Migration.maintain_test_schema!

Capybara.register_driver(:poltergeist) {|app|
Capybara::Poltergeist::Driver.new(app, js_errors: true) }
Capybara.default_driver = Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|

  config.fixture_path = "#{::Rails.root}/spec/fixtures"


  config.use_transactional_fixtures = false


  config.infer_spec_type_from_file_location!


  config.filter_rails_from_backtrace!

end
