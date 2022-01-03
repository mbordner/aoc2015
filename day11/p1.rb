=begin
To help him remember his new password after the old one expires, Santa has devised a method of coming up with a password based on the previous one. Corporate policy dictates that passwords must be exactly eight lowercase letters (for security reasons), so he finds his new password by incrementing his old password string repeatedly until it is valid.

Incrementing is just like counting with numbers: xx, xy, xz, ya, yb, and so on. Increase the rightmost letter one step; if it was z, it wraps around to a, and repeat with the next letter to the left until one doesn't wrap around.

Unfortunately for Santa, a new Security-Elf recently started, and he has imposed some additional password requirements:

Passwords must include one increasing straight of at least three letters, like abc, bcd, cde, and so on, up to xyz. They cannot skip letters; abd doesn't count.
Passwords may not contain the letters i, o, or l, as these letters can be mistaken for other characters and are therefore confusing.
Passwords must contain at least two different, non-overlapping pairs of letters, like aa, bb, or zz.
For example:

hijklmmn meets the first requirement (because it contains the straight hij) but fails the second requirement requirement (because it contains i and l).
abbceffg meets the third requirement (because it repeats bb and ff) but fails the first requirement.
abbcegjk fails the third requirement, because it only has one double letter (bb).
The next password after abcdefgh is abcdffaa.
The next password after ghijklmn is ghjaabcc, because you eventually skip all the passwords that start with ghi..., since i is not allowed.
Given Santa's current password (your puzzle input), what should his next password be?

Your puzzle input is hxbxwxba.
=end

class Password
  Letters = * ('a'..'z')
  Numbers = * ('0'..'9')
  NumbersLetters = Password::Numbers + Password::Letters
  InvalidChars = "iol"

  def Password.init_map(a)
    m = {}
    a.each_with_index do |e, i|
      m[e] = i
    end
    return m
  end

  def Password.init_invalid_chars()
    Regexp.new("(" + Password::InvalidChars.split("").join("|") + ")")
  end

  LettersMap = Password::init_map(Password::Letters)
  NumbersLettersMap = Password::init_map(Password::NumbersLetters)
  InvalidCharsRegex = Password::init_invalid_chars()
  RepeatGroupRegex = /(.)\1{1}/

  def initialize(pass)
    @password = pass
  end

  def incr
    new_pass = @password
    loop do
      new_pass = incr_base26_str(new_pass)
      if valid(new_pass)
        break
      else
        if !has_valid_chars(new_pass)
          new_pass = skip_invalid_chars(new_pass)
        end
      end
    end
    Password.new(new_pass)
  end

  def incr_base26_str(s = @password)
    num_s = s.chars.map { |c| Password::NumbersLetters[Password::LettersMap[c]] }.join
    num = num_s.to_i(26)
    num += 1
    num.to_s(26).rjust(8, "0").chars.map { |c| Password::Letters[Password::NumbersLettersMap[c]] }.join
  end

  def skip_invalid_chars(pass = @password)
    (Password::InvalidChars).chars.each do |ic|
      if pass.match(Regexp.new(ic))
        tokens = pass.split(ic, 2)
        pass = tokens[0] + ic
        pass += ("z" * (8 - pass.length))
      end
    end
    return pass
  end

  def to_s
    @password
  end

  def valid(pass = @password)
    has_valid_chars(pass) && has_straight(pass) && pairs_count(pass) >= 2
  end

  def has_straight(pass = @password)
    pass.chars.each_cons(3).map { |s|
      sum = 0
      if (s[0].ord == (s[1].ord - 1)) && (s[1].ord == (s[2].ord - 1))
        sum += 1
      end
      sum
    }.reduce(&:+) > 0
  end

  def has_valid_chars(pass = @password)
    if pass.match(Password::InvalidCharsRegex)
      return false
    end
    return true
  end

  def pairs_count(pass = @password)
    if pass.match(Password::RepeatGroupRegex)
      return pass.scan(Password::RepeatGroupRegex).length
    end
    return 0
  end
end

puts Password.new("hxbxwxba").incr.incr