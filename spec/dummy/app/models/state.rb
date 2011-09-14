class State < ActiveRecord::Base
  acts_as_enumerated :name_column => :state_code,
                     :on_lookup_failure => :enforce_strict_literals
end
