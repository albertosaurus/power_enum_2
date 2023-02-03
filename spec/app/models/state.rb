class State < ActiveRecord::Base
  acts_as_enumerated :name_column => :state_code,
                     :on_lookup_failure => :enforce_strict_literals

  def active?
    # return something randomly stupid for testing purposes.
    :active
  end
end
