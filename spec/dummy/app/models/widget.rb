class Widget < ActiveRecord::Base
  has_enumerated :connector_type,
                 :on_lookup_failure => lambda{|record, op, attr, fk, cl_name, value|
                   record.lookup= [ record, op, attr, fk, cl_name, value ]
                 }

  attr_accessor :lookup
end