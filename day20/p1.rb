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

num = input / 80
while num.factors.reduce(&:+) < input / 10
  num += 1
end

p num.factors

puts (num - 1).factors.map { |x| x * 10 }.reduce(&:+)
puts num.factors.map { |x| x * 10 }.reduce(&:+)

# 1450000 too high
# 725760 too high
# 665280 is answer
puts num
