require 'spec_helper'

class AbstractAdapterStub
  include PowerEnum::Schema::AbstractAdapter

  class TableStub
    attr_accessor :table_name, :args
    attr_reader :command_buffer

    def initialize(table_name, args = {})
      self.table_name = table_name
      self.args       = args
      @command_buffer = {
          :strings    => [],
          :booleans   => [],
          :integers   => [],
          :timestamps => false
      }
    end

    def string(name, *args)
      command_buffer[:strings] << name
    end

    def timestamps
      command_buffer[:timestamps] = true
    end

    def boolean(name, *args)
      command_buffer[:booleans] << name
    end

    def integer(name, *args)
      command_buffer[:integers] << name
    end
  end

  attr_reader :tables
  attr_reader :indexes

  def create_table(name, args)
    table_stub = TableStub.new(name, args)

    yield table_stub

    @tables ||= []
    @tables << table_stub
  end

  def add_index(table_name, *args)
    @indexes ||= []
    @indexes << table_name
  end
end

describe PowerEnum::Schema::AbstractAdapter do

  let(:adapter_stub){
    AbstractAdapterStub.new
  }

  let(:table_options) {
    { :foo => 1, :bar => 2, :baz => 3 }
  }

  it 'should create the enum table on \'create_power_enum\'' do
    adapter_stub.create_power_enum(
        'test_enum',
        :name_column   => 'name_column',
        :description   => true,
        :active        => true,
        :timestamps    => true,
        :table_options => table_options
    ) { |t| t.integer "integer_column" }

    indexes = adapter_stub.indexes
    indexes.size.should eq(1)
    indexes.first.should eq('test_enums')

    adapter_stub.tables.size.should eq(1)
    table = adapter_stub.tables.first
    table.table_name.should eq('test_enums')
    table.args.should eq(table_options)

    command_buffer = table.command_buffer

    command_buffer[:strings].should =~ ['name_column', :description]

  end

  it 'should drop the enum table on \'remove_power_enum\'' do
    adapter_stub.should_receive(:drop_table).with('test_enums')

    adapter_stub.remove_power_enum('test_enum')
  end

end