class Sue
  attr_accessor :id, :children, :cats, :samoyeds, :pomeranians, :akitas, :vizslas, :goldfish, :trees, :cars, :perfumes

  def initialize(text)
    caps = text.match(/^Sue (\d+)/).captures
    @id = caps[0].to_i

    @children = nil
    @cats = nil
    @samoyeds = nil
    @pomeranians = nil
    @akitas = nil
    @vizslas = nil
    @goldfish = nil
    @trees = nil
    @cars = nil
    @perfumes = nil

    text.scan(/(children|cats|samoyeds|pomeranians|akitas|vizslas|goldfish|trees|cars|perfumes):\s+(\d+)/).each do |m|
      self.send(m[0] + "=", m[1].to_i)
    end
  end
end

class Sues < Hash
  def add(s)
    self[s.id] = s
  end

  def search(m)
    sues = []
    m.each do |a, v|
      a_sues = []
      self.each do |i, s|
        c = s.send(a)
        if c != nil && c >= v
          a_sues << s
        end
      end
      if a_sues.length > 0
        sues << a_sues
      end
    end
    sues
  end

end

$sues = Sues.new

File.open("./data.txt").each do |line|
  $sues.add(Sue.new(line))
end

$m = { "children" => 3, "cats" => 7, "samoyeds" => 2, "pomeranians" => 3, "akitas" => 0, "vizslas" => 0, "goldfish" => 5, "trees" => 3, "cars" => 2, "perfumes" => 1 }

$results = $sues.search($m)

$intersection = $results[0]
$results.each do |a|
  $intersection = $intersection.intersection(a)
end

p $intersection