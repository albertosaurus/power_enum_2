# Copyright (c) 2005 Trevor Squires
# Released under the MIT License.  See the LICENSE file for more details.

module ActiveRecord # :nodoc:

  # Implements a mechanism to synthesize enum classes for simple enums.
  module VirtualEnumerations # :nodoc:

    # See the virtual_enumerations_sample.rb
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

      conditions     = options[:conditions].inspect
      order          = options[:order].inspect
      lookup_handler = options[:on_lookup_failure].inspect
      name_column    = options[:name_column].inspect
      alias_name     = options[:alias_name] || 'nil'

      table_name     = options[:table_name].nil? ? '' : "set_table_name(#{options[:table_name].inspect})"

      eval(<<-end_eval, TOPLEVEL_BINDING, __FILE__, __LINE__)
        class #{const} < #{options[:extends]}
          acts_as_enumerated  :conditions        => #{conditions},
                              :order             => #{order},
                              :on_lookup_failure => #{lookup_handler},
                              :name_column       => #{name_column},
                              :alias_name        => #{alias_name}
          #{table_name}
        end
      end_eval

      virtual_enum_class = const_get(const)
      if options[:post_synth_block]
        virtual_enum_class.class_eval(&options[:post_synth_block])
      end
      virtual_enum_class
    end

    # Config class for VirtualEnumerations
    class Config
      def initialize # :nodoc:
        @enumeration_defs = {}
      end

      # Creates definition(s) for one or more enums.
      def define(arg, options = {}, &synth_block)
        (arg.is_a?(Array) ? arg : [arg]).each do |class_name|
          camel_name = class_name.to_s.camelize
          if camel_name.blank?
            raise ArgumentError, "ActiveRecord::VirtualEnumerations.define - invalid class_name argument (#{class_name.inspect})"
          end
          if @enumeration_defs[camel_name.to_sym]
            raise ArgumentError, "ActiveRecord::VirtualEnumerations.define - class_name already defined (#{camel_name})"
          end
          options.assert_valid_keys(:table_name, :extends, :conditions, :order, :on_lookup_failure, :name_column, :alias_name)
          enum_def = options.clone
          enum_def[:extends] ||= "ActiveRecord::Base"
          enum_def[:post_synth_block] = synth_block
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
