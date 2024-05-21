class ComicVineCharacters
  require 'http'

  def initialize()
    @api_key = ""
  end

  def get_characters_json
    # Define your Comic Vine API key

    # Endpoint URL for retrieving characters
    characters_url = "https://comicvine.gamespot.com/api/characters/"

    # Parameters for the API request
    params = {
      api_key: @api_key,
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

  def get_search_json()
    # Endpoint URL for retrieving characters
    search_url = "https://comicvine.gamespot.com/api/search/"

    resources = ["character", "concept", "origin", "object", "location", "issue", "story_arc", "volume", "publisher", "person", "team", "video"]
    p "Here are a list of searchable resrources from Comic Vine."
    p resources
    p "Please enter in what you'd like to search"
    resource_searched = gets.chomp

    while !resources.include?(resource_searched)
      p "That specific resource doesn't seem to be listed"
      p resources
      p "Please enter in what you'd like to search"
      resource_searched = gets.chomp
    end

    p "Enter what you would like to search #{resource_searched} for:"
    search_term = gets.chomp


    # Parameters for the API request
    params = {
      api_key: @api_key,
      format: 'json',
      resources: resource_searched,
      query: search_term
    }

    url = "#{search_url}?#{URI.encode_www_form(params)}"
    response = HTTP.get(url)

    if response.code == 200
      results = JSON.parse(response.to_s)['results']
      if results.length == 0
        p "No results found"
      elsif results.length == 1
        return ressults[0]
      else
        get_specific_search(results)
      end
    else
      puts "Failed to fetch #{resource_searched}. Error: #{response.code}"
    end
  end

  def get_specific_search(search)
    p "There exist multiple results of the same name."
    p "Please enter in the name of a specific result from the list:"
    
    search_names = []  
    search.each {|result|
      search_names.push(result["name"])
    }
    p search_names

    specific_search = gets.chomp
    while !search_names.include?(specific_search)
      p "That specific character doesn't seem to be listed"
      p search_names
      p "Please enter in the name of a specific character from the list:"
      specific_search = gets.chomp
    end

    return search[search_names.index(specific_search)]
  end

  def display_character_by_parameters(specific_character)
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
end

#Fetch and display characters
puts "Fetching characters from Comic Vine API..."
specific_search = ComicVineCharacters.new().get_search_json()
specific_search_display = ComicVineCharacters.new().display_character_by_parameters(specific_search)
p specific_search_display

