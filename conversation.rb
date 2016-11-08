module Convo

  GREETINGS = ["Hi", "Howdy", ":wave:"]
  LOVES = [":heart:", ":blush:", ":hugging_face:", "Love you too buddy"]
  THANKS = ["Happy to help!", "You're welcome :simple_smile:", "Anything for you :tulip:"]
  HELP_MESSAGE = "I'm Humanize Bot, your friendly neighborhood bot. I pair people so they can have meaningful conversations on emotional intelligence topics. Before and after the talk, you'll take a quick survey to see how you're feeling. Don't worry – the surveys are completely anonymous! Hope this helps :simple_smile:"
  NO_COMPRENDE = "Sorry, I don't understand. I'm just a little bot doing bot things. Try typing `help` for more info."
  
  def greeting?(words)
    if words =~ /(^hi|hello|hey|howdy)/
      true
    end
  end

  def love?(words)
    if words =~ /(love|luv u)/
      true
    end
  end

  def thankful?(words)
    if words =~ /(thanks|thank|thnx)/
      true
    end
  end

  def need_help?(words)
    if words == "help"
      true
    end
  end

  def bad_words?(words)
    if words =~ /(fuck|shit|hate|asshole)/
      true
    end
  end

  def give_correct_response(input, data)
    return "#{GREETINGS.sample} <@#{data}>" if greeting?(input)
    return LOVES.sample if love?(input)
    return THANKS.sample if thankful?(input)
    return ":speak_no_evil:" if bad_words?(input)
    return HELP_MESSAGE if need_help?(input)
    return NO_COMPRENDE

  end

end
