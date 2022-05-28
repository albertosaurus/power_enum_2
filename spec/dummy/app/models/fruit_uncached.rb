class FruitUncached < ActiveRecord::Base
  self.table_name = "fruits"

  acts_as_enumerated :name_column => :fruit_name,
                     :alias_name  => false,
                     :order       => :fruit_name,
                     :dont_cache => true

  def to_s
    "#{self.__enum_name__} (#{self.description})"
  end
end
