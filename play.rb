require 'http'
require 'json'
require 'eventmachine'
require 'faye/websocket'
require 'dotenv'
require 'httparty'


rc = HTTP.post("https://slack.com/api/auth.test", params: {
  token: ENV['TOKEN']
})