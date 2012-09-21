require 'spec_helper'

describe :virtual_enumerations_initializer do
  it 'should generate the virtual enumerations initializer' do
    subject.should generate('config/initializers/virtual_enumerations.rb')
  end

  with_args('virtual_enums') do
    it 'should generate the virtual enumerations initializer in a different location if overriden by user' do
      subject.should generate('config/initializers/virtual_enums.rb')
    end
  end
end