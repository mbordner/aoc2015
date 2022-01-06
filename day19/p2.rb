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
          ([splits] * splits.length).each_with_index.map { |a, i| a.rotate(i) }.each do |splits_p|
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
$deconstructs = Replacements.new
$molecule = nil

File.open("./data.txt").each do |line|
  line = line.strip
  if line.length > 0
    if line.match(/^(\w+)\s+=>\s+(\w+)$/)
      caps = line.match(/^(\w+)\s+=>\s+(\w+)$/).captures
      $replacements.add(caps[0], caps[1])
      $deconstructs.add(caps[1], caps[0])
    else
      $molecule = line
    end
  end
end

molecules = $replacements.molecules?($molecule)
p molecules.length

def deconstruct_molecule_to(replacements, molecule, electron)
  steps = []
  failed = {}

  deconstruct_rec = -> (cur_molecule, steps) {
    if cur_molecule == electron
      return (steps.dup << cur_molecule).reverse
    else
      next_steps = steps.dup << cur_molecule
      replacements.molecules?(cur_molecule).each do |nm|
        if failed.has_key?(nm) == false
          result = deconstruct_rec.call(nm, next_steps)
          if result != nil
            return result
          else
            failed[nm] = true
          end
        end
      end
      return nil
    end
  }

  deconstruct_rec.call(molecule, steps)
end

steps = deconstruct_molecule_to($deconstructs, $molecule, "e")
p steps
puts steps.length