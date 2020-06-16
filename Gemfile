source 'https://rubygems.org'

# Specify your gem's dependencies in lazy_object.gemspec
gemspec

group :development do
  gem 'yard'
end

group :development, :test do
  platform :mri do
    gem 'sqlite3'
  end

  platform :jruby do
    gem 'activerecord-jdbcsqlite3-adapter'
  end

  gem 'awesome_print'
end

group :test do
  gem 'simplecov', :require => false
end

