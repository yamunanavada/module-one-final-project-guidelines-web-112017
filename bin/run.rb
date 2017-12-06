require_relative '../config/environment'
require "pry"


#create or find user
#user inputs search terms - command_line_interface
#results are generated - makes query to api (in api_communicator)
#the results are stored in the Flights database and into an array for the user to see in the terminal - (api_communicator)
#the User sees results from the array - (command_line_interface)
#the User can save trips (i.e. Trips are created).
#the User can view their own trips ()
#the user can book trips (i.e. Trip.booked_flight => true)

session = Session.new
session.start





=begin


#sends query to the website, and retrieves the hash of results
search_results = get_search_results_with_destination(start, dest, date_depart)

#parses the data and creates an array of flights with the right attributes
parsed_data = parse_search_results(search_results)

#creates Flights in the database given the array of flights
results_to_display = create_flights(parsed_data)

#displays the list of results to the user
show_user_the_results(parsed_data)

#asks the user if he or she would like to save flights
user_flights_to_save = select_flights

# #Finds flight in database - NEED TO WRITE THIS METHOD
# flights_in_DB = find_flights_in_DB(user_flights_to_save, parsed_data)
array_of_selected_flight_hashes = match_user_selections_to_flight_hashes(user_flights_to_save, parsed_data)

#UPDATE THIS METHOD ARUGMENT - user_flights_to_save - ONCE YOU FINISH find_flights_in_DB METHOD TO the RESULT OF find_flights_in_DB
create_trips_based_on_selected_flights(array_of_selected_flight_hashes, user)
=end
