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

include Convo

allyship = <<-allyquote 
Hi friends, today's topic is *Allyship*. What is an `ally`?\n
```An ally is someone who advocates for and works to reduce the oppression of a group that's not their own.```\n
For example, some of my bot friends who are animals (like Polly, if you know her) get made fun of for being animal bots. Even though I'm not an animal bot, I speak up when this happens because it's not kind to treat others differently based on how they look.\n\n
My human friends tell me that it's a lot harder and more complicated with humans. Oftentimes opportunities for allyship happen during microaggressions. What is a `microaggression`?\n```Microaggressions are the everyday verbal, nonverbal, and environmental slights, snubs, or insults, whether intentional or unintentional, which communicate hostile, derogatory, or negative messages to target persons based solely upon their marginalized group membership.```
*For this session:* \n ```Get together with your pair and talk about a moment when you acted as an ally, or wish you had acted as an ally. Sometimes we see things that aren't right, but it's scary to speak up. If you're sharing a moment when you didn't speak up but wish you had, share what you would have said.```\n\n
Here are some helpful links if you want to learn more:\n
> `<http://www.diversitydufferin.com/how-to-be.html | What Is An Ally?>`\n> `<https://medium.com/@agelender/6-action-items-for-white-people-in-the-workplace-beyond-ecf87271e89a#.cuxp78nv7 | Actionable Allyship>`\n> `<http://leanin.org/tips/workplace-ally | How To Be a Workplace Ally>`\n> `<http://www.diversityinc.com/diversity-events/the-stereotype-threat-dr-claude-steele-mesmerizes-audience-video/ | Stereotype Threat & Workplace Diversity>`
allyquote



# humanize_content = Humanize.get_content('tests/5')

slack_response = HTTP.post("https://slack.com/api/rtm.start", params: {
  token: ENV['TOKEN'] 
})

web_socket_url = JSON.parse(slack_response.body)['url']
users = JSON.parse(slack_response.body)['users']

clean_users = users.select {|user| user['profile']['bot_id'].nil? && user['deleted'] == false}.map {|user| user['id']}
clean_users.delete("USLACKBOT")
pairs = pair_users(clean_users)

# HTTP.post("https://slack.com/api/chat.postMessage", params: {
#   token: ENV['TOKEN'],
#   channel: '#testing',
#   text: "```#{pairs}```",
#   as_user: true
#   })
# sleep(10)

# HTTP.post("https://slack.com/api/chat.postMessage", params: {
#   token: ENV['TOKEN'],
#   channel: '#testing',
#   text: "#{allyship}",
#   as_user: true
#   })


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

      n = 0
      timer = EventMachine::PeriodicTimer.new(1) do
        puts "the time is #{Time.now}"
        web_socket.send({
          type: 'message',
          text: "once",
          channel: channel
        }.to_json)
        timer.cancel if (n+=1) > 5
      end

      n = 0
      timer = EventMachine::PeriodicTimer.new(5) do
        puts "the time is #{Time.now}"
        web_socket.send({
          type: 'message',
          text: "1",
          channel: channel
        }.to_json)
        timer.cancel if (n+=1) > 5
      end
              


        # EventMachine::Timer.new(5) {
        
        # web_socket.send({
        #   type: 'message',
        #   text: "2",
        #   channel: channel
        # }.to_json)}

        # # timer

        
        # EventMachine::Timer.new(5) {
        
        # web_socket.send({
        #   type: 'message',
        #   text: "3",
        #   channel: channel
        # }.to_json)}



       
        # if send_topic(web_socket, channel)
        #   debug("hi")
        # end
        #  sleep(10)
        #  send_groups(web_socket, channel)
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



