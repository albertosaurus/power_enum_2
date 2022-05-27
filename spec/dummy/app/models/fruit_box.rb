require 'power_enum'

class FruitBox < ActiveRecord::Base
  has_enumerated :fruit
end
