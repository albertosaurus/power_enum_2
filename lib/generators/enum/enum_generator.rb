# Copyright (c) 2011 Arthur Shagall
# Released under the MIT license.  See LICENSE for details.

# Generator for PowerEnum
class EnumGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :enum_name, :type => :string
  class_option :migration, :type => :boolean, :default => true, :desc => 'Generate migration for the enum'
  class_option :fixture, :type => :boolean, :default => false, :desc => 'Generate fixture for the enum'

  # Generates the enum ActiveRecord model.
  def generate_model
    template 'model.rb.erb', "app/models/#{file_name}.rb"
  end

  # Generates the migration to create the enum table.
  def generate_migration
    template migration_template, "db/migrate/#{migration_file_name}.rb" if options.migration?
  end

  hook_for :test_framework, :as => :model do |enum_generator_instance, test_generator_class|
    # Need to do this because I'm changing the default value of the 'fixture' option.
    enum_generator_instance.invoke( test_generator_class, [enum_generator_instance.enum_name], { 'fixture' => enum_generator_instance.options.fixture? } )
  end
  
  no_tasks do

    # Returns the file name of the enum model without the .rb extension.
    def file_name
      enum_name.underscore
    end

    # Returns the class name of the enum.
    def enum_class_name
      file_name.camelize
    end

    # Returns the number of the last migration.
    def current_migration_number
      dirname = "#{Rails.root}/db/migrate/[0-9]*_*.rb"
      Dir.glob(dirname).collect do |file|
        File.basename(file).split("_").first.to_i
      end.max.to_i
    end

    # Returns the next upcoming migration number.  Sadly, Rails has no API for
    # this, so we're reduced to copying from ActiveRecord::Generators::Migration
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

    # Derives the name for the migration, something like 'create_enum_fruit'
    def migration_name
      "create_enum_#{file_name}"
    end

    # Returns the class name of our migration
    def migration_class_name
      migration_name.camelize
    end

    # Generates and returns the filename of our migration
    def migration_file_name
      "#{next_migration_number}_#{migration_name}"
    end

    # Returns the name of the template file for the migration.
    def migration_template
      'rails31_migration.rb.erb'
    end

  end
end
