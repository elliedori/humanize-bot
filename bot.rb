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

clean_users = users.select {|user| user['profile']['bot_id'].nil? && user['deleted'] == false}.map {|user| user['id']}
clean_users.delete("USLACKBOT")
pairs = pair_users(clean_users)


HTTP.post("https://slack.com/api/chat.postMessage", params: {
  token: ENV['TOKEN'],
  channel: '#testing',
  text: "```#{pairs}```",
  as_user: true
  })

EM.run do 
  web_socket = Faye::WebSocket::Client.new(web_socket_url)

  web_socket.on :open do |event|
    p [:open]
  end

  web_socket.on :message do |event|
    data = JSON.parse(event.data)
    user_input = data['text']

    if user_input
      case user_input.downcase
      when 'hi'
        web_socket.send({
          type: 'message',
          text: "Hi <@#{data['user']}>",
          channel: data['channel']
        }.to_json)
      when 'love you'
        web_socket.send({
          type: 'message',
          text: ":heart:",
          channel: data['channel']
        }.to_json)
      when 'you gucci?'
        web_socket.send({
          type: 'message',
          text: "You know it.",
          channel: data['channel']
        }.to_json)
      end
    end
    p [:message, data]
  end

  web_socket.on :close do |event|
    p [:close]
  end
  
end



