class CreateConnectorTypes < ActiveRecord::Migration
  def change
    create_enum :connector_type,
                :description => true,
                :name_limit  => 50,
                :active      => true,
                :timestamps  => true do |t|
      t.boolean :has_sound, :null => false
    end
  end
end
