def debug(obj)
  puts "*" * 100
  p obj
end

def get_slack_names(users)
  users.map{|user_id| "<@#{user_id}>"}
end

def generate_slack_string(pairs)
  pairs.map! {|pair| pair.join(" & ")}.join(" \n")
end

def pair_users(users)
  shuffled = get_slack_names(users).shuffle
  pairs = shuffled.each_slice(2).to_a
  if pairs.last.length == 1
    pairs[-2].push(pairs.last).flatten!
    pairs.delete(pairs.last)
  end
  generate_slack_string(pairs)
end