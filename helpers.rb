def debug(obj)
  puts "*" * 100
  p obj
end

def pair_users(users)
  shuffled = users.shuffle

    pairs = shuffled.each_slice(2).to_a

    if pairs.last.length == 1
      pairs[-2].push(pairs.last).flatten!
      pairs.delete(pairs.last)
    end
    debug(pairs)
end