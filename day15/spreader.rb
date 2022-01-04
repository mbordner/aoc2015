class Spreader
  def initialize(buckets)
    @buckets = buckets
  end

  def spread(amt)
    spreads = []
    cur = []
    spread_rec(amt, 0, 0, spreads, cur)
    return spreads
  end

  def spread_rec(amt, sum, start, spreads, cur)
    if sum == amt
      if cur.length == @buckets
        spreads << cur.dup
      end
    end

    if cur.length < @buckets
      for i in start..amt
        temp_sum = sum + i
        if temp_sum <= amt
          cur.push(i)
          spread_rec(amt, temp_sum, i, spreads, cur)
          cur.pop()
        else
          break
        end
      end
    end
  end
end

if __FILE__ == $0
  s = Spreader.new(4)
  results = s.spread(5)
  p results
  puts results.length
end