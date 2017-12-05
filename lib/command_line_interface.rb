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
