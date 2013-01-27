ENV["RAILS_ENV"] = "test"
require 'simplecov'
SimpleCov.start do
  add_filter 'spec/'
end


require File.expand_path("../dummy/config/environment.rb",  __FILE__)

RSpec.configure do |config|
end
