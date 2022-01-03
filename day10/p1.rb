=begin
1 becomes 11 (1 copy of digit 1).
11 becomes 21 (2 copies of digit 1).
21 becomes 1211 (one 2 followed by one 1).
1211 becomes 111221 (one 1, one 2, and two 1s).
111221 becomes 312211 (three 1s, two 2s, and one 1).
Starting with the digits in your puzzle input, apply this process 40 times. What is the length of the result?

Your puzzle input is 1113122113.
=end

class String
  def groups()
    a = self.chars
    results = []
    group = []
    cur = a[0]
    a.each do |e|
      if e == cur
        group << e
      else
        results << group
        group = [e]
        cur = e
      end
    end
    return results << cur
  end
end


def look_and_say(s)
  s.groups.map{|g| g.length.to_s + g[0] }.join
end

$input = "1113122113"
40.times do
  $input = look_and_say($input)
end

puts $input.length