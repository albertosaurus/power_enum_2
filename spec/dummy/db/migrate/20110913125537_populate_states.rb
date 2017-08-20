class PopulateStates < ActiveRecord::Migration[4.2]
  def up
    State.enumeration_model_updates_permitted = true
    State.create!(:state_code => 'IL', :id => 1)
    State.create!(:state_code => 'WI', :id => 2)
    State.create!(:state_code => 'FL', :id => 3)
  end

  def down
    State.enumeration_model_updates_permitted = true
    State.destroy_all
  end
end
