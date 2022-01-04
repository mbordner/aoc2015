require "./spreader"

class IngredientCharacteristics
  attr_accessor :capacity, :durability, :flavor, :texture, :calories

  def initialize
    @capacity = 0
    @durability = 0
    @flavor = 0
    @texture = 0
    @calories = 0
  end

  def score
    [@capacity, @durability, @flavor, @texture].map { |i|
      value = 0
      if i > 0
        value = i
      end
      value
    }.reduce(&:*)
  end
end

class Ingredient < IngredientCharacteristics
  attr_reader :name

  def initialize(text)
    caps = text.match(/^(\w+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)$/).captures
    @name = caps[0]
    @capacity = caps[1].to_i
    @durability = caps[2].to_i
    @flavor = caps[3].to_i
    @texture = caps[4].to_i
    @calories = caps[5].to_i
  end

  def to_s
    @name
  end

end

class Ingredients < Hash
  def add(text)
    i = Ingredient.new(text)
    self[i.name] = i
  end

  def names
    self.keys.sort
  end

  def size
    self.keys.length
  end

  def get(name)
    self[name]
  end

  def ingredients
    i = []
    names.each do |n|
      i << get(n)
    end
    return i
  end

  def bake(arr)
    characteristics = IngredientCharacteristics.new
    ingrs = ingredients
    arr.each_with_index do |amount, index|
      characteristics.capacity += amount * ingrs[index].capacity
      characteristics.durability += amount * ingrs[index].durability
      characteristics.flavor += amount * ingrs[index].flavor
      characteristics.texture += amount * ingrs[index].texture
      characteristics.calories += amount * ingrs[index].calories
    end
    return characteristics
  end
end

$ingredients = Ingredients.new

File.open("./data.txt").each do |line|
  $ingredients.add(line)
end

spreads = Spreader.new($ingredients.size).spread(100)

$max_score = 0
$winning_configuration = nil
$winning_characteristics = nil

spreads.each do |spread|
  spread.permutation.uniq.each do |configuration|
    characteristics = $ingredients.bake(configuration)
    score = characteristics.score
    if score > $max_score
      $max_score = score
      $winning_configuration = configuration
      $winning_characteristics = characteristics
    end
  end
end

p $max_score
puts $ingredients.ingredients
p $winning_configuration