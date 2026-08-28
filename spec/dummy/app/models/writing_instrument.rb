# frozen_string_literal: true

class WritingInstrument < ActiveRecord::Base
  acts_as_enumerated on_lookup_failure: :insert_new_record
end
