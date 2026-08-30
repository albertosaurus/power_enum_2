class CreateWritingInstrumentEnum < ActiveRecord::Migration[7.1]
  def up
    create_enum :writing_instruments, :description => :true
  end

  def down
    drop_table :writing_instruments
  end
end
