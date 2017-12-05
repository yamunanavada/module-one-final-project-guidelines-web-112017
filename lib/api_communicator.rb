require 'rest-client'
require 'JSON'
require "pry"
require_relative "command_line_interface.rb"

def get_search_results_with_destination(origin, destination, date)
  #takes in user entered search terms, and gets search results from the website
 data = RestClient.get("https://api.sandbox.amadeus.com/v1.2/flights/low-fare-search?apikey=m9vXViQRJGAf8CMl4HpknPxPffSFKAgE&origin=#{origin}&destination=#{destination}&departure_date=#{date}")

 updated_data= JSON.parse(data)

end

def parse_search_results(results_from_destination, origin, destination, date)
  #takes in the hash created from get_search_results_with_destination and parses out the data to create an array of results

results_from_destination["results"].map do |flight_hash|
    result = {}
    result[:fare] = flight_hash["fare"]["total_price"]
    result[:origin] = origin
    result[:destination] = destination
    result[:departure_date] = date
    result
  end
end
