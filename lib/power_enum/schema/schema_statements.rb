module PowerEnum::Schema
  module SchemaStatements

    def self.included(base)
      base::AbstractAdapter.class_eval do
        include PowerEnum::Schema::AbstractAdapter
      end
    end

  end

  module AbstractAdapter

    def create_enum(enum_name, options = {})
      enum_table_name = enum_name.pluralize
      name_column = options[:name_column] || :name
      generate_description = !!options[:description]
      name_limit = options[:name_limit]
      desc_limit = options[:desc_limit]

      create_table enum_table_name do |t|
        t.string name_column, :limit => name_limit, :null => false
        if generate_description
          t.string :description, :limit => desc_limit
        end

        t.timestamps
      end

      add_index enum_table_name, [name_column], :unique => true

    end

    def remove_enum(enum_name)
      drop_table enum_name.pluralize
    end

  end

end