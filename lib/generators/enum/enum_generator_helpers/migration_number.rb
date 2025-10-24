# frozen_string_literal: true

# Helper logic for the enum generator
module EnumGeneratorHelpers
  # Helper methods to figure out the migration number.
  module MigrationNumber
    # Returns the next upcoming migration number.  Sadly, Rails has no API for
    # this, so we're reduced to copying from ActiveRecord::Generators::Migration
    # @return [Integer]
    def next_migration_number(dirname)
      # Lifted directly from ActiveRecord::Generators::Migration
      # Unfortunately, no API is provided by Rails at this time.
      next_migration_number = current_migration_number(dirname) + 1
      if (ActiveRecord::Base.respond_to?(:timestamped_migrations) && ActiveRecord::Base.timestamped_migrations) ||
         (ActiveRecord.respond_to?(:timestamped_migrations) && ActiveRecord.timestamped_migrations) # Changed in Rails 7.1
        [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d" % next_migration_number].max
      else
        "%.3d" % next_migration_number
      end
    end

  end
end
