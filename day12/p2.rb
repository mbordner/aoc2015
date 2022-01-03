=begin

Uh oh - the Accounting-Elves have realized that they double-counted everything red.

Ignore any object (and all of its children) which has any property with the value "red".
Do this only for objects ({...}), not arrays ([...]).

[1,2,3] still has a sum of 6.
[1,{"c":"red","b":2},3] now has a sum of 4, because the middle object is ignored.
{"d":"red","e":[1,2,3,4],"f":5} now has a sum of 0, because the entire structure is ignored.
[1,"red",5] has a sum of 6, because "red" in an array has no effect.

=end

require 'json'

def rec_obj(o)
  sum = 0
  o.each do |k, v|
    if v == "red"
      return 0
    elsif v.is_a?(Numeric)
      sum += v
    elsif v.is_a?(Array)
      sum += rec_arr(v)
    elsif v.is_a?(Hash)
      sum += rec_obj(v)
    end
  end
  return sum
end

def rec_arr(a)
  sum = 0
  a.each do |v|
    if v.is_a?(Numeric)
      sum += v
    elsif v.is_a?(Array)
      sum += rec_arr(v)
    elsif v.is_a?(Hash)
      sum += rec_obj(v)
    end
  end
  return sum
end

$data = JSON.parse(File.read("./data.txt"))

if $data.is_a?(Array)
  puts rec_arr($data)
else
  puts rec_obj($data)
end


