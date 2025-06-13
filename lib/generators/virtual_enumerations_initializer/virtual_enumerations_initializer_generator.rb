# frozen_string_literal: true

# Copyright (c) 2011 Arthur Shagall
# Released under the MIT license.  See LICENSE for details.

# Generator for the VirtualEnumerations initializer
class VirtualEnumerationsInitializerGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  argument :initializer_name, :type => :string, :default => 'virtual_enumerations'

  # Writes the virtual enumerations initializer to config/initializers
  def generate_virtual_enum_initializer
    template 'virtual_enumerations.rb.erb', "config/initializers/#{initializer_name}.rb"
  end

end
