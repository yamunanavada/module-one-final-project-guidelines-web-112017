require 'rest-client'
require 'JSON'
require "pry"
require_relative "command_line_interface.rb"


class Search

  attr_accessor :user, :origin, :destination, :departure_date, :parsed_flight_results

  def initialize(user)
    @user = user
  end

  def go
    get_search_terms #sets @origin, @destination, and @departure date for this Search
    parse_search_results(get_flights_from_api) #calls API; captures results as @parsed_flight_results
    create_flights(@parsed_flight_results) #creates Flight objects
    show_user_the_results(@parsed_flight_results) #displays flight results in viewable format
    want_to_save? #results in creation of Trips, or just ends - either way, return
  end


  def get_search_terms
    puts "Please enter your starting location: "
    @origin = gets.chomp.downcase
    puts "Please enter your destination: "
    @destination = gets.chomp.downcase
    puts "What is your desired departure date? "
    @departure_date = gets.chomp.downcase
  end

  def get_flights_from_api
    data = RestClient.get("https://api.sandbox.amadeus.com/v1.2/flights/low-fare-search?apikey=m9vXViQRJGAf8CMl4HpknPxPffSFKAgE&origin=#{@origin}&destination=#{@destination}&departure_date=#{@departure_date}")
    updated_data= JSON.parse(data)
  end

  def parse_search_results(results_from_destination)
    #takes in the hash created from get_flights_from_api and parses out the data to create an array of results for viewing
    #option to do mass assignment here?
    @parsed_flight_results = results_from_destination["results"].map do |flight_hash|
      result = {}
      result[:result_id] = results_from_destination["results"].index(flight_hash) + 1
      result[:price] = flight_hash["fare"]["total_price"]
      result[:origin] = flight_hash["itineraries"].first["outbound"]["flights"].first["origin"]["airport"]
      result[:destination] = flight_hash["itineraries"].last["outbound"]["flights"].last["destination"]["airport"]
      result[:date_of_departure] = flight_hash["itineraries"].first["outbound"]["flights"].first["departs_at"].split("T").first
      result[:time_of_departure] = flight_hash["itineraries"].first["outbound"]["flights"].first["arrives_at"].split("T").last
      result[:number_of_layovers] = flight_hash["itineraries"].length - 1
      result[:date_of_arrival] = flight_hash["itineraries"].last["outbound"]["flights"].first["arrives_at"].split("T").first
      result[:time_of_arrival] = flight_hash["itineraries"].last["outbound"]["flights"].first["arrives_at"].split("T").last
      result
    end
  end #returns array of flights in viewable format

  def create_flights(array_of_flights)
    #takes in an array of hashes, in which each hash is a flight from our search
    binding.pry
    array_of_flights.map do |flight|
      #now we are creating flight instances that are inserted into our database using create

      Flight.find_or_create_by(price: flight[:price]) do |u|
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
    #what if we just printed out the array from parse_search_results?
    array_of_flights.each do |flight|
      puts "#{flight[:result_id]}: $#{flight[:price]}. Departs from #{flight[:origin]} on #{flight[:date_of_departure]} at #{flight[:time_of_departure]}. Arrives at #{flight[:destination]} on #{flight[:date_of_arrival]} at #{flight[:time_of_arrival]}. Number of layovers: #{flight[:number_of_layovers]}."
    end
  end

  def want_to_save?
    puts "Would you like to save a flight? (Y/N)"
    answer = gets.chomp.downcase
    if answer == "y"
      save
    elsif answer == "n"
      puts "Ok, back to the main menu."
    elsif answer != "y" && answer != "n"
      puts "That was an incorrect response! Try again!"
      want_to_save?
    end
  end

  def save
    create_trips(match_selections_to_flights(select_flights, @parsed_flight_results), @user) #gets user's desired flights to save, matches selections to Flights, then creates Trips with those Flights
    puts "Selected flights saved to My Trips."
  end

  def select_flights
    puts "Please list the flight number(s) that you would like to save. If selecting multiple, please separate with a space."
    flights = gets.chomp.downcase
    flights_to_save = flights.split(" ").map {|n| n.to_i}
  end #returns array of selected_ids representing flights

  def match_selections_to_flights(array_selected_ids, parsed_hash_flights)
    array_selected_ids.map do |selected_id|
      parsed_hash_flights.find do |flight_hash|
        flight_hash[:result_id] == selected_id
      end
    end
  end  # returns array of user-selected flights, each flight in the form of a full hash of attributes

  def create_trips(parsed_flight_hashes, user)
    parsed_flight_hashes.each do |flight|
      matching_flight_object = Flight.find_by(price: flight[:price], origin: flight[:origin], destination: flight[:destination], date_of_departure: flight[:date_of_departure], time_of_departure: flight[:time_of_departure], time_of_arrival: flight[:time_of_arrival], number_of_layovers: flight[:number_of_layovers])
      #Trip.create(find_flight[:id],user[:id])
      Trip.find_or_create_by(user_id: user.id, flight_id: matching_flight_object.id, booked_flight: false)
    end
  end


end