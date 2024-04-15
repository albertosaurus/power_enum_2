# Copyright (c) 2011 Arthur Shagall
# Released under the MIT license.  See LICENSE for details.

module PowerEnum::Migration # :nodoc:

  # Extensions for CommandRecorder
  module CommandRecorder
    # Records create_power_enum
    def create_power_enum(*args)
      record(:create_power_enum, args)
    end

    # Records remove_power_enum
    def remove_power_enum(*args)
      record(:remove_power_enum, args)
    end

    # The inversion of create_power_enum is remove_power_enum
    # @param [Array] args Arguments to create_power_enum
    # @return [Array] [:remove_power_enum, [enum_name]]
    def invert_create_power_enum(args)
      enum_name = args[0]
      [:remove_power_enum, [enum_name]]
    end
  end

end