source 'https://rubygems.org'

# Specify your gem's dependencies in lazy_object.gemspec
gemspec

group :development do
  gem 'yard'
end

group :development, :test do
  platform :mri do
    # TODO: Do not specify version once Rails can work with SQLite >= 1.4
    gem 'sqlite3', '~> 1.3.6'
  end

  platform :jruby do
    gem 'activerecord-jdbcsqlite3-adapter'
  end

  gem 'awesome_print'
end

group :test do
  gem 'simplecov', :require => false
end

