require_relative '../app/models/Flight.rb'

def create_flights(array_of_flights)
  #takes in an array of hashes, in which each hash is a flight from our search
  array_of_flights.each do |flight|
    #now we are creating flight instances that are inserted into our database using create
    Flight.create(price: flight[:price]) do |u|
      u.origin = flight[:origin]
      u.destination =  flight[:destination]
      u.date_of_departure = flight[:date_of_departure]

    end
  end
end


# [{:fare=>"1268.40", :origin=>"sfo", :destination=>"jfk", :departure_date=>"2018-01-01"}, {:fare=>"1282.80", :origin=>"sfo", :destination=>"jfk", :departure_date=>"2018-01-01"}, {:fare=>"1301.80", :origin=>"sfo", :destination=>"jfk", :departure_date=>"2018-01-01"},
#   {:fare=>"1657.80", :origin=>"sfo", :destination=>"jfk", :departure_date=>"2018-01-01"},
#   {:fare=>"1713.20", :origin=>"sfo", :destination=>"jfk", :departure_date=>"2018-01-01"}]
