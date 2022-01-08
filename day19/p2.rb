class Replacements < Hash
  def add(sequence, replacement)
    if self.has_key?(sequence)
      if replacement.match(Regexp.new(sequence))
        self[sequence].append(replacement)
      else
        self[sequence].prepend(replacement)
      end
    else
      self[sequence] = [replacement]
    end
  end

  def molecules?(molecule)
    molecules = {}
    could_replace = []
    self.each do |sequence, replacements|
      tokens = molecule.split(Regexp.new(sequence), -1)
      if tokens.length > 1
        could_replace.push(sequence)
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
    if block_given?
      irreplaceable = molecule.split(Regexp.new(could_replace.join('|')), -1).select { |x| x != nil && x.length > 0 }
      yield irreplaceable
    end
    return molecules.keys.sort
  end
end

$replacements = Replacements.new
$molecule = nil

File.open("./data.txt").each do |line|
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
p molecules.length

no_productions = []

$replacements.each do |sequence, replacements|
  replacements.each do |replacement|
    $replacements.molecules?(replacement) { |irreplaceable|
      no_productions = no_productions.union(irreplaceable)
    }
  end
end

$priority_destructs = Replacements.new
$secondary_destructs = Replacements.new

no_productions = no_productions.map { |a| Regexp.new(a) }

$replacements.each do |sequence, replacements|
  replacements.each do |replacement|
    is_priority = false
    no_productions.each do |nopr|
      if replacement.match(nopr)
        is_priority = true
        break
      end
    end
    if is_priority
      $priority_destructs.add(replacement, sequence)
    else
      $secondary_destructs.add(replacement, sequence)
    end
  end
end

def deconstruct_molecule_to(molecule, electron)
  steps = []
  checked = {}

  deconstruct_rec = -> (cur_molecule, steps) {
    if cur_molecule == electron
      return (steps.dup << cur_molecule).reverse
    else
      next_steps = steps.dup << cur_molecule
      candidates = $priority_destructs.molecules?(cur_molecule).to_a
      candidates.concat($secondary_destructs.molecules?(cur_molecule).to_a)
      candidates.each do |nm|
        if checked.has_key?(nm) == false
          checked[nm] = 1
          result = deconstruct_rec.call(nm, next_steps)
          if result != nil
            return result
          end
        else
          checked[nm] += 1
        end
      end
      return nil
    end
  }

  deconstruct_rec.call(molecule, steps)
end

steps = deconstruct_molecule_to($molecule, "e")

p steps
puts steps.length - 1