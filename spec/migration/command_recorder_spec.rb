require 'spec_helper'

class CommandRecorderStub
  include PowerEnum::Migration::CommandRecorder
end

describe PowerEnum::Migration::CommandRecorder do
  let(:recorder) {
    CommandRecorderStub.new
  }

  it '.create_enum' do
    recorder.should_receive(:record).with(:create_enum, [])

    recorder.create_enum
  end

  it '.remove_enum' do
    recorder.should_receive(:record).with(:remove_enum, [])

    recorder.remove_enum
  end

  it '.invert_create_enum' do
    recorder.invert_create_enum([:foo]).should eq([:remove_enum, [:foo]])
  end
end