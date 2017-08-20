class CreateAdapters < ActiveRecord::Migration[4.2]
  def change
    create_table :adapters do |t|
      t.integer :connector_type_id

      t.timestamps
    end
  end
end
