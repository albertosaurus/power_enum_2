class ConnectorType < ActiveRecord::Base
  acts_as_enumerated order: 'name DESC', freeze_members: -> { false }
end
