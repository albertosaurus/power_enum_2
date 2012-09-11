require 'spec_helper'

describe ActiveRecord::VirtualEnumerations do

  # See spec/dummy/config/initializers/virtual_enumerations.rb

  it 'should define VirtualEnum enum model' do
    VirtualEnum.acts_as_enumerated?.should be_true
  end

  it 'VirtualEnum should function as an enum' do
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

  context 'ShadowEnum' do

    it 'should have a shadow enum' do
      ShadowEnum[:virtual_enum].should_not be_nil
    end

  end

  context 'PirateEnum' do
    it 'should have a pirate enum' do
      PirateEnum[:virtual_enum].should_not be_nil
    end

    it 'should not execute the config block for VirtualEnum' do
      PirateEnum[:foo].should be_nil
      PirateEnum[:foo].respond_to?(:virtual_enum_id).should be_false
    end
  end
end