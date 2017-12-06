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




def match_user_selections_to_flight_hashes(user_flights_to_save, parsed_data)
  user_flights_to_save.map do |selected_result_id|
    parsed_data.find do |flight_hash|
      flight_hash[:result_id] == selected_result_id
    end
  end
end  # returns array of user-selected flights, each flight in the form of a full hash of attributes


def create_trips_based_on_selected_flights(array_of_selected_flight_hashes, user)

  array_of_selected_flight_hashes.each do |flight|

    matching_flight_object = Flight.find_by(price: flight[:price], origin: flight[:origin], destination: flight[:destination], date_of_departure: flight[:date_of_departure], time_of_departure: flight[:time_of_departure], time_of_arrival: flight[:time_of_arrival], number_of_layovers: flight[:number_of_layovers])
    #Trip.create(find_flight[:id],user[:id])
    Trip.create(user_id: user.id, flight_id: matching_flight_object.id, booked_flight: false)
  end
end
