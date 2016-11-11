def send_groups(socket, pairs, channel)
  socket.send({type: 'message',
            text: "Sounds good! :blush: Here are your pair groups for today's session: \n```#{pairs}```",
            channel: channel
            }.to_json)
end

def send_topic(socket, topic, channel)
  socket.send({type: 'message',
            text: topic,
            channel: channel
            }.to_json)
end