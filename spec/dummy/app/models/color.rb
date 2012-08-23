class Color < ActiveRecord::Base
  acts_as_enumerated :on_lookup_failure => lambda{ |arg|
    if arg == :foo
      :foo
    else
      :bar
    end
  }
end
