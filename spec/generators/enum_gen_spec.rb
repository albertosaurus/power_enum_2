require 'spec_helper'

describe :enum do
  TestNamespace = Class.new

  def generate_migration(enum_name, &block)
    GenerateMigrationMatcher.new(enum_name, &block)
  end

  unless ENV['TRAVIS']
    context 'no arguments or options' do
      it 'should generate an error message' do
        expect {
          subject.should output('')
        }.to raise_error(Thor::RequiredArgumentMissingError, "No value provided for required arguments 'name'")
      end
    end
  end

  with_args :foo do
    it 'should generate enum model' do
      class_contents = <<-exp
class Foo < ActiveRecord::Base
  acts_as_enumerated
end
      exp

      subject.should generate('app/models/foo.rb') { |content|
        content.should eq(class_contents)
      }
    end

    it 'should generate migration' do
      migration_contents = <<-exp
class CreateEnumFoo < ActiveRecord::Migration

  def change
    create_enum :foo
  end

end
      exp

      subject.should generate_migration(:foo) { |content|
        content.should eq(migration_contents)
      }
    end
  end

  with_args :foo, "--description" do
    it 'should generate migration with description' do
      migration_contents = <<-exp
class CreateEnumFoo < ActiveRecord::Migration

  def change
    create_enum :foo, description: true
  end

end
      exp

        subject.should generate_migration(:foo) { |content|
          content.should eq(migration_contents)
        }
    end
  end

  with_args :foo do
    before do
      Rails::Generators.namespace = TestNamespace
    end

    after do
      Rails::Generators.namespace = nil
    end

    it 'should generate enum model' do
      class_contents = <<-exp
module TestNamespace
  class Foo < ActiveRecord::Base
    acts_as_enumerated
  end
end
      exp

      subject.should generate('app/models/test_namespace/foo.rb') { |content|
        content.should eq(class_contents)
      }
    end

    it 'should generate migration with namespace' do
      migration_contents = <<-exp
class CreateEnumTestNamespaceFoo < ActiveRecord::Migration

  def change
    create_enum :foo
  end

end
      exp

        subject.should generate_migration(:test_namespace_foo) { |content|
          content.should eq(migration_contents)
        }
    end
  end
end
