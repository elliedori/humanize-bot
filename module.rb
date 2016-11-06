 module Humanize
  include HTTParty

  BASE_URI = "https://humanize-api-test.herokuapp.com/"

  def self.get_the_thing(thing)
    url = BASE_URI + thing

    response = HTTParty.get(url)
  end
end