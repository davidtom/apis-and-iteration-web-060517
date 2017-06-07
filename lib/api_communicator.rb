require 'rest-client'
require 'json'
require 'pry'

def get_character_movies_from_api(character)
  ## DOCSTRING
  # iterate over the character hash to find the collection of `films` for the given
  #   `character`
  # collect those film API urls, make a web request to each URL to get the info
  #  for that film
  # return value of this method should be collection of info about each film.
  #  i.e. an array of hashes in which each hash reps a given film
  # this collection will be the argument given to `parse_character_movies`
  #  and that method will do some nice presentation stuff: puts out a list
  #  of movies by title. play around with puts out other info about a given film.
  #make the web request

  #Query SWAPI to get data on all people in SW
  all_characters = RestClient.get('http://www.swapi.co/api/people/')
  character_hash = JSON.parse(all_characters)

  #Create array that stores only results
  results = character_hash["results"]

  #iterate over results to return the char_data for the desired character
  char_data = results.select do |char|
    char["name"].downcase == character
  end

  #Store films for desired character in an array
  film_array = char_data[0]["films"]

  film_hash = film_array.each_with_object({}) do |film, hash|
    hash[film] = JSON.parse(RestClient.get(film))
  end
end

def parse_character_movies(films_hash)
  # some iteration magic and puts out the movies in a nice list

  #Iterate over values of films_hash and collect film titles
  films_array = films_hash.values.collect{|film| film["title"]}

  #Iterate over film titles in films_array and print them as a numbered list
  films_array.each_with_index do |title, index|
    puts "#{index+1} #{title}"
  end
end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  parse_character_movies(films_hash)
end


## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
