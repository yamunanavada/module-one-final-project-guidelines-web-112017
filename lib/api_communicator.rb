require 'rest-client'
require 'JSON'
require "pry"
require_relative "command_line_interface.rb"

def get_search_results_with_destination(origin, destination, date)
  #takes in user entered search terms, and gets search results from the website
 data = RestClient.get("https://api.sandbox.amadeus.com/v1.2/flights/low-fare-search?apikey=m9vXViQRJGAf8CMl4HpknPxPffSFKAgE&origin=#{origin}&destination=#{destination}&departure_date=#{date}")

 updated_data= JSON.parse(data)

end

def parse_search_results(results_from_destination)
  #takes in the hash created from get_search_results_with_destination and parses out the data to create an array of results

  results_from_destination["results"].map do |flight_hash|
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
end
