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
require_relative 'conversation'
require_relative 'socket-helpers'
require_relative 'content'

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

        # pre_link = "Here's the pre-session survey < http://humanizebot.herokuapp.com/dropbox/survey?type=before | link >."
        # post_link = "Here's the post-session survey < http://humanizebot.herokuapp.com/dropbox/survey?type=after | link >."

        send_groups(web_socket, pairs, channel)
        content = [PRELINK, TOPIC, START, SWITCH, POSTLINK]
        timer = EventMachine::PeriodicTimer.new(3) do
          puts "the time is #{Time.now}"
          web_socket.send({
            type: 'message',
            text: content.shift,
            channel: channel
          }.to_json)
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



