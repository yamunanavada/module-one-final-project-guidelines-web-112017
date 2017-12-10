require 'rest-client'
require 'JSON'
require "pry"


class ViewMyTrips

  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def go #sent here from Session - session.go(user) based on user choice
    view_trips #looks in user.trips -- which points to Trip table. Pulls trips
    menu_for_view_trips
  end

  def view_trips #prints Flight info, and returns nil

    if @user.trips.length == 0  #if user has no saved Trips - put "you have 0"
      puts "You have no trips saved."
    elsif #otherwise, for each Trip saved, find the Flight object
      @user.trips.each_with_index do |trip, index| #for each trip associated with User
        flight = Flight.find_by(id: trip[:flight_id]) #take the flight_id, use it to search Flight (flight_id = id)
        if trip[:booked_flight] == true
          booked = "Has been booked."
        else
          booked = "Has not been booked."
        end

        if flight[:time_of_departure] == "-"
          puts "#{index+ 1}: $#{flight[:price]}. Departs from #{flight[:origin]} on #{flight[:date_of_departure]}. Arrives at #{flight[:destination]} on #{flight[:date_of_arrival]}. #{booked}"
        else
          puts "#{index+ 1}: $#{flight[:price]}. Departs from #{flight[:origin]} on #{flight[:date_of_departure]} at #{flight[:time_of_departure]}. Arrives at #{flight[:destination]} on #{flight[:date_of_arrival]} at #{flight[:time_of_arrival]}. Number of layovers: #{flight[:number_of_layovers]}. #{booked}"
        end
      end #returns array of nothing
    end #returns array of nothing
    puts "--------------------------------------"
  end #returns nil

  def menu_for_view_trips
    puts "Please select an option.
    1 - Book a Trip
    2 - Delete a Trip
    3 - Back to Main Menu"
    answer = gets.chomp.to_i
    case answer
    when 1
      puts "--------------------------------------"
      book_a_flight? #loops unilt success in booking a trip, returns nil
      go #start ViewMyTrips journey again
    when 2
      puts "--------------------------------------"
      delete_a_trip? #loops until success in deleting a trip then returns nil
      go
    when 3
      #all done, so goes back to session, which points to MainMenu
    end
  end


  def delete_a_trip? #results in deletion of trip, and returns nil
    puts "Please list the number of the trip you would like to delete from your saved trips."
    selection = gets.chomp.to_i
    if selection > user.trips.length  #i.e. if user chooses a trip not shown
      begin
        raise PartnerError
      rescue PartnerError => error
        puts error.delete_message
        delete_a_trip? #start this method again
      end
    else #if user chooses a valid trip - #changed THIS!!! was end
      trip_to_delete = user.trips[selection - 1]
      delete_trip(trip_to_delete) #removed @user argument; each Trip row is unique to a user already, since we're looking directly at the trip
    end #returns nil
  end


  def delete_trip(trip_to_delete)
    trip_to_delete.destroy #changed from delete_all to destroy
    @user.trips.reload
    puts "The selected trip has been deleted."
  end

  def book_a_flight?
    puts "Please list the number of the trip you would like to book. Please list just one trip."
    selection = gets.chomp.to_i
    if selection > user.trips.length  #i.e. if user chooses a trip not shown
      begin
        raise PartnerError
      rescue PartnerError => error
        puts error.delete_message
        book_a_flight? #start this method again.
      end
    else
      trip_to_book = user.trips[selection - 1]
      book_trip(trip_to_book) #removed @user argument; each Trip row is unique to a user already, since we're looking directly at the trip
    end
  end #returns nil


  def book_trip(trip_to_book)
    flight = Flight.find_by(id: trip_to_book.flight_id) #modified this; instead of user.trips[flight_to_book - 1], we have direct trip_to_book now
    trip_to_book[:booked_flight] = true
    trip_to_book.save

    if flight[:time_of_departure] == "-"
      puts "Congrats! You have booked your trip from #{flight[:origin]} to #{flight[:destination]} on #{flight[:date_of_departure]}. Happy traveling!"
    else
      puts "Congrats! You have booked your trip from #{flight[:origin]} to #{flight[:destination]} on #{flight[:date_of_departure]} at #{flight[:time_of_departure]}. Happy traveling!"
    end
  end #adjusts "booked" value, and puts associated flight object data; returns nil


end
