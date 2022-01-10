class Integer
  def factors
    1.upto(Math.sqrt(self)).select { |i| (self % i).zero? }.reduce([]) do |f, i|
      f << i
      f << self / i unless i == self / i
      f
    end.sort
  end
end

input = 29000000

num = input / 50
quit_after = 50

while (answer = num.factors.last(quit_after).select { |x| num <= quit_after * x }.map { |x| x * 11 }.reduce(&:+)) < input
  p [num, answer]
  num += 1
end

# 3625000 too high
# 655200 too low
p num

