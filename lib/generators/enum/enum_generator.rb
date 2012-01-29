# Copyright (c) 2011 Arthur Shagall
# Released under the MIT license.  See LICENSE for details.

# Generator for PowerEnum
class EnumGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :enum_name, :type => :string
  class_option :migration, :type => :boolean, :default => true, :desc => 'Generate migration for the enum'
  class_option :fixture, :type => :boolean, :default => false, :desc => 'Generate fixture for the enum'

  def generate_model
    template 'model.rb.erb', "app/models/#{file_name}.rb"
  end
  
  def generate_migration
    template migration_template, "db/migrate/#{migration_file_name}.rb" if options.migration?
  end

  hook_for :test_framework, :as => :model do |enum_generator_instance, test_generator_class|
    # Need to do this because I'm changing the default value of the 'fixture' option.
    enum_generator_instance.invoke( test_generator_class, [enum_generator_instance.enum_name], { 'fixture' => enum_generator_instance.options.fixture? } )
  end
  
  no_tasks do

    def file_name
      enum_name.underscore
    end
  
    def enum_class_name
      file_name.camelize
    end
    
    def current_migration_number
      dirname = "#{Rails.root}/db/migrate/[0-9]*_*.rb"
      Dir.glob(dirname).collect do |file|
        File.basename(file).split("_").first.to_i
      end.max.to_i
    end
    
    def next_migration_number
      # Lifted directly from ActiveRecord::Generators::Migration
      # Unfortunately, no API is provided by Rails at this time.
      next_migration_number = current_migration_number + 1
      if ActiveRecord::Base.timestamped_migrations
        [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d" % next_migration_number].max
      else
        "%.3d" % next_migration_number
      end
    end
    
    def migration_name
      "create_enum_#{file_name}"
    end
    
    def migration_class_name
      migration_name.camelize
    end
    
    def migration_file_name
      "#{next_migration_number}_#{migration_name}"
    end
    
    def migration_template
      Rails.version < '3.1' ? 'rails30_migration.rb.erb' : 'rails31_migration.rb.erb'
    end

  end
end
