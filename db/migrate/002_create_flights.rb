class CreateFlights < ActiveRecord::Migration

  def change
    create_table :flights do |t|
      t.integer :user_id
      t.integer :flight_id
    end
  end

end
