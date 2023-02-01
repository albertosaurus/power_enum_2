class CreateEnumColor < ActiveRecord::Migration

  def change
    create_enum :color
  end

end
