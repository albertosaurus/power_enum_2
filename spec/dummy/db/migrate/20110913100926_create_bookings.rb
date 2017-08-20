class CreateBookings < ActiveRecord::Migration[4.2]
  def change
    create_table :bookings do |t|
      t.integer :status_id

      t.timestamps
    end
  end
end
