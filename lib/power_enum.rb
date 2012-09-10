require "rails"
require 'testing/rspec'

class PowerEnum < Rails::Engine
  config.autoload_paths << File.expand_path(File.join(__FILE__, "../"))

  initializer 'power_enum' do
    ActiveSupport.on_load(:active_record) do
      include PowerEnum::Enumerated
      include PowerEnum::HasEnumerated
      include PowerEnum::Reflection

      ActiveRecord::ConnectionAdapters.module_eval do
        include PowerEnum::Schema::SchemaStatements
      end

      if defined?(ActiveRecord::Migration::CommandRecorder)
        ActiveRecord::Migration::CommandRecorder.class_eval do
          include PowerEnum::Migration::CommandRecorder
        end
      end

      # patch Module to support VirtualEnumerations
      ::Module.module_eval do

        alias_method :enumerations_original_const_missing, :const_missing

        # Override const_missing to see if VirtualEnumerations can create it.
        def const_missing(const_id)
          # let rails have a go at loading it
          enumerations_original_const_missing(const_id)
        rescue NameError
          # now it's our turn
          ActiveRecord::VirtualEnumerations.synthesize_if_defined(const_id) or raise
        end

      end
    end

  end
end
