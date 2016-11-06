require 'http'
require 'json'
require 'eventmachine'
require 'faye/websocket'
require 'httparty'
require 'pry'
require 'dotenv'
Dotenv.load
require_relative 'humanize-api-helper'
require_relative 'helpers'

humanize_content = Humanize.get_content('tests/5')

slack_response = HTTP.post("https://slack.com/api/rtm.start", params: {
  token: ENV['TOKEN'] 
})

web_socket_url = JSON.parse(slack_response.body)['url']
users = JSON.parse(slack_response.body)['users']

clean_users = users.select {|user| user['profile']['bot_id'].nil?}.map {|user| user['id']}
# clean_users.delete("USLACKBOT")

pair_users(clean_users)