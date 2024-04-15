class CreateVirtualEnum < ActiveRecord::Migration[4.2]
  def up
    create_power_enum :virtual_enum

    ActiveRecord::Base.connection.execute "INSERT INTO virtual_enums (name) VALUES ('virtual_enum');"
  end

  def down
    remove_power_enum :virtual_enum
  end
end
