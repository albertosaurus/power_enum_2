require 'spec_helper'

describe ActiveRecord::VirtualEnumerations do
  before :all do
    ActiveRecord::VirtualEnumerations.define do |config|
      config.define('VirtualEnum', :on_lookup_failure => :enforce_strict) {
        def virtual_enum_id
          id
        end
      }
    end
  end

  it 'should define VirtualEnum enum model' do
    VirtualEnum.acts_as_enumerated?.should be_true
  end

  it 'VirtualEnum should function as an enum' do
    puts "names: #{VirtualEnum.names.inspect}"
    VirtualEnum[:virtual_enum].should_not be_nil
  end

  it 'should load the enum options' do
    expect {
    VirtualEnum[:foo]
    }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'should execute the config block' do
    f = VirtualEnum[:virtual_enum]
    f.respond_to?(:virtual_enum_id).should be_true
    f.virtual_enum_id.should == f.id
  end
end