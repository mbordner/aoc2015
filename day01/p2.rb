data = File.read("./data.txt")

floor = 0
pos = 0
while floor >= 0
  if data[pos] == "("
    floor += 1
  else
    floor -= 1
  end
  pos += 1
end

puts pos
