require 'pry'
require 'http'
require 'json'
require 'dotenv'
require 'httparty'
require 'eventmachine'
require 'faye/websocket'
Dotenv.load

require_relative 'content'
require_relative 'helpers'
require_relative 'conversation'
require_relative 'socket-helpers'
require_relative 'humanize-api-helper'

include Convo

# handshake with Slack to get web socket URL

slack_handshake = HTTP.post("https://slack.com/api/rtm.start", params: {
  token: ENV['TOKEN']})
web_socket_url = JSON.parse(slack_handshake.body)['url']


# get and clean user data to create session pairs

users = JSON.parse(slack_handshake.body)['users']
clean_users = users.select {|user| user['profile']['bot_id'].nil? && user['deleted'] == false}.map {|user| user['id']}
clean_users.delete("USLACKBOT")
pairs = pair_users(clean_users)


# begin event machine/web socket with real time bot responses

EM.run do 
  web_socket = Faye::WebSocket::Client.new(web_socket_url)

  web_socket.on :open do |event|
    p [:open]
  end

  web_socket.on :message do |event|
    data = JSON.parse(event.data)
    user_input = data['text']
    user_name = data['user']
    channel = data['channel']

    if user_input
      if user_input =~ /(begin)/

         HTTP.post("https://slack.com/api/chat.postMessage", params: {
          token: ENV['TOKEN'],
          channel: channel,
          text: "Sounds good! :blush: Here are your pair groups for today's session: \n```#{pairs}```",
          as_user: true
          })

        HTTP.post("https://slack.com/api/chat.postMessage", params: {
          token: ENV['TOKEN'],
          channel: channel,
          text: PRELINK,
          as_user: true
          })

        content = [TOPIC, PAIRUP, START, SWITCH, POSTLINK]
        timer = EventMachine::PeriodicTimer.new(60) do
          puts "the time is #{Time.now}"

          # an error in Slack RTM API prevents links from being correctly formatted,
          # have to send them via HTTP/post for now

          HTTP.post("https://slack.com/api/chat.postMessage", params: {
          token: ENV['TOKEN'],
          channel: channel,
          text: content.shift,
          as_user: true
          })
          timer.cancel if content.length == 0
        end
      else
        response = give_correct_response(user_input.downcase, user_name, channel)
        web_socket.send({
          type: 'message',
          text: "#{response}",
          channel: channel
        }.to_json)
      end
    end
    p [:message, data]
  end

  web_socket.on :close do |event|
    p [:close]
  end
  
end



