Pos = Struct.new(:x,:y) do
  def transform(dx,dy)
    self.x += dx
    self.y += dy
  end
  def hash
    return self.x * 10000000000000 + self.y
  end
  def ==(o)
    return self.x == o.x && self.y == o.y
  end
  alias eql? ==
end


$visited = Hash.new()

def visit(p)
  if $visited.key?(p)
    $visited[p] = $visited[p]+1
  else
    $visited[p] = 1
  end
end

location = Pos.new(0,0)
visit(location)

data = File.read("./data.txt")
#data = "^v^v^v^v^v"
#data = "^>v<"
#data = ">"
data.split('').each do |dir|
  case dir
  when '>'
    location.transform(1,0)
  when '<'
    location.transform(-1,0)
  when '^'
    location.transform(0,-1)
  when 'v'
    location.transform(0,1)
  end
  visit(location)
end

puts($visited)

# 2598 is too high
puts($visited.count)