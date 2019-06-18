class AddWorkingHoursToRestaurants < ActiveRecord::Migration[5.2]
  def change
    add_column :restaurants, :working_from, :datetime
    add_column :restaurants, :working_to, :datetime
  end
end
