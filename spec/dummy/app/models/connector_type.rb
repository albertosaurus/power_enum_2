class ConnectorType < ActiveRecord::Base
  acts_as_enumerated :order => 'name DESC'
end
