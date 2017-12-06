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

  array_of_flights.each do |flight|
    puts "#{flight[:result_id]}: $#{flight[:price]}. Departs from #{flight[:origin]} on #{flight[:date_of_departure]} at #{flight[:time_of_departure]}. Arrives at #{flight[:destination]} on #{flight[:date_of_arrival]} at #{flight[:time_of_arrival]}. Number of layovers: #{flight[:number_of_layovers]}."
  end
end


# results_from_destination["results"].map do |flight_hash|
#     result = {}
#     result[:result_id] = results_from_destination["results"].index(flight_hash) + 1
#     result[:price] = flight_hash["fare"]["total_price"]
#     result[:origin] = flight_hash["itineraries"].first["outbound"]["flights"].first["origin"]["airport"]
#     result[:destination] = flight_hash["itineraries"].last["outbound"]["flights"].first["destination"]["airport"]
#     result[:date_of_departure] = flight_hash["itineraries"].first["outbound"]["flights"].first["departs_at"].split("T").first
#     result[:time_of_departure] = flight_hash["itineraries"].first["outbound"]["flights"].first["arrives_at"].split("T").last
#     result[:number_of_layovers] = flight_hash["itineraries"].length - 1
#     result[:date_of_arrival] = flight_hash["itineraries"].last["outbound"]["flights"].first["arrives_at"].split("T").first
#     result[:time_of_arrival] = flight_hash["itineraries"].last["outbound"]["flights"].first["arrives_at"].split("T").last
#
#     result
#   end
