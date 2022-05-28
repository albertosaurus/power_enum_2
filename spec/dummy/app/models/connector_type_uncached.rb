class ConnectorTypeUncached < ActiveRecord::Base
  self.table_name = "connector_types"

  acts_as_enumerated order: 'name DESC', freeze_members: -> { false }, :dont_cache => true
end
