class PopulateConnectorTypes < ActiveRecord::Migration[4.2]
  def up
    ConnectorType.enumeration_model_updates_permitted = true
    
    ConnectorType.create!(:name        => 'DVI',
                          :description => 'Digital Video Interface',
                          :id          => 1,
                          :active      => true,
                          :has_sound   => false)

    ConnectorType.create!(:name        => 'VGA',
                          :description => 'Video Graphics Array',
                          :id          => 2,
                          :active      => false,
                          :has_sound   => false)

    ConnectorType.create!(:name        => 'HDMI',
                          :description => 'High-Definition Media Interface',
                          :id          => 3,
                          :active      => true,
                          :has_sound   => true)
  end

  def down
    ConnectorType.enumeration_model_updates_permitted = true
    ConnectorType.destroy_all
  end
end
