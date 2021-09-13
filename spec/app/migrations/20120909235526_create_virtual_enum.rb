class CreateVirtualEnum < ActiveRecord::Migration
  def up
    create_enum :virtual_enum

    ActiveRecord::Base.connection.execute "INSERT INTO virtual_enums (name) VALUES ('virtual_enum');"
  end

  def down
    remove_enum :virtual_enum
  end
end
