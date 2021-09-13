class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.integer :connector_type_id
      t.timestamps
    end
  end
end
