require 'rest-client'
require 'json'
require 'pry'

def find_char_data(char_array, character)
# look for character and return their data
  char_array.select do |char|
    char["name"].downcase == character
  end
end

def find_film_hash(char_data)
  # grabbing all film URLs for that character
  film_array = char_data[0]["films"]

  # collect those film API urls, make a web request to each URL to get the info
  #  for that film
  film_hash = film_array.each_with_object({}) do |film, hash|
    hash[film] = JSON.parse(RestClient.get(film))
  end
end

def get_all_characters_from_api()
  # set up initial values:
  #   page status (final or not)
  final_page = false
  #   url to pass to api
  url = "http://www.swapi.co/api/people/"
  #   array of characters to be built out with api calls
  character_array = []

  # while we aren't on the final page, make continued api calls and update above values
  while !final_page
    #call api with current url
    api_return = RestClient.get(url)
    #parse return data into a hash
    data_hash = JSON.parse(api_return)
    #add character data (hashes) into character_array (array of hashes)
    character_array.concat(data_hash["results"])

    #check to see if we are at the final page or not and update values accordingly
    if data_hash["next"] == nil
      final_page = true
    else
      url = data_hash["next"]
    end
  end
  character_array
end

def get_character_movies_from_api(character)
  #make the web request
  ## ALSO TWEAK #FIND_CHAR_DATA - will no longer need to access results key
  # REMOVED: Functionality now resides in #get_all_characters_from_api()
  # all_characters = RestClient.get('http://www.swapi.co/api/people/')
  # character_hash = JSON.parse(all_characters)

  #make web request for all character data
  character_array = get_all_characters_from_api()

  # iterate over the character hash to find the collection of `films` for the given
  #   `character`
  char_data = find_char_data(character_array, character)
  return if char_data.size == 0
  find_film_hash(char_data)
end

def parse_character_movies(films_hash)
  # some iteration magic and puts out the movies in a nice list
  # grab film titles from films hash
  films_array = films_hash.values.map { |film| film["title"] }

  # number and print it out
  films_array.each_with_index do |film, index|
    puts "#{index+1} #{film}"
  end
end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  if films_hash
    parse_character_movies(films_hash)
  else
    puts "This is not the droid you're looking for!"
  end
end

get_all_characters_from_api

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
