require_relative '../config/environment'
require_all 'app'
require "pry"


#create or find user
#user inputs search terms - command_line_interface
#results are generated - makes query to api (in api_communicator)
#the results are stored in the Flights database and into an array for the user to see in the terminal - (api_communicator)
#the User sees results from the array - (command_line_interface)
#the User can save trips (i.e. Trips are created).
#the User can view their own trips ()
#the user can book trips (i.e. Trip.booked_flight => true)

welcome
enter_user
enter_email
start = origin
dest = destination
date_depart = date

#sends query to the website, and retrieves the hash of results
search_results = get_search_results_with_destination(start, dest, date_depart)

#parses the data and creates an array of flights with the right attributes
parsed_data = parse_search_results(search_results)

#creates Flights in the database given the array of flights
create_flights(parsed_data)

#displays the list of results to the user
show_user_the_results(parsed_data)


puts "hello"
