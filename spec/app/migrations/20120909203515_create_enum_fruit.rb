class CreateEnumFruit < ActiveRecord::Migration

  def up
    create_enum :fruit, :name_column => :fruit_name, :description => :true

    ActiveRecord::Base.connection.execute "INSERT INTO fruits (fruit_name, description) VALUES ('apple', 'Apple');"
    ActiveRecord::Base.connection.execute "INSERT INTO fruits (fruit_name, description) VALUES ('pear', 'Pear');"
    ActiveRecord::Base.connection.execute "INSERT INTO fruits (fruit_name, description) VALUES ('peach', 'Peach');"

  end

  def down
    remove_enum :fruit
  end

end
