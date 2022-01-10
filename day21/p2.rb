class Player
  attr_reader :hit_points, :damage, :armor

  def initialize(hp, damage = 0, armor = 0)
    @damage = damage
    @armor = armor
    @hit_points = hp
    @items = []
  end

  def damage
    if @damage == 0
      if @items.length > 0
        @damage = @items.map { |i| i.damage }.reduce(&:+)
      end
    end
    @damage
  end

  def armor
    if @armor == 0
      if @items.length > 0
        @armor = @items.map { |i| i.armor }.reduce(&:+)
      end
    end
    @armor
  end

  def to_s
    "hp:#{@hit_points},dmg:#{self.damage},arm:#{self.armor}"
  end

  def add_item(item)
    @items.push(item)
  end

  def print
    puts "Player[#{self}]"
    @items.each do |i|
      puts i
    end
  end

  def cost
    @items.map { |i| i.cost }.reduce(&:+)
  end

  def hit(dmg)
    hp = 1
    if dmg > self.armor
      hp = dmg - self.armor
    end
    @hit_points -= hp
  end
end

class Item
  attr_reader :name, :cost, :damage, :armor

  def initialize(name, cost, named_params = { :damage => 0, :armor => 0 })
    @name = name
    @cost = cost
    @damage = named_params[:damage] != nil ? named_params[:damage] : 0
    @armor = named_params[:armor] != nil ? named_params[:armor] : 0
  end

  def to_s
    "Item:#{@name},cost:#{@cost},dmg:#{@damage},arm:#{@armor}"
  end
end

$weapons = [
  Item.new("Weapon:Dagger", 8, damage: 4),
  Item.new("Weapon:Shortsword", 10, damage: 5),
  Item.new("Weapon:Warhammer", 25, damage: 6),
  Item.new("Weapon:Longsword", 40, damage: 7),
  Item.new("Weapon:Greataxe", 74, damage: 8)
]

$armor = [
  Item.new("No Armor", 0),
  Item.new("Armor:Leather", 13, armor: 1),
  Item.new("Armor:Chainmail", 31, armor: 2),
  Item.new("Armor:Splintmail", 53, armor: 3),
  Item.new("Armor:Bandedmail", 75, armor: 4),
  Item.new("Armor:Platemail", 102, armor: 5)
]

$rings = [
  Item.new("No Ring 1", 0),
  Item.new("No Ring 2", 0),
  Item.new("Ring:Damage +1", 25, damage: 1, armor: 0),
  Item.new("Ring:Damage +2", 50, damage: 2, armor: 0),
  Item.new("Ring:Damage +3", 100, damage: 3, armor: 0),
  Item.new("Ring:Defense +1", 20, damage: 0, armor: 1),
  Item.new("Ring:Defense +2", 40, damage: 0, armor: 2),
  Item.new("Ring:Defense +3", 80, damage: 0, armor: 3)
]

def create_boss
  Player.new(109, 8, 2)
end

def create_player(combo)
  p = Player.new(100)
  combo.each do |i|
    p.add_item(i)
  end
  return p
end

combos = []
$rings.combination(2).each do |rs|
  $weapons.product($armor).each do |wa|
    combos.push(wa.concat(rs))
  end
end

min_cost = Float::INFINITY
min_player = nil
min_boss = nil

max_cost = 0
max_player = nil
max_boss = nil

combos.each do |combo|
  boss = create_boss
  player = create_player(combo)

  i = 0
  while boss.hit_points > 0 && player.hit_points > 0
    p1 = player
    p2 = boss
    if i % 2 == 1
      p1, p2 = p2, p1
    end
    p2.hit(p1.damage)
    break if p2.hit_points <= 0
    p1.hit(p2.damage)
    i += 1
  end

  if player.hit_points > 0
    if player.cost < min_cost
      min_cost = player.cost
      min_player = player
      min_boss = boss
    end
  else
    if player.cost > max_cost
      max_cost = player.cost
      max_player = player
      max_boss = boss
    end
  end
end
max_boss.print
puts "--"
max_player.print

puts max_cost
