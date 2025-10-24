require 'spec_helper'

require File.expand_path('../../../../lib/generators/enum/enum_generator_helpers/migration_number', __FILE__)

class MigrationStub
  include EnumGeneratorHelpers::MigrationNumber
end

describe EnumGeneratorHelpers::MigrationNumber do
  let(:helper) { migration_stub.new }
  let(:migration_stub) {
    Class.new do
      include EnumGeneratorHelpers::MigrationNumber
    end
  }
  let(:dirname) { "#{Rails.root}/db/migrate/[0-9]*_*.rb" }

  let(:active_record_class) {
    ActiveRecord::Base.respond_to?(:timestamped_migrations) ? ActiveRecord::Base : ActiveRecord
  }

  it 'non-timestamp migration number' do
    expect(helper).to receive(:current_migration_number).and_return(5)
    expect(active_record_class).to receive(:timestamped_migrations).and_return(false)

    expect(helper.next_migration_number(dirname)).to eq('006')
  end

  it 'timestamp migration number' do
    expect(helper).to receive(:current_migration_number).and_return(90000000000001)

    expect(helper.next_migration_number(dirname)).to eq('90000000000002')
  end
end
