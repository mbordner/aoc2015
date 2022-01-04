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

=begin

As you're about to send the thank you note, something in the MFCSAM's instructions catches your eye.
Apparently, it has an outdated retroencabulator, and so the output from the machine isn't exact
values - some of them indicate ranges.

In particular, the cats and trees readings indicates that there are greater than that many
(due to the unpredictable nuclear decay of cat dander and tree pollen), while the pomeranians and
goldfish readings indicate that there are fewer than that many (due to the modial interaction of magnetoreluctance).

=end

class Sues < Hash
  def add(s)
    self[s.id] = s
  end

  def search(m)
    sues = []
    m.each do |attr_name, attr_val|
      a_sues = []
      self.each do |sue_id, sue|
        attr_count = sue.send(attr_name)
        case attr_name
        when "cats", "trees"
          if attr_count == nil || attr_count > attr_val
            a_sues << sue
          end
        when "pomeranians", "goldfish"
          if attr_count == nil || attr_count < attr_val
            a_sues << sue
          end
        else
          if attr_count == nil || attr_count == attr_val
            a_sues << sue
          end
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

if $intersection.length == 1
  puts $intersection[0].id
else
  puts "unsure"
end
