class Fastener < ActiveRecord::Base
  acts_as_enumerated on_lookup_failure: :insert_new_record
end
