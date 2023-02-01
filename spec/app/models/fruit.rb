class Fruit < ActiveRecord::Base
  acts_as_enumerated :name_column => :fruit_name,
                     :alias_name  => false,
                     :order       => :fruit_name

  def to_s
    "#{self.__enum_name__} (#{self.description})"
  end
end
