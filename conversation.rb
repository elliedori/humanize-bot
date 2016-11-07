module Convo

  GREETINGS = ["Hi", "Howdy", ":wave:"]
  LOVES = [":heart:", ":blush:", ":hugging_face:", "Love you too buddy"]
  HELP_MESSAGE = "I'm Humanize Bot, your friendly neighborhood bot. I pair people so they can have meaningful conversations on emotional intelligence topics. Before and after the talk, you'll take a quick survey to see how you're feeling. Don't worry – the surveys are completely anonymous! Hope this helps :simple_smile:"

  def greeting?(words)
    if words =~ /(hi|hello|hey)/
      true
    end
  end

  def love?(words)
    if words =~ /(love)|(luv u)/
      true
    end
  end

  def need_help?(words)
    if words == "help"
      true
    end
  end

  def give_correct_response(input, data)
    return "#{GREETINGS.sample} <@#{data}>" if greeting?(input)
    return LOVES.sample if love?(input)
    return HELP_MESSAGE if need_help?(input)
  end

end
