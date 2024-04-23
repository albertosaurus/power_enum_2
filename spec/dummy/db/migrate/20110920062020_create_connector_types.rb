class CreateConnectorTypes < ActiveRecord::Migration[4.2]
  def change
    create_power_enum :connector_type,
                :description => true,
                :name_limit  => 50,
                :active      => true,
                :timestamps  => true do |t|
      t.boolean :has_sound, :null => false
    end
  end
end
