class Flight < ActiveRecord::Base
  has_many :trips
  has_many :users, through: :trips

  # def find_or_create_flights(array_of_flights)
  #   array_of_flights.each do |flight|
  #     Flight.create(:price = flight[:fare]) do |u|
  #       u.origin = flight[:origin]
  #       u.destination = flight[:destination]
  #       u.date_of_departure
  #
  #

end
