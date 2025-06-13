# frozen_string_literal: true

require 'rails'
require 'active_record'
require 'testing/rspec'

require "power_enum/has_enumerated"
require "power_enum/enumerated"
require "power_enum/reflection"

require "power_enum/schema/schema_statements"
require "power_enum/migration/command_recorder"

require "active_record/virtual_enumerations"

# Power Enum allows you to treat instances of your ActiveRecord models as
# though they were an enumeration of values. It allows you to cleanly solve
# many of the problems that the traditional Rails alternatives handle poorly
# if at all. It is particularly suitable for scenarios where your Rails
# application is not the only user of the database, such as when it's used for
# analytics or reporting.
module PowerEnum
  class Engine < Rails::Engine

    initializer 'power_enum' do
      ActiveSupport.on_load(:active_record) do
        include PowerEnum::Enumerated
        include PowerEnum::HasEnumerated

        ActiveRecord::Base.module_eval do
          class << self
            prepend ::PowerEnum::Reflection
          end
        end

        ActiveRecord::ConnectionAdapters.module_eval do
          include PowerEnum::Schema::SchemaStatements
        end

        ActiveRecord::Migration::CommandRecorder.class_eval do
          include PowerEnum::Migration::CommandRecorder
        end
      end

    end
  end
end
