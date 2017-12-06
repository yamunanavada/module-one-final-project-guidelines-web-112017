class CreateFlights < ActiveRecord::Migration

  def change
    create_table :flights do |t|
      t.string :origin
      t.string :destination
      t.date :date_of_departure #may need to fix this type
      t.float :price
    end
  end
end
