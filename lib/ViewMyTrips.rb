require 'rest-client'
require 'JSON'
require "pry"


class ViewMyTrips

  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def go
    view_trips #looks up user's trips, prints out
    book_a_flight? #either ends in flight booked, or nothing; either way, nil
  end

  def view_trips
    @user.trips.map do |trip|
      flight = Flight.find_by(id: trip[:flight_id])
      puts "#{user.trips.index(trip) + 1}: $#{flight[:price]}. Departs from #{flight[:origin]} on #{flight[:date_of_departure]} at #{flight[:time_of_departure]}. Arrives at #{flight[:destination]} on #{flight[:date_of_arrival]} at #{flight[:time_of_arrival]}. Number of layovers: #{flight[:number_of_layovers]}."
    end
  end

  def book_a_flight?
    puts "Would you like to book a flight? Y/N"
    answer = gets.chomp.downcase
    if answer == "y"
      puts "Please list the number of the flight you would like to book. Please list just one flight."
      flight = gets.chomp.to_i
      book_trip(flight, @user)
    elsif answer == "n"
      puts "Ok, you have not selected a flight to book. Here's the menu of options."
    end
  end


  def book_trip(flight_to_book, user)
  flight = Flight.find_by(id: user.trips[flight_to_book - 1][:flight_id])
  user.trips[flight_to_book - 1].booked_flight = true
  puts "Congrats! You have booked your trip from #{flight[:origin]} to #{flight[:destination]} on #{flight[:date_of_departure]} at #{flight[:time_of_departure]}. Happy traveling!"
  end


end
