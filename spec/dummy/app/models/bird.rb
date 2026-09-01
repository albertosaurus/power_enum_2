class Bird < ActiveRecord::Base
  acts_as_enumerated on_lookup_failure: :call_block
end