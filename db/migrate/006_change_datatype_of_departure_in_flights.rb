class ChangeDatatypeOfDepartureInFlights < ActiveRecord::Migration
  def change
    change_column :flights, :date_of_departure, :string
  end

end
