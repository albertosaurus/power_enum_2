require 'spec_helper'

describe :enum do
  context 'no arguments or options' do
    it 'should generate an error message' do
      subject.should output("No value provided for required arguments 'enum_name'")
    end
  end

  with_args :foo do
    it 'should generate enum model' do
      subject.should generate('app/models/foo.rb') { |content|
        content.should =~ /class Foo < ActiveRecord::Base/
      }
    end
  end
end