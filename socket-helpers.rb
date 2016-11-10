def send_groups(socket, pairs, channel)
  socket.send({type: 'message',
            text: "Hi friends! We've got a Humanize session today :blush: Here are your pair groups for this session: \n```#{pairs}```",
            channel: channel
            }.to_json)
end