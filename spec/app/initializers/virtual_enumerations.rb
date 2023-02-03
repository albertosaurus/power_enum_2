# frozen_string_literal: true

ActiveRecord::VirtualEnumerations.define do |config|
  config.define(
    "VirtualEnum",
    on_lookup_failure: :enforce_strict
  ) do
    def virtual_enum_id
      id
    end
  end

  config.define :shadow_enum, extends: :virtual_enum

  config.define :pirate_enum, table_name: :virtual_enums
end
