=begin
"" is 2 characters of code (the two double quotes), but the string contains zero characters.
"abc" is 5 characters of code, but 3 characters in the string data.
"aaa\"aaa" is 10 characters of code, but the string itself contains six "a" characters and a single, escaped quote character, for a total of 7 characters in the string data.
"\x27" is 6 characters of code, but the string itself contains just one - an apostrophe ('), escaped using hexadecimal notation.
=end

def memval(s)
  s = s.strip
  s = s[1..-2]
  s = s.gsub(/\\"/,"\"")
  s = s.gsub(/\\\\/,"\\")
  if s.match(/(\\x[a-f0-9]{2})/)
    s.scan(/\\x[a-f0-9]{2}/).each do |h|
      v = h[2..].to_i(16)
      s = s.gsub(h,v.chr)
    end
  end
  return s
end

$input_string_count = 0
$mem_string_count = 0

File.open("./data.txt").each do |line|
  line = line.strip
  $input_string_count += line.length
  line = memval(line)
  $mem_string_count += line.length
end

puts $input_string_count - $mem_string_count