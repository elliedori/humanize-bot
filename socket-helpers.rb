def send_topic(socket, channel)
  socket.send({type: 'message',
            text: "hey",
            channel: channel
            }.to_json)
end


def send_groups(socket, channel)
  # sleep(10)
  socket.send({type: 'message',
            text: "10 secs later...",
            channel: channel
            }.to_json)
end