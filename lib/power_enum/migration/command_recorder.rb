# Copyright (c) 2011 Arthur Shagall
# Released under the MIT license.  See LICENSE for details.

module PowerEnum::Migration

  module CommandRecorder
    def create_enum(*args)
      record(:create_enum, args)
    end

    def remove_enum(*args)
      record(:remove_enum, args)
    end

    def invert_create_enum(args)
      enum_name = args[0]
      [:remove_enum, [enum_name]]
    end
  end

end