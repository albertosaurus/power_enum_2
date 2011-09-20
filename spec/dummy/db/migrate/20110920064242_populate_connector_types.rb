class PopulateConnectorTypes < ActiveRecord::Migration
  def up
    ConnectorType.enumeration_model_updates_permitted = true
    ConnectorType.create!(:name => 'DVI', :description => 'Digital Video Interface', :id => 1)
    ConnectorType.create!(:name => 'VGA', :description => 'Video Graphics Array', :id => 2)
    ConnectorType.create!(:name => 'HDMI', :description => 'High-Definition Media Interface', :id => 3)
  end

  def down
    ConnectorType.enumeration_model_updates_permitted = true
    ConnectorType.destroy_all
  end
end
