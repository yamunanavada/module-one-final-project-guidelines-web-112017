class AddColumnsToFlights < ActiveRecord::Migration

  def change
    add_column :flights, :number_of_layovers, :integer
    add_column :flights, :time_of_departure, :string
    add_column :flights, :date_of_arrival, :string
    add_column :flights, :time_of_arrival, :string
  end




end
