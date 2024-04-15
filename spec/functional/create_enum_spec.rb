require 'spec_helper'

describe "create_power_enum migration methods" do

  it "connector type should be defined" do
    expect{
      Module.const_get('ConnectorType')
    }.to_not raise_error
  end

  it "connector type should define correct columns" do
    ["id", "name", "description", "created_at", "updated_at", "active", "has_sound"].each do |column_name|
      ConnectorType.column_names.should include(column_name)
    end
  end

  it 'connector type names should match descriptions' do
    ConnectorType.all.each { |c| puts c.inspect }
    ConnectorType.all.size.should == 3
    [['DVI', 'Digital Video Interface'],
    ['VGA', 'Video Graphics Array'],
    ['HDMI', 'High-Definition Media Interface']].each do |pair|
      ConnectorType[pair.first].description.should == pair.last
    end
  end
end
