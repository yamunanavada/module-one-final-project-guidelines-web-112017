class CreateTrips < ActiveRecord::Migration

  def change
    create_table :trips
      t.integer :user_id
      t.integer :flight_id
    end
  end
end
