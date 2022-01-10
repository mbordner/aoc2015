class Integer
  def factors
    1.upto(Math.sqrt(self)).select { |i| (self % i).zero? }.inject([]) do |f, i|
      f << i
      f << self / i unless i == self / i
      f
    end.sort
  end

  def paired_up_factors
    a = self.factors
    l = a.length
    if l % 2 == 0
      a[0, l / 2].zip(a[-l / 2, l / 2].reverse)
    else
      a[0, l / 2].zip(a[-l / 2 + 1, l / 2].reverse) + [a[l / 2], a[l / 2]]
    end
  end
end

require "prime"

def factors_of(number)
  primes, powers = Prime.prime_division(number).transpose
  exponents = powers.map { |i| (0..i).to_a }
  divisors = exponents.shift.product(*exponents).map do |powers|
    primes.zip(powers).map { |prime, power| prime ** power }.inject(:*)
  end
  divisors.sort.map { |div| [div, number / div] }
end

if __FILE__ == $0
  p factors_of(4800)
  p 4800.paired_up_factors

  p 6.factors
  p 7.factors
  p 8.factors
  p 9.factors
  p 12.factors

  p 120.factors

end