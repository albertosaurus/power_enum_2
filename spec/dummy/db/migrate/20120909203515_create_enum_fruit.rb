class CreateEnumFruit < ActiveRecord::Migration[4.2]

  def up
    create_power_enum :fruit, :name_column => :fruit_name, :description => :true

    ActiveRecord::Base.connection.execute "INSERT INTO fruits (fruit_name, description) VALUES ('apple', 'Apple');"
    ActiveRecord::Base.connection.execute "INSERT INTO fruits (fruit_name, description) VALUES ('pear', 'Pear');"
    ActiveRecord::Base.connection.execute "INSERT INTO fruits (fruit_name, description) VALUES ('peach', 'Peach');"

  end

  def down
    remove_power_enum :fruit
  end

end
