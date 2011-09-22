module PowerEnum::Schema
  module SchemaStatements

    def self.included(base)
      base::AbstractAdapter.class_eval do
        include PowerEnum::Schema::AbstractAdapter
      end
    end

  end

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
    #
    # ===== Examples
    # ====== Basic Enum
    #  create_enum :connector_type
    # is the equivalent of
    #  create_table :connector_types do |t|
    #    t.string :name, :null => false
    #    t.timestamps
    #  end
    #
    # ====== Advanced Enum
    #  create_enum :connector_type, :name_column => :connector, :name_limit => 50, :description => true, :desc_limit => 100, :active => true
    # is the equivalent of
    #  create_table :connector_types do |t|
    #    t.string :connector, :limit => 50, :null => false
    #    t.string :description, :limit => 100
    #    t.boolean :active, :null => false, :default => true
    #    t.timestamps
    #  end
    #
    def create_enum(enum_name, options = {})
      enum_table_name = enum_name.pluralize
      name_column = options[:name_column] || :name
      generate_description = !!options[:description]
      generate_active = !!options[:active]
      name_limit = options[:name_limit]
      desc_limit = options[:desc_limit]

      create_table enum_table_name do |t|
        t.string name_column, :limit => name_limit, :null => false
        if generate_description
          t.string :description, :limit => desc_limit
        end
        if generate_active
          t.boolean :active, :null => false, :default => true
        end

        t.timestamps
      end

      add_index enum_table_name, [name_column], :unique => true

    end

    # Drops the enum table.  +enum_name+ will be automatically pluralized.
    #
    # ===== Example
    #  remove_enum :connector_type
    # is the equivalent of
    #  drop_table :connector_types
    def remove_enum(enum_name)
      drop_table enum_name.pluralize
    end

  end

end