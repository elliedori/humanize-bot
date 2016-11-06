 module Humanize
  include HTTParty

  BASE_URI = "https://humanize-api-test.herokuapp.com/"

  def self.get_content(thing)
    url = BASE_URI + thing

    response = HTTParty.get(url)
  end
end