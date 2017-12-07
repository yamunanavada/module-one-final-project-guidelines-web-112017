require 'rest-client'
require 'JSON'
require "pry"


class InspireMe
  # include Searchable

  attr_accessor :user, :origin, :destination, :departure_date, :budget, :parsed_flight_results

  def initialize(user)
    @user = user
  end

  def go
    get_origin #sets @origin for this Search
    get_departure_date #sets @departure date for this Search
    get_budget #sets @budget for this Search
    parse_search_results_from_inspiration(get_flights_from_inspiration_api) #calls API; captures results as @parsed_flight_results
    create_flights_inspiration(@parsed_flight_results) #creates Flight objects
    show_user_the_results(@parsed_flight_results) #displays flight results in viewable format
    want_to_save? #results in creation of Trips, or just ends - either way, return
  end


  def get_origin
    puts "Please enter the city code (XXX) of your starting location: "
    @origin = gets.chomp.downcase
    if @origin.length != 3
      begin
        raise PartnerError
      rescue PartnerError => error
        puts error.airport_message
        get_origin
      end
    end
  end

  def get_departure_date
    puts "Please enter your desired date of departure (YYYY-MM-DD): "
    @departure_date = gets.chomp.downcase
    if @departure_date.split("-")[0].length !=4 || @departure_date.split("-").length != 3
       begin
         raise PartnerError
       rescue PartnerError => error
         puts error.date_message
         get_departure_date
       end
    end
  end

  def get_budget
    puts "Please enter your budget for this trip in USD (e.g. 400.00): "
    @budget = gets.chomp
    if @budget.to_f.class != Float
      begin
         raise PartnerError
       rescue PartnerError => error
         puts error.budget_message
         get_budget
       end
    end
  end

  def get_flights_from_inspiration_api
    #takes in user entered search terms, and gets search results from the website
    body = begin
       RestClient.get("https://api.sandbox.amadeus.com/v1.2/flights/inspiration-search?apikey=m9vXViQRJGAf8CMl4HpknPxPffSFKAgE&origin=#{@origin}&departure_date=#{@departure_date}&max_price=#{@budget}")
     rescue => e
       e.response.body
     end
     if body.class == String
       body.slice!(0,25)
       body.chomp!("\"}")
       puts body
       go
     else
       updated_data= JSON.parse(body)
     end
  end

  def parse_search_results_from_inspiration(get_flights_from_inspiration_api)

    @parsed_flight_results = get_flights_from_inspiration_api["results"].map do |flight_hash|
      result = {}
      # result[:result_id] = get_flights_from_inspiration_api["results"].index(flight_hash) + 1
      result[:price] = flight_hash["price"]
      result[:origin] = get_flights_from_inspiration_api["origin"]
      result[:destination] = flight_hash["destination"]
      result[:date_of_departure] = flight_hash["departure_date"]
      result[:time_of_departure] = "-"
      result[:number_of_layovers] = "-"
      result[:date_of_arrival] = flight_hash["return_date"]
      result[:time_of_arrival] = "-"
      result
    end.uniq

    @parsed_flight_results.map do |flight_hash|
      flight_hash[:result_id] = @parsed_flight_results.index(flight_hash)+1
    end

  end

  def create_flights_inspiration(array_of_flights)
    #takes in an array of hashes, in which each hash is a flight from our search
    array_of_flights.each do |flight|
      #now we are creating flight instances that are inserted into our database using create
      new_saved_flight = Flight.find_or_create_by(price: flight[:price], origin: flight[:origin], destination:  flight[:destination], date_of_departure: flight[:date_of_departure], time_of_departure: flight[:time_of_departure], date_of_arrival: flight[:date_of_arrival], time_of_arrival: flight[:time_of_arrival], number_of_layovers: flight[:number_of_layovers])
    end

  end

  def show_user_the_results(array_of_flights)
    #displays the flights found in the search for the user
    #what if we just printed out the array from parse_search_results?
    array_of_flights.each do |flight|
      puts "#{flight[:result_id]}: $#{flight[:price]}. Departs from #{flight[:origin]} on #{flight[:date_of_departure]}. Arrives at #{flight[:destination]} on #{flight[:date_of_arrival]}."
    end
  end

  def want_to_save?
    puts "--------------------------------------"
    puts "Would you like to save a flight? (Y/N)"
    answer = gets.chomp.downcase
    if answer == "y"
      save_flight
    elsif answer == "n"
      puts "Ok, back to the main menu."
    elsif answer != "y" && answer != "n"
      puts "That was an incorrect response! Try again!"
      want_to_save?
    end
  end

  def select_flights
    puts "Please list the flight number(s) that you would like to save. If selecting multiple, please separate with a space."
    flights = gets.chomp.downcase
    flights_to_save = flights.split(" ").map {|n| n.to_i}
  end #returns array of selected_ids representing flights

  def save_flight
    create_trips_inspiration(match_selections_to_flights_inspiration(select_flights, @parsed_flight_results), @user) #gets user's desired flights to save, matches selections to Flights, then creates Trips with those Flights
    puts "Selected flights saved to My Trips."
  end


  def match_selections_to_flights_inspiration(array_selected_ids, parsed_hash_flights)
    array_selected_ids.map do |selected_id|
      parsed_hash_flights.find do |flight_hash|
        flight_hash[:result_id] == selected_id
      end
    end
  end  # returns array of user-selected flights, each flight in the form of a full hash of attributes

  def create_trips_inspiration(parsed_flight_hashes, user)
    parsed_flight_hashes.each do |flight|
      matching_flight_object = Flight.find_by(price: flight[:price], origin: flight[:origin], destination: flight[:destination], date_of_departure: flight[:date_of_departure], date_of_arrival: flight[:date_of_arrival])
      #Trip.create(find_flight[:id],user[:id])

      Trip.find_or_create_by(user_id: user.id, flight_id: matching_flight_object.id, booked_flight: false)

    end
  end

end
