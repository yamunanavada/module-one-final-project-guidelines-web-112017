require 'rest-client'
require 'JSON'
require "pry"


class InspireMe

  attr_accessor :user, :origin, :destination, :departure_date, :budget, :parsed_flight_results

  def initialize(user)
    @user = user
  end

  def go
    get_origin #sets @origin for this Search
    get_departure_date #sets @departure date for this Search
    get_budget #sets @destination for this Search
    #parse_search_results(get_flights_from_api) #calls API; captures results as @parsed_flight_results
    #create_flights(@parsed_flight_results) #creates Flight objects
    #show_user_the_results(@parsed_flight_results) #displays flight results in viewable format
    #want_to_save? #results in creation of Trips, or just ends - either way, return

  end


  def get_origin
    puts "Please enter the airport code (XXX) of your starting location: "
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


  def get_destination
      puts "Please enter the airport code (XXX) of your destination: "
      @destination = gets.chomp.downcase
      if @destination.length != 3
        begin
          raise PartnerError
        rescue PartnerError => error
          puts error.airport_message
          get_destination
        end
      end
    end








end
