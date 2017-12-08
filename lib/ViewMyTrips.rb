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

  def view_trips #prints, and returns nil
    if @user.trips.length == 0  #if user has no saved Trips - put "you have 0"
      puts "You have no trips saved."
    elsif #otherwise, for each Trip saved, find the Flight object
      @user.trips.map do |trip| #for each trip associated with User
        flight = Flight.find_by(id: trip[:flight_id]) #take the flight_id, use it to search Flight (flight_id = id)
        if flight[:time_of_departure] == "-"
          puts "#{user.trips.index(trip) + 1}: $#{flight[:price]}. Departs from #{flight[:origin]} on #{flight[:date_of_departure]}. Arrives at #{flight[:destination]} on #{flight[:date_of_arrival]}."  #these conditionals just determine who to present the results
        else
          puts "#{user.trips.index(trip) + 1}: $#{flight[:price]}. Departs from #{flight[:origin]} on #{flight[:date_of_departure]} at #{flight[:time_of_departure]}. Arrives at #{flight[:destination]} on #{flight[:date_of_arrival]} at #{flight[:time_of_arrival]}. Number of layovers: #{flight[:number_of_layovers]}."
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
      book_a_flight? #books a trip, returns nil
      go #start ViewMyTrips journey again
    when 2
      puts "--------------------------------------"
      delete_a_trip? #loops until success, then returns nil
      go
    when 3
      #all done, so goes back to session, which points to MainMenu
    end
  end


  def delete_a_trip?
    puts "Please list the number of the flight you would like to delete from your saved trips."
    trip = gets.chomp.to_i
    if trip > user.trips.length  #i.e. if user chooses a trip not shown
      begin
        raise PartnerError
      rescue PartnerError => error
        puts error.delete_message
        delete_a_trip? #start this method again; trip will be reset.
      end
    else #if user chooses a valid trip - #changed THIS!!! was end
    delete_trip(trip, @user)
    binding.pry#
    #go
    end
  end


  def delete_trip(trip_to_delete, user)
    #array of flights, find the trip, and delete it.
    x = Trip.where(flight_id: user.trips[trip_to_delete - 1][:flight_id], user_id: user.id)
    x.delete_all
    @user.trips.reload
    puts "The selected trip has been deleted."
  end



  def book_a_flight?
    puts "--------------------------------------"
    puts "Please list the number of the flight you would like to book. Please list just one flight."
    flight = gets.chomp.to_i
    book_trip(flight, @user)
    binding.pry
  end #returns nil


  def book_trip(flight_to_book, user)
    flight = Flight.find_by(id: user.trips[flight_to_book - 1][:flight_id])

    user.trips[flight_to_book - 1].booked_flight = true
    if flight[:time_of_departure] == "-"
      puts "Congrats! You have booked your trip from #{flight[:origin]} to #{flight[:destination]} on #{flight[:date_of_departure]}. Happy traveling!"
    else
      puts "Congrats! You have booked your trip from #{flight[:origin]} to #{flight[:destination]} on #{flight[:date_of_departure]} at #{flight[:time_of_departure]}. Happy traveling!"
    end
  end


end
