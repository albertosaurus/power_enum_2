class CreateConnectorTypes < ActiveRecord::Migration
  def change
    create_enum :connector_type, :description => true, :name_limit => 50
  end
end
