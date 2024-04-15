# Copyright (c) 2011 Arthur Shagall
# Released under the MIT license.  See LICENSE for details.

# Extensions to the migrations DSL
module PowerEnum::Schema
  # Patches AbstractAdapter with {PowerEnum::Schema::AbstractAdapter}
  module SchemaStatements

    def self.included(base) # :nodoc:
      base::AbstractAdapter.class_eval do
        include PowerEnum::Schema::AbstractAdapter
      end
    end

  end

  # Implementation of the PowerEnum extensions to the migrations DSL.
  module AbstractAdapter

    # Creates a new enum table.  +enum_name+ will be automatically pluralized.
    #
    # === Supported options
    # [:name_column]
    #   Specify the column name for name of the enum.  By default it's :name.
    #   This can be a String or a Symbol
    # [:description]
    #   Set this to <tt>true</tt> to have a 'description' column generated.
    # [:name_limit]
    #   Set this define the limit of the name column.
    # [:desc_limit]
    #   Set this to define the limit of the description column.
    # [:active]
    #   Set this to <tt>true</tt> to have a boolean 'active' column generated.  The 'active' column will have the options of NOT NULL and DEFAULT TRUE.
    # [:timestamps]
    #   Set this to <tt>true</tt> to have timestamp columns (created_at and updated_at) generated.
    # [:table_options]
    #   A hash of options to pass to the 'create_table' method.
    #
    # You can also pass in a block that takes a table object as an argument, like <tt>create_table</tt>.
    #
    # ===== Examples
    # ====== Basic Enum
    #  create_power_enum :connector_type
    # is the equivalent of
    #  create_table :connector_types do |t|
    #    t.string :name, :null => false
    #  end
    #  add_index :connector_types, [:name], :unique => true
    #
    # ====== Advanced Enum
    #  create_power_enum :connector_type, :name_column   => :connector,
    #                               :name_limit    => 50,
    #                               :description   => true,
    #                               :desc_limit    => 100,
    #                               :active        => true,
    #                               :timestamps    => true,
    #                               :table_options => {:primary_key => :foo}
    # is the equivalent of
    #  create_table :connector_types, :primary_key => :foo do |t|
    #    t.string :connector, :limit => 50, :null => false
    #    t.string :description, :limit => 100
    #    t.boolean :active, :null => false, :default => true
    #    t.timestamps
    #  end
    #  add_index :connector_types, [:connector], :unique => true
    #
    # ====== Customizing Enum with a block
    #  create_power_enum :connector_type, :description => true do |t|
    #    t.boolean :has_sound
    #  end
    # is the equivalent of
    #  create_table :connector_types do |t|
    #    t.string :name, :null => false
    #    t.string :description
    #    t.boolean :has_sound
    #  end
    #  add_index :connector_types, [:connector], :unique => true
    #
    # Notice that a unique index is automatically created in each case on the proper name column.
    def create_power_enum(enum_name, options = {}, &block)
      enum_table_name = enum_name.pluralize

      # For compatibility with PgPower/PgSaurus
      schema_name = options[:schema]
      enum_table_name  = "#{schema_name}.#{enum_table_name}" if schema_name

      name_column = options[:name_column] || :name
      generate_description = !!options[:description]
      generate_active = !!options[:active]
      generate_timestamps = !!options[:timestamps]
      name_limit = options[:name_limit]
      desc_limit = options[:desc_limit]
      table_options = options[:table_options] || {}

      create_table enum_table_name, **table_options do |t|
        t.string name_column, :limit => name_limit, :null => false
        if generate_description
          t.string :description, :limit => desc_limit
        end
        if generate_active
          t.boolean :active, :null => false, :default => true
        end
        if generate_timestamps
          t.timestamps
        end
        if block_given?
          yield t
        end
      end

      add_index enum_table_name, [name_column], :unique => true

    end

    # Drops the enum table.  +enum_name+ will be automatically pluralized.
    #
    # ===== Example
    #  remove_power_enum :connector_type
    # is the equivalent of
    #  drop_table :connector_types
    def remove_power_enum(enum_name)
      drop_table enum_name.pluralize
    end

  end

end
