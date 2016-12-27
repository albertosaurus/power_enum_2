require "bundler/gem_tasks"

begin
  require 'rspec/core/rake_task'
  task :default => :spec

  RSpec::Core::RakeTask.new
rescue
  puts "rspec gem is not installed"
end

namespace :version do

  desc "create a new patch version, create tag and push to github"
  task :patch_release do
    Rake::Task['version:bump:patch'].invoke
    Rake::Task['git:release'].invoke
  end

  desc "create a new minor version, create tag and push to github"
  task :minor_release do
    Rake::Task['version:bump:minor'].invoke
    Rake::Task['git:release'].invoke
  end

  desc "create a new major version, create tag and push to github"
  task :major_release do
    Rake::Task['version:bump:major'].invoke
    Rake::Task['git:release'].invoke
  end

end

