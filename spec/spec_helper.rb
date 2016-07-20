if ENV.fetch("COVERAGE", false)
  require "simplecov"

  if ENV["CIRCLE_ARTIFACTS"]
    dir = File.join(ENV["CIRCLE_ARTIFACTS"], "coverage")
    SimpleCov.coverage_dir(dir)
  end

  require 'simplecov-rcov'
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start "rails"
end

require "webmock/rspec"
require "capybara/poltergeist"

Capybara.register_driver :poltergiest do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: true, debug: true)
end

Capybara.javascript_driver = :poltergeist

# http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.example_status_persistence_file_path = "tmp/rspec_examples.txt"
  config.order = :random

end

WebMock.disable_net_connect!(allow_localhost: true)
