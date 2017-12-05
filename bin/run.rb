require_relative '../config/environment'


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
search_results = get_search_results_with_destination(origin, destination, date)
parsed_date = parse_search_results(search_results)
