ENV["RACK_ENV"] = "test"

require File.expand_path("../../config/environment", __FILE__)
abort("DATABASE_URL environment variable is set") if ENV["DATABASE_URL"]

require "rspec/rails"
require "spec_helper.rb"

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |file| require file }

module Features
  # Extend this module in spec/support/features/*.rb
  include Formulaic::Dsl
end

RSpec.configure do |config|
  config.include Features, type: :feature
  config.include Features::SessionHelpers, type: :feature
  config.include Devise::TestHelpers, type: :controller
  config.include Warden::Test::Helpers
  config.before :suite do
    Warden.test_mode!
  end
  config.after :each do
    Warden.test_reset!
  end
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!

# Allow JS specs to work.
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.strategy =
      if example.metadata[:js]
        :truncation
      else
        :transaction
      end
    DatabaseCleaner.start
    example.run
    if example.metadata[:js]
      Capybara.reset_sessions!
    else
      DatabaseCleaner.clean
    end
  end
end

ActiveRecord::Migration.maintain_test_schema!
