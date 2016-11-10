module Convo

  GREETINGS = ["Hi", "Howdy", ":wave:"]
  BYES = [":wave:", "Bye! Have a good one :blush:"]
  LOVES = [":heart:", ":blush:", ":hugging_face:", "Love you too buddy"]
  THANKS = ["Happy to help!", "You're welcome :simple_smile:", "Anything for you :tulip:"]
  HELP_MESSAGE = "I'm Humanize Bot, your friendly neighborhood bot. I pair people so they can have meaningful conversations on emotional intelligence topics. Before and after the talk, you'll take a quick survey to see how you're feeling. Don't worry – the surveys are completely anonymous! \n\nIf you'd like to suggest a topic for a future session, let me know via DM by typing `suggest` and then the topic. Hope this helps :blush:"
  NO_COMPRENDE = "Sorry, I don't understand. I'm just a little bot doing bot things. Try typing `help` for more info."
  
  def greeting?(words)
    if words =~ /(^hi|hello|hey|howdy)/
      true
    end
  end

  def bye?(words)
    if words =~ /bye/
      true
    end
  end

  def dm_suggestion?(words, channel)
    if words =~ /suggest/ && channel =~ /^D/
      true
    end
  end

  def ch_suggestion?(words, channel)
    if words =~ /suggest/ && channel =~ /^C/
      true
    end
  end

  def love?(words)
    if words =~ /(love|luv u|:heart:)/
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

  def secret_code_words?(words)
    if words =~ /(pen|pineapple|apple|pen)/
      true
    end
  end

  def give_correct_response(input, name, channel)
    if name != "U2Y3X6C10"
      return "#{GREETINGS.sample} <@#{name}>" if greeting?(input)
      return LOVES.sample if love?(input)
      return "If you'd like to suggest a topic for a Humanize session, let me know via DM by typing `suggest` and then the topic. Thanks!"  if ch_suggestion?(input, channel)
      return "Thanks for your suggestion! I've passed it along to your Humanize admin :simple_smile:" if dm_suggestion?(input, channel)
      return THANKS.sample if thankful?(input)
      return ":speak_no_evil:" if bad_words?(input)
      return BYES.sample if bye?(input)
      return HELP_MESSAGE if need_help?(input)
      return "Did someone say :lower_left_ballpoint_pen::pineapple::apple::lower_left_ballpoint_pen: ?" if secret_code_words?(input)
      return NO_COMPRENDE
    end

  end

end
