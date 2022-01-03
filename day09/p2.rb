=begin
For example, given the following distances:

London to Dublin = 464
London to Belfast = 518
Dublin to Belfast = 141

The possible routes are therefore:

Dublin -> London -> Belfast = 982
London -> Dublin -> Belfast = 605
London -> Belfast -> Dublin = 659
Dublin -> Belfast -> London = 659
Belfast -> Dublin -> London = 605
Belfast -> London -> Dublin = 982

The shortest of these is London -> Dublin -> Belfast = 605,
and so the answer is 605 in this example.
=end

class Routes < Hash
  def add_route(loc1, loc2, dis)
    if !self.has_key?(loc1)
      self[loc1] = Hash.new
    end
    if !self.has_key?(loc2)
      self[loc2] = Hash.new
    end
    self[loc1][loc2] = dis
    self[loc2][loc1] = dis
  end

  def get_locations
    self.keys.sort
  end
end

$routes = Routes.new

File.open("./data.txt").each do |line|
  caps = line.match(/^(\w+)\sto\s(\w+)\s=\s(\d+)$/).captures
  $routes.add_route(caps[0], caps[1], caps[2].to_i)
end

$longest_distance = 0
$longest_route = []

$routes.get_locations.permutation.to_a.each do |route|
  distance = route.each_cons(2).map { |locs| $routes[locs[0]].has_key?(locs[1]) ? $routes[locs[0]][locs[1]] : Float::INFINITY }.reduce(&:+)
  if distance > $longest_distance
    $longest_distance = distance
    $longest_route = route
  end
end

p $longest_route
puts $longest_distance