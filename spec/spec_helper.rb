ENV["RAILS_ENV"] = "test"

unless ENV['TRAVIS']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec/'
  end
end

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
end
