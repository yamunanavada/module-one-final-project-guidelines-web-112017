require 'rest-client'
require 'JSON'
require "pry"


class ViewMyTrips

  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def go
    view_trips #looks up user's trips, prints out. should return nil
    menu_for_view_trips #either ends in flight booked, or nothing; either way, nil
  end

  def view_trips
    binding.pry
    if @user.trips.length == 0
      puts "You have no trips saved."
    elsif
      @user.trips.map do |trip|
        flight = Flight.find_by(id: trip[:flight_id])
        if flight[:time_of_departure] == "-"
          puts "#{user.trips.index(trip) + 1}: $#{flight[:price]}. Departs from #{flight[:origin]} on #{flight[:date_of_departure]}. Arrives at #{flight[:destination]} on #{flight[:date_of_arrival]}."
        else
          puts "#{user.trips.index(trip) + 1}: $#{flight[:price]}. Departs from #{flight[:origin]} on #{flight[:date_of_departure]} at #{flight[:time_of_departure]}. Arrives at #{flight[:destination]} on #{flight[:date_of_arrival]} at #{flight[:time_of_arrival]}. Number of layovers: #{flight[:number_of_layovers]}."
        end
      end
    end
    puts "--------------------------------------"
  end #returns nil

  def menu_for_view_trips
    binding.pry
    puts "Please select an option.
    1 - Book a Trip
    2 - Delete a Trip
    3 - Back to Main Menu"
    answer = gets.chomp.to_i
    case answer
    when 1
      puts "--------------------------------------"
      book_a_flight?
      go
    when 2
      puts "--------------------------------------"
      delete_a_trip? #loops until success, then returns nil
      go
    when 3
    end
  end


  def delete_a_trip?
    binding.pry
    puts "Please list the number of the flight you would like to delete from your saved trips."
    trip = gets.chomp.to_i
    if trip > user.trips.length  #user chooses a trip not shown
      begin
        raise PartnerError
      rescue PartnerError => error
        puts error.delete_message
        delete_a_trip? #start this method again
      end
    end
    delete_trip(trip, @user)
    #go
  end


  def delete_trip(trip_to_delete, user)
    binding.pry
    #array of flights, find the trip, and delete it.
    x = Trip.where(flight_id: user.trips[trip_to_delete - 1][:flight_id], user_id: user.id)
    binding.pry
    x.delete_all
    @user.trips.reload
    puts "The selected trip has been deleted."
  end



  def book_a_flight?
    puts "--------------------------------------"
    puts "Please list the number of the flight you would like to book. Please list just one flight."
    flight = gets.chomp.to_i
    book_trip(flight, @user)
  end


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
