class BookingStatusUncached < ActiveRecord::Base
  self.table_name = "booking_statuses"

  acts_as_enumerated on_lookup_failure: :not_found, freeze_members: true, :dont_cache => true

  # This method should be called when requested status does not exist
  def self.not_found(name)
  end
end
