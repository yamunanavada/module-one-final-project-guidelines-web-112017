class CreateFlights < ActiveRecord::Migration

  def change
    create_table :flights do |t|
      t.string :origin
      t.string :destination
      t.date :date_of_departure
      t.float :price
      # t.integer :number_of_layovers
    end
  end
end
