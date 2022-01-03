class Happiness < Hash
  def add(ent1, ent2, happiness)
    if !self.has_key?(ent1)
      self[ent1] = Hash.new
    end
    if !self.has_key?(ent2)
      self[ent2] = Hash.new
    end
    self[ent1][ent2] = happiness
  end

  def add_myself(myself = "myself", happiness = 0)
    self[myself] = Hash.new
    entities.each do |e|
      self[myself][e] = happiness
      self[e][myself] = happiness
    end
  end

  def entities
    self.keys.sort
  end
end

$happiness = Happiness.new

File.open("./data.txt").each do |line|
  caps = line.match(/^(\w+) would (lose|gain) (\d+) happiness units by sitting next to (\w+).$/).captures
  ent1 = caps[0]
  ent2 = caps[3]
  happiness = caps[2].to_i
  if caps[1] == "lose"
    happiness = -happiness
  end
  $happiness.add(ent1, ent2, happiness)
end

$max_happiness = 0
$max_happiness_configuration = nil

$happiness.add_myself

$happiness.entities.permutation.to_a.each do |configuration|
  temp_configuration = configuration.clone << configuration[0]
  happiness = temp_configuration.each_cons(2).map { |ent1, ent2|
    h1 = $happiness[ent1][ent2]
    h2 = $happiness[ent2][ent1]
    h1 + h2
  }.reduce(&:+)
  if happiness > $max_happiness
    $max_happiness = happiness
    $max_happiness_configuration = configuration
  end
end

p $max_happiness_configuration
puts $max_happiness