require 'http'
api_key = ''

def get_characters_json
  # Define your Comic Vine API key

  # Endpoint URL for retrieving characters
  characters_url = "https://comicvine.gamespot.com/api/characters/"

  # Parameters for the API request
  params = {
    api_key: api_key,
    format: 'json'
  }

  url = "#{characters_url}?#{URI.encode_www_form(params)}"
  response = HTTP.get(url)

  if response.code == 200
    return JSON.parse(response.to_s)['results']
  else
    puts "Failed to fetch characters. Error: #{response.code}"
  end
end

# Method to fetch characters from Comic Vine API
def fetch_characters
  characters = get_characters_json()
  characters.each_with_index do |character, index|
    puts "#{index + 1}. #{character['name']}"
  end
end

def get_character_json(query_params)
  # Endpoint URL for retrieving characters
  characters_url = "https://comicvine.gamespot.com/api/search/"

  # Parameters for the API request
  params = {
    api_key: api_key,
    format: 'json',
    resources: "character",
    query: query_params
  }

  url = "#{characters_url}?#{URI.encode_www_form(params)}"
  response = HTTP.get(url)

  if response.code == 200
    return JSON.parse(response.to_s)['results']
  else
    puts "Failed to fetch characters. Error: #{response.code}"
  end
end

def get_specific_character(characters_search)
  p "There exist multiple characters of the same name."
  p "Please enter in the name of a specific character from the list:"
  
  character_names = []  
  characters_search.each {|character|
    character_names.push(character["name"])
  }
  p character_names

  specific_character = gets.chomp
  while !character_names.include?(specific_character)
    p "That specific character doesn't seem to be listed"
    p character_names
    p "Please enter in the name of a specific character from the list:"
    specific_character = gets.chomp
  end

  return characters_search[character_names.index(specific_character)]
end

def display_info_parameters(specific_character)
  p "Would you like a custom, default, or complete display of information on your character:"

  request = gets.chomp
  if request == "complete"
    return  specific_character
  elsif request == 'default'
    default = {"name": specific_character["name"],
              "aliases": specific_character["aliases"],
              "real_name": specific_character["real_name"],
              "origin": specific_character["origin"],
              "first_appeared_in_issue": specific_character["first_appeared_in_issue"],
              }
    return default
  else
    return specific_character
  end

end

# Fetch and display characters
puts "Fetching characters from Comic Vine API..."
character_search = get_character_json("Spider Man")
specific_character = get_specific_character(character_search)

p display_info_parameters(specific_character)
