ActiveRecord::VirtualEnumerations.define do |config|
  config.define('VirtualEnum', :on_lookup_failure => :enforce_strict) {
    def virtual_enum_id
      id
    end
  }

  config.define :shadow_enum, :extends => :virtual_enum

  config.define :pirate_enum, :table_name => :virtual_enums
end