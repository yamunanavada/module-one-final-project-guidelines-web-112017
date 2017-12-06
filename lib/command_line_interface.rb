def welcome
  "Hello! Welcome to [insert some cool name here] Flights!"
end

def enter_user
  puts "Please enter your name: "
  gets.chomp.downcase
end

def enter_email
  puts "Please enter your email address: "
  gets.chomp.downcase
end

def origin
  puts "Please enter your starting location: "
  gets.chomp.downcase
end

def destination
  puts "Please enter your destination: "
  gets.chomp.downcase
end

def date
  puts "What is your desired departure date? "
  gets.chomp.downcase
end

def select_flights

  puts "Would you like to save a flight? (Y/N)"
  answer = gets.chomp.downcase
  if answer == "y"
    puts "Please list the flight number(s) that you would like to save. If selecting multiple, please separate with a space."
    flights = gets.chomp.downcase
  elsif answer != "y" || answer != "n"
    puts "That was an incorrect response!"
  end

  flights_to_save = flights.split(" ")
end
