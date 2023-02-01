source 'https://rubygems.org'

# Specify your gem's dependencies in lazy_object.gemspec
gemspec

# Development dependencies
group :development do
  gem "bundler"
  gem "rake"
  gem "yard"
end

group :development, :test do
  gem "rubocop"
  gem "rubocop-gitlab-security"
  gem "rubocop-rspec"
  gem "rubocop-performance"
  gem "rubocop-rake"

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
  gem 'rspec'
end
