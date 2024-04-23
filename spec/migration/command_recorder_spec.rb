require 'spec_helper'

class CommandRecorderStub
  include PowerEnum::Migration::CommandRecorder
end

describe PowerEnum::Migration::CommandRecorder do
  let(:recorder) {
    CommandRecorderStub.new
  }

  it '.create_power_enum' do
    recorder.should_receive(:record).with(:create_power_enum, [])

    recorder.create_power_enum
  end

  it '.remove_power_enum' do
    recorder.should_receive(:record).with(:remove_power_enum, [])

    recorder.remove_power_enum
  end

  it '.invert_create_power_enum' do
    recorder.invert_create_power_enum([:foo]).should eq([:remove_power_enum, [:foo]])
  end
end