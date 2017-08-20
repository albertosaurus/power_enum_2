class CreateEnumColor < ActiveRecord::Migration[4.2]

  def change
    create_enum :color
  end

end
