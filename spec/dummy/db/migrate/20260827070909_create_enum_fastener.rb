class CreateEnumFastener < ActiveRecord::Migration[5.0]

  def up
    create_enum :fastener

    ActiveRecord::Base.connection.execute "INSERT INTO fasteners (name) VALUES ('bolt');"
  end

  def down
    remove_enum :fastener
  end
end
