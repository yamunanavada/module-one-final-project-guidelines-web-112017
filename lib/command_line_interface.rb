=begin
class Session

  attr_accessor :user

  def start
    welcome_message #puts welcome
    login #finds/creates user in Users; sets as @user
    menu #shows menu - launches selected activity/ends session
  end

  def welcome_message
    puts "Hello! Welcome to [insert some cool name here] Flights!"
  end

  def login
    puts "Please enter your name: "
    user_input_name = gets.chomp.downcase
    puts "Please enter your email address: "
    user_input_email = gets.chomp.downcase
    @user = User.find_or_create_by(name: user_name, email: user_email)
  end

  def menu
    puts "What would you like to do? Please enter a number.
    1 - Search Flights
    2 - View My Trips
    3 - Inspire Me
    4 - Exit"
    answer = gets.chomp
    case answer
    when 1
      activity = Search.new(@user)
      activity.go
      menu
    when 2
      activity = ViewTrips.new(@user)
      activity.go
      menu
    when 3
      activity = InspireMe.new(@user)
      activity.go
      menu
    when 4
      puts "Thanks for visiting! Goodbye"
    end
  end

end
=end
