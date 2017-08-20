class CreateStates < ActiveRecord::Migration[4.2]
  def change
    create_table :states do |t|
      t.string :state_code

      t.timestamps
    end
  end
end
