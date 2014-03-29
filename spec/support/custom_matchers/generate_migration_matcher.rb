class GenerateMigrationMatcher < GenSpec::Matchers::Base
  attr_accessor :migration_name

  def initialize(enum, &block)
    self.migration_name = "create_enum_#{enum}.rb"
    super(&block)
  end

  def generated
    path = File.join(destination_root, 'db/migrate')
    migration_file = Dir.entries(path).select{|filename| filename.end_with? migration_name }
    if migration_file
      match!
      spec_file_contents File.join(path, migration_file)
    end
  end

  def failure_message
    "Expected to generate migration *_#{migration_name}"
  end

  def negative_failure_message
    "Expected to not generate migration *_#{migration_name}"
  end
end
