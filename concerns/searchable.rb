# module Searchable
#
#   def create_flights(array_of_flights)
#     #takes in an array of hashes, in which each hash is a flight from our search
#     array_of_flights.each do |flight|
#       #now we are creating flight instances that are inserted into our database using create
#       Flight.find_or_create_by(price: flight[:price], origin: flight[:origin], destination: flight[:destination], date_of_departure: flight[:date_of_departure], time_of_departure: flight[:time_of_departure], date_of_arrival: flight[:date_of_arrival], time_of_arrival: flight[:time_of_arrival],number_of_layovers: flight[:number_of_layovers])
#     end
#     binding.pry
#   end
#
#   def want_to_save?
#     puts "Would you like to save a flight? (Y/N)"
#     answer = gets.chomp.downcase
#     if answer == "y"
#       save
#     elsif answer == "n"
#       puts "Ok, back to the main menu."
#     elsif answer != "y" && answer != "n"
#       puts "That was an incorrect response! Try again!"
#       want_to_save?
#     end
#   end
#
#   def save
#     create_trips(match_selections_to_flights(select_flights, @parsed_flight_results), @user) #gets user's desired flights to save, matches selections to Flights, then creates Trips with those Flights
#     puts "Selected flights saved to My Trips."
#   end
#
#   def select_flights
#     puts "Please list the flight number(s) that you would like to save. If selecting multiple, please separate with a space."
#     flights = gets.chomp.downcase
#     flights_to_save = flights.split(" ").map {|n| n.to_i}
#   end #returns array of selected_ids representing flights
#
#   def match_selections_to_flights(array_selected_ids, parsed_hash_flights)
#     array_selected_ids.map do |selected_id|
#       parsed_hash_flights.find do |flight_hash|
#         flight_hash[:result_id] == selected_id
#       end
#     end
#   end  # returns array of user-selected flights, each flight in the form of a full hash of attributes
#
# end
