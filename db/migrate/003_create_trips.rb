class CreateTrips < ActiveRecord::Migration

  def change
    create_table :trips do |t|
      t.integer :user_id
      t.integer :flight_id
      t.boolean :booked_flight
    end
  end
end
