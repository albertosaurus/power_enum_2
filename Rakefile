begin
  require "jeweler"
  Jeweler::Tasks.new do |gem|
    gem.name = "enumerations_mixin"
    gem.summary = "Allows you to treat instances of your ActiveRecord models as though they were an enumeration of values"
    gem.description = "Allows you to treat instances of your ActiveRecord models as though they were an enumeration of values"
    gem.email = "arthur.shagall@gmail.com"
    gem.homepage = "http://github.com/albertosaurus/enumerations_mixin"
    gem.authors = ["Trevor Squires", "Pivotal Labs", 'Arthur Shagall', 'Sergey Potapov']
    gem.files = Dir["{lib}/**/*"] + Dir["{examples}/**/*"]
    gem.add_dependency('rails', '>= 3.0.0')
    gem.add_development_dependency('sqlite3')
    gem.add_development_dependency('rspec')
    gem.add_development_dependency('jeweler')
  end
rescue
  puts "Jeweler or one of its dependencies is not installed."
end


begin
  require 'rspec/core/rake_task'
  task :default => :spec

  RSpec::Core::RakeTask.new do |t|
    t.rspec_opts = ['--color', '--backtrace', '--format nested']
  end
rescue
  puts "rspec gem is not installed"
end

namespace :version do

  desc "create a new version, create tag and push to github"

  task :patch_release do
    Rake::Task['version:bump:patch'].invoke
    Rake::Task['git:release'].invoke
  end

  task :minor_release do
    Rake::Task['version:bump:minor'].invoke
    Rake::Task['git:release'].invoke
  end

  task :major_release do
    Rake::Task['version:bump:major'].invoke
    Rake::Task['git:release'].invoke
  end

end

