require_relative '../app/models/Flight.rb'

def create_flights(array_of_flights)
  #takes in an array of hashes, in which each hash is a flight from our search
  array_of_flights.map do |flight|
    #now we are creating flight instances that are inserted into our database using create

    Flight.create(price: flight[:price]) do |u|
      u.origin = flight[:origin]
      u.destination =  flight[:destination]
      u.date_of_departure = flight[:date_of_departure]
      u.time_of_departure = flight[:time_of_departure]
      u.date_of_arrival = flight[:date_of_arrival]
      u.time_of_arrival = flight[:time_of_arrival]
      u.number_of_layovers = flight[:number_of_layovers]
    end

  end
end


def show_user_the_results(array_of_flights)
  #displays the flights found in the search for the user

  array_of_flights.each do |flight|
    puts "#{flight[:result_id]}: $#{flight[:price]}. Departs from #{flight[:origin]} on #{flight[:date_of_departure]} at #{flight[:time_of_departure]}. Arrives at #{flight[:destination]} on #{flight[:date_of_arrival]} at #{flight[:time_of_arrival]}. Number of layovers: #{flight[:number_of_layovers]}."
  end
end

def find_flights_in_DB(user_flights_to_save, parsed_data)
#need to finish this method
#goal of method is the following:
#find each result_id in teh parsed_data file based on the flight numbers the user wants to save
end


#the below method does not yet work because i need to make the find_flights_in_DB method
def create_trips_based_on_selected_flights(flights_found_in_db, user)

  flights_found_in_db.each do |flight|
    #first find the flight in the database
    binding.pry
    find_flight = Flight.find_by(price: flight[:price], origin: flight[:origin], destination: flight[:destination], date_of_departure: flight[:date_of_departure], time_of_departure: flight[:time_of_departure], time_of_arrival: flight[:time_of_arrival], number_of_layovers: flight[:number_of_layovers])
    #then add a trip with the user_id and flight_id
    Trip.create(find_flight[:id],user[:id])
  end
end
