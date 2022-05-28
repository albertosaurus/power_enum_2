class StateUncached < ActiveRecord::Base
  self.table_name = "states"

  acts_as_enumerated :name_column => :state_code,
                     :on_lookup_failure => :enforce_strict_literals,
                     :dont_cache => true

  def active?
    # return something randomly stupid for testing purposes.
    :active
  end
end
