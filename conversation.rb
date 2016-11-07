module Convo

  greetings = ["Hi", "Howdy", ":wave:"]
  loves = [":blush:", ":heart:", ":hugging_face:"]
  help_message = "I'm Humanize Bot, your friendly neighborhood bot. I pair people so they can have meaningful conversations on emotional intelligence topics. Before and after the talk, you'll take a quick survey to see how you're feeling. Don't worry – the survey are completely anonymous! Hope this helps :simple_smile:"

  def greeting?(words)
    if words =~ /(hi|hello|hey|yo)/
      true
    end
  end

  def love?(words)
    if words =~ /(love you)|(luv u)/
      true
    end
  end

  def need_help?(words)
    if words == "help"
      true
    end
  end

  def give_correct_response(input)
    "#{greetings.sample} <@#{data['user']}>" if greeting?(input)
    loves.sample if love?(input)
    help_message if need_help?(input)
      
  end

end