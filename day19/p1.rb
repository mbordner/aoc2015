class Replacements < Hash
  def add(sequence, replacement)
    if self.has_key?(sequence)
      self[sequence].push(replacement)
    else
      self[sequence] = [replacement]
    end
  end

  def molecules?(molecule)
    molecules = {}
    self.each do |sequence, replacements|
      tokens = molecule.split(Regexp.new(sequence), -1)
      if tokens.length > 1
        replacements.each do |replacement|
          splits = ([sequence] * (tokens.length - 2)) << replacement
          splits.permutation.each do |splits_p|
            s = tokens.zip(splits_p).flatten.join
            if molecules.has_key?(s)
              molecules[s] += 1
            else
              molecules[s] = 1
            end
          end
        end
      end
    end
    return molecules.keys.sort
  end
end

$replacements = Replacements.new
$molecule = nil

File.open("./test.txt").each do |line|
  line = line.strip
  if line.length > 0
    if line.match(/^(\w+)\s+=>\s+(\w+)$/)
      caps = line.match(/^(\w+)\s+=>\s+(\w+)$/).captures
      $replacements.add(caps[0], caps[1])
    else
      $molecule = line
    end
  end
end

molecules = $replacements.molecules?($molecule)

p molecules