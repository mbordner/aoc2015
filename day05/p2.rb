
=begin
Now, a nice string is one with all of the following properties:

It contains a pair of any two letters that appears at least twice in the string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
It contains at least one letter which repeats with exactly one letter between them, like xyx, abcdefeghi (efe), or even aaa.
For example:

qjhvhtzxzqqjkmpb is nice because is has a pair that appears twice (qj) and a letter that repeats with exactly one letter between them (zxz).
xxyxx is nice because it has a pair that appears twice and a letter that repeats with one between, even though the letters used by each rule overlap.
uurcxstgmygtbstg is naughty because it has a pair (tg) but no repeat with a single letter between them.
ieodomkazucvgmuy is naughty because it has a repeating letter with one between (odo), but no pair that appears twice.
How many strings are nice under these new rules?

puts nice("qjhvhtzxzqqjkmpb")
puts nice("xxyxx")
puts nice("uurcxstgmygtbstg")
puts nice("ieodomkazucvgmuy")
=end


def nice(s)
  if s.match(/(..).*\1{1}/)
    if s.match(/(.).{1}\1{1}/)
      return true
    end
  end
  return false
end

puts nice("qjhvhtzxzqqjkmpb")
puts nice("xxyxx")
puts nice("uurcxstgmygtbstg")
puts nice("ieodomkazucvgmuy")

nice_count = 0

File.open("./data.txt").each do |line|
  if nice(line)
    nice_count += 1
  end
end

puts nice_count
