require 'spec_helper'

describe :virtual_enumerations_initializer do
  it 'should generate the virtual enumerations initializer' do
    subject.should generate('config/initializers/virtual_enumerations.rb')
  end

  with_args('virtual_enums') do
    it 'should generate the virtual enumerations initializer in a different location if overriden by user' do
      root_dir = "#{File.dirname(__FILE__)}/../.."
      template_file = "#{root_dir}/lib/generators/virtual_enumerations_initializer/templates/virtual_enumerations.rb.erb"
      template_content = File.open(template_file, 'r'){ |f|
        f.read
      }

      subject.should generate('config/initializers/virtual_enums.rb'){ |content|
        content.should == template_content
      }
    end
  end
end