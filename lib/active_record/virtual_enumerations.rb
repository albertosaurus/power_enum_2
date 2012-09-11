# Copyright (c) 2005 Trevor Squires
# Copyright (c) 2012 Arthur Shagall
# Released under the MIT License.  See the LICENSE file for more details.

module ActiveRecord # :nodoc:

  # Implements a mechanism to synthesize enum classes for simple enums.  This is for situations where you wish to avoid
  # cluttering the models directory with your enums.
  #
  # Create a custom Rails initializer: Rails.root/config/initializers/virtual_enumerations.rb
  #
  #     ActiveRecord::VirtualEnumerations.define do |config|
  #       config.define 'ClassName',
  #                     :table_name        => 'table',
  #                     :extends           => 'SuperclassName',
  #                     :conditions        => ['something = ?', "value"],
  #                     :order             => 'column ASC',
  #                     :on_lookup_failure => :enforce_strict,
  #                     :name_column       => 'name_column',
  #                     :alias_name        => false {
  #         # class_evaled_functions
  #       }
  #     end
  #
  # Only the 'ClassName' argument is required.  :table_name is used to define a custom table name while the :extends
  # option is used to set a custom superclass.  Class names can be either camel-cased like ClassName or with
  # underscores, like class_name.  Strings and symbols are both fine.
  #
  # If you need to fine-tune the definition of the enum class, you can optionally pass in a block, which will be
  # evaluated in the context of the enum class.
  #
  # Example:
  #
  #     config.define :color, :on_lookup_failure => :enforce_strict, do
  #       def to_argb(alpha)
  #         case self.to_sym
  #         when :white
  #           [alpha, 255, 255, 255]
  #         when :red
  #           [alpha, 255, 0, 0]
  #         when :blue
  #           [alpha, 0, 0, 255]
  #         when :yellow
  #           [alpha, 255, 255, 0]
  #         when :black
  #           [alpha, 0, 0, 0]
  #         end
  #       end
  #     end
  #
  # As a convenience, if multiple enums share the same configuration, you can pass all of them to config.define.
  #
  # Example:
  #
  #     config.define :booking_status, :connector_type, :color, :order => :name
  #
  # STI is also supported:
  #
  # Example:
  #
  #     config.define :base_enum, :name_column => ;foo
  #     config.define :booking_status, :connector_type, :color, :extends => :base_enum
  module VirtualEnumerations # :nodoc:

    # Defines enumeration classes.  Passes a config object to the given block
    # which is used to define the virtual enumerations.  Call config.define for
    # each enum or enums with a given set of options.
    def self.define
      raise ArgumentError, "#{self.name}: must pass a block to define()" unless block_given?
      config = ActiveRecord::VirtualEnumerations::Config.new
      yield config
      @config = config # we only overwrite config if no exceptions were thrown
    end

    # Creates a constant for a virtual enum if a config is defined for it.
    def self.synthesize_if_defined(const)
      options = @config[const]
      return nil unless options

      class_declaration = "class #{const} < #{options[:extends]}; end"

      eval( class_declaration, TOPLEVEL_BINDING, __FILE__, __LINE__ )

      virtual_enum_class = const_get( const )

      inject_class_options( virtual_enum_class, options )

      virtual_enum_class
    end

    def self.inject_class_options( virtual_enum_class, options ) # :nodoc:
      # Declare it acts_as_enumerated
      virtual_enum_class.class_eval do
        acts_as_enumerated :conditions        => options[:conditions],
                           :order             => options[:order],
                           :on_lookup_failure => options[:on_lookup_failure],
                           :name_column       => options[:name_column],
                           :alias_name        => options[:table_name]
      end

      # If necessary, set the table name
      unless (table_name = options[:table_name]).blank?
        virtual_enum_class.class_eval do
          set_table_name table_name
        end
      end

      if block = options[:customizations_block]
        virtual_enum_class.class_eval(&block)
      end
    end
    private_class_method :inject_class_options

    # Config class for VirtualEnumerations
    class Config
      def initialize # :nodoc:
        @enumeration_defs = {}
      end

      # Creates definition(s) for one or more enums.
      def define(*args, &block)
        options = args.extract_options!
        args.compact!
        args.flatten!
        args.each do |class_name|
          camel_name = class_name.to_s.camelize
          if camel_name.blank?
            raise ArgumentError, "ActiveRecord::VirtualEnumerations.define - invalid class_name argument (#{class_name.inspect})"
          end
          if @enumeration_defs[camel_name.to_sym]
            raise ArgumentError, "ActiveRecord::VirtualEnumerations.define - class_name already defined (#{camel_name})"
          end
          options.assert_valid_keys(:table_name, :extends, :conditions, :order, :on_lookup_failure, :name_column, :alias_name)
          enum_def = options.clone
          enum_def[:extends] = if superclass = enum_def[:extends]
                                 superclass.to_s.camelize
                               else
                                 "ActiveRecord::Base"
                               end
          enum_def[:customizations_block] = block
          @enumeration_defs[camel_name.to_sym] = enum_def   
        end
      end

      # Proxies lookups to @enumeration_defs
      def [](arg)
        @enumeration_defs[arg]
      end            
    end #class Config
  end #module VirtualEnumerations
end #module ActiveRecord
