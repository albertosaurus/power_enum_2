require 'spec_helper'

describe ActiveRecord::VirtualEnumerations do

  it 'should not patch Module#const_missing more than once' do
    # At this point, const_missing is already patched.
    ::Module.should_not_receive :alias_method

    subject.patch_const_lookup
  end

  # See spec/dummy/config/initializers/virtual_enumerations.rb

  it 'should define VirtualEnum enum model' do
    VirtualEnum.acts_as_enumerated?.should eq(true)
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
    f.respond_to?(:virtual_enum_id).should eq(true)
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
      PirateEnum[:foo].respond_to?(:virtual_enum_id).should eq(false)
    end
  end

  describe ActiveRecord::VirtualEnumerations::Config do
    let(:config){ ActiveRecord::VirtualEnumerations::Config.new }

    it 'should raise ArgumentError if it can\'t get the came case name of the argument' do
      expect{
        config.define('')
      }.to raise_error(ArgumentError, "ActiveRecord::VirtualEnumerations.define - invalid class_name argument (#{''.inspect})")
    end

    it 'should raise ArgumentError if the same class is defined twice' do
      config.define('foo')
      expect{
        config.define('foo')
      }.to raise_error(ArgumentError, "ActiveRecord::VirtualEnumerations.define - class_name already defined (Foo)")
    end
  end
end
