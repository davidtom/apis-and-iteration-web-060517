def welcome
  puts "Welcome to Star Wars API CLI. May the Force \n May the Force be with you."
end

def get_character_from_user
  # use gets to capture the user's input. This method should return that input, downcased.
  puts "please enter a character"
  character = gets.chomp
  character.downcase
end
