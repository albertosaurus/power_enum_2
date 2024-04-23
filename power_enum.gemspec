# coding: utf-8
Gem::Specification.new do |spec|
  spec.name = "power_enum"
  spec.version = File.readlines(File.join(File.dirname(__FILE__), "VERSION")).first.chomp

  spec.required_rubygems_version = Gem::Requirement.new(">= 0")
  spec.required_ruby_version = '>= 2.7.0'
  spec.require_paths = ["lib"]
  spec.authors = ["Trevor Squires", "Pivotal Labs", "Arthur Shagall", "Sergey Potapov"]
  #s.cert_chain = ["gem-public_cert.pem"]
  spec.description = "Power Enum allows you to treat instances of your ActiveRecord models as though they were an enumeration of values.\nIt allows you to cleanly solve many of the problems that the traditional Rails alternatives handle poorly if at all.\nIt is particularly suitable for scenarios where your Rails application is not the only user of the database, such as\nwhen it's used for analytics or reporting.\n"
  spec.email = "arthur.shagall@gmail.com"
  spec.extra_rdoc_files = [
    "LICENSE",
    "README.markdown",
    "VERSION"
  ]
  spec.files = [
    "lib/active_record/virtual_enumerations.rb",
    "lib/generators/enum/USAGE",
    "lib/generators/enum/enum_generator.rb",
    "lib/generators/enum/enum_generator_helpers/migration_number.rb",
    "lib/generators/enum/templates/model.rb.erb",
    "lib/generators/enum/templates/rails31_migration.rb.erb",
    "lib/generators/virtual_enumerations_initializer/USAGE",
    "lib/generators/virtual_enumerations_initializer/templates/virtual_enumerations.rb.erb",
    "lib/generators/virtual_enumerations_initializer/virtual_enumerations_initializer_generator.rb",
    "lib/power_enum.rb",
    "lib/power_enum/enumerated.rb",
    "lib/power_enum/has_enumerated.rb",
    "lib/power_enum/migration/command_recorder.rb",
    "lib/power_enum/reflection.rb",
    "lib/power_enum/schema/schema_statements.rb",
    "lib/testing/rspec.rb"
  ]
  spec.homepage = "http://github.com/albertosaurus/power_enum_2"
  spec.licenses = ["MIT"]
  spec.summary = "Allows you to treat instances of your ActiveRecord models as though they were an enumeration of values"

  spec.add_development_dependency 'bundler', '> 1.7'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'rails', '>= 7.0', '< 8'

  spec.add_runtime_dependency 'railties', '>= 6.0', '< 8'
  spec.add_runtime_dependency 'activerecord', '>= 6.0', '< 8'
end
