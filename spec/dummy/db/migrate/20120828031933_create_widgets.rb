class CreateWidgets < ActiveRecord::Migration[4.2]
  def change
    create_table :widgets do |t|
      t.integer :connector_type_id
      t.timestamps
    end
  end
end
