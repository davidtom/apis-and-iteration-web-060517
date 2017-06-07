def welcome
  # puts out a welcome message here!
  puts "Welcome to the StarWars API CPI."
  puts "May the force be with you!"
end

def get_character_from_user
  puts "please enter a character"
  # use gets to capture the user's input. This method should return that input, downcased.
  gets.chomp.downcase
end
