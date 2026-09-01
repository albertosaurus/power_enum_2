class CreateEnumBird < ActiveRecord::Migration[7.1]
  def change
    create_enum :bird, description: true
  end
end
