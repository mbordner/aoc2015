Pos = Struct.new(:x,:y) do
  def transform(dx,dy)
    Pos.new(self.x + dx, self.y + dy)
  end
end


$visited = Hash.new()

def visit(p)
  #puts "visiting " + p.x.to_s + "," + p.y.to_s
  if $visited.key?(p)
    $visited[p] = $visited[p]+1
  else
    $visited[p] = 1
  end
end

$santa = Pos.new(0,0)
$roboSanta = Pos.new(0,0)
visit($santa)
visit($roboSanta)

data = File.read("./data.txt")
#data = "^v^v^v^v^v"
#data = "^>v<"
#data = ">"
#data = "^v"
data.split('').each_with_index do |dir,index|
  location = index % 2 == 0 ? $santa : $roboSanta
  case dir
  when '>'
    location = location.transform(1,0)
  when '<'
    location = location.transform(-1,0)
  when '^'
    location = location.transform(0,-1)
  when 'v'
    location = location.transform(0,1)
  end
  visit(location)
  if index %2 == 0
    $santa = location
  else
    $roboSanta = location
  end
end

puts($visited)

# 2499 is too high
# 2498 is too high
puts($visited.count)

puts($santa)
puts($roboSanta)