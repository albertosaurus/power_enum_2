class CreateEnumFastener < ActiveRecord::Migration[5.0]

  def up
    create_enum :fastener

    ActiveRecord::Base.connection.execute "INSERT INTO fasteners (name) VALUES ('bolt');"

    create_table :parts do |t|
      t.integer :fastener_id, null: false

      t.integer :lock_version, default: 0, null: false
      t.timestamps
    end
  end

  def down
    remove_enum :fastener
  end
end
