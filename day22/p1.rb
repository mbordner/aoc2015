class AffectStats
  attr_accessor :armor, :damage, :hit_points, :mana_points

  def initialize(named_params = {})
    @armor = 0
    @damage = 0
    @hit_points = 0
    @mana_points = 0
    named_params.each do |k, v|
      case k
      when :armor
        @armor = v
      when :damage
        @damage = v
      when :hit_points
        @hit_points = v
      when :mana_points
        @mana_points = v
      end
    end
  end

end

class ItemAffectStats < AffectStats
end

class SpellAffectStats < AffectStats
end

class Player
  attr_reader :name, :hit_points, :mana_points

  def initialize(name, hp, mp)
    @name = name
    @hit_points = hp
    @mana_points = mp
    @items = []
    @effects = []
  end

  def add_item(item)
    @items.push(item)
  end

  def add_effect(effect)
    @effects.push(effect)
  end

  def tick()
    remaining_effects = []
    @effects.each do |e|
      time_remaining = e.tick()
      if time_remaining > 0
        remaining_effects.push(e)
      end
      if e.damage != 0
        self.hit(e)
      end
      self.affect_stats(e)
    end
    @effects = remaining_effects
  end

  def affect_stats(affect_stats)
    @hit_points += affect_stats.hit_points
    @mana_points += affect_stats.mana_points
  end

  def hit(affect_stats)
    armor = affect_stats.is_a?(ItemAffectStats) ? self.items_armor + self.effects_armor : self.effects_armor
    dmg = affect_stats.damage - armor
    if dmg < 1
      dmg = 1
    end
    @hit_points -= dmg
  end

  def effects_armor
    armor = 0
    @effects.each do |e|
      if e.armor > 0
        armor += e.armor
      end
    end
    return armor
  end

  def items_armor
    armor = 0
    @items.each do |i|
      if i.armor > 0
        armor += i.armor
      end
    end
    return armor
  end

  def items_damage
    damage = 0
    @items.each do |i|
      if i.damage > 0
        damage += i.damage
      end
    end
    return damage
  end

  def attack(player)
    stats = ItemAffectStats.new(damage: items_damage)
    if stats.damage > 0
      player.hit(stats)
    end
  end

  def to_s
    "Player:#{@name},hp:#{@hit_points},mp:#{@mana_points},armor:#{self.items_armor + self.effects_armor}"
  end
end

class Boss < Player

end

class Item < AffectStats
  attr_reader :name, :cost

  def initialize(name, cost, stats)
    super(damage: stats.damage, armor: stats.armor, hit_points: stats.hit_points, mana_points: stats.mana_points)
    @name = name
    @cost = cost
  end

  def to_s
    "Item:#{@name},cost:#{@cost}"
  end
end

class Effect < AffectStats
  attr_reader :name, :time_remaining

  def initialize(name, time_remaining, stats)
    super(damage: stats.damage, armor: stats.armor, hit_points: stats.hit_points, mana_points: stats.mana_points)
    @name = name
    @time_remaining = time_remaining
  end

  def tick()
    @time_remaining -= 1
    return @time_remaining
  end

  def to_s
    "Effect:#{@name}"
  end
end

class Spell
  attr_reader :name, :mana_points

  def initialize(name, mana_points, cast_lambda = nil)
    @name = name
    @mana_points = mana_points
    @cast_lambda = cast_lambda
  end

  def cast(caster, target)
    if caster.mana_points >= @mana_points
      caster.affect_stats(SpellAffectStats.new(mana_points: -(@mana_points)))
      @cast_lambda.call(caster, target)
    end
  end

  def to_s
    "Spell:#{@name}"
  end
end

$spells = [
  Spell.new("Magic Missile", 53, -> (caster, target) {
    target.hit(SpellAffectStats.new(damage: 4))
  }),
  Spell.new("Drain", 73, -> (caster, target) {
    target.hit(SpellAffectStats.new(damage: 2))
    caster.affect_stats(SpellAffectStats.new(hit_points: 2))
  }),
  Spell.new("Shield", 113, -> (caster, target) {
    caster.add_effect(Effect.new("Shield", 6, SpellAffectStats.new(armor: 7)))
  }),
  Spell.new("Poison", 173, -> (caster, target) {
    target.add_effect(Effect.new("Poison", 6, SpellAffectStats.new(damage: 3)))
  }),
  Spell.new("Recharge", 229, -> (caster, target) {
    caster.add_effect(Effect.new("Recharge", 5, SpellAffectStats.new(mana_points: 101)))
  })
]

def create_boss
  b = Boss.new("Boss", 71, 0)
  b.add_item(Item.new("Boss Sword", 0, ItemAffectStats.new(damage: 10)))
  return b
end

def create_player
  p = Player.new("Player", 50, 500)
  return p
end

class GameState
  attr_reader :player, :boss

  def initialize
    super
    @player = create_player
    @boss = create_boss
  end

  def tick_all_players
    @player.tick()
    @boss.tick()
  end

  def is_end_state
    if @player.hit_points <= 0
      return @boss
    elsif @boss.hit_points <= 0
      return @player
    end
    return nil
  end

  def turn_with_player_spell(spell)
    tick_all_players
    winner = is_end_state
    if winner != nil
      return winner
    end

    spell.cast(@player, @boss)
    winner = is_end_state
    if winner != nil
      return winner
    end

    tick_all_players
    winner = is_end_state
    if winner != nil
      return winner
    end

    @boss.attack(@player)
    winner = is_end_state
    return winner
  end

  def clone
    Marshal.load(Marshal.dump(self))
  end

  def spell_options
    spells = []
    avail_mana = @player.mana_points
    $spells.each do |s|
      if s.mana_points < avail_mana
        spells.push(s)
      end
    end
    return spells
  end
end

def get_cheapest_spell_options
  initial_state = GameState.new
  initial_spell_options = initial_state.spell_options
  losing_paths = []
  winning_paths = []

  get_cheapest_spell_options_rec = lambda { |spell, state|
    winner = state.turn_with_player_spell(spell)
    if winner != nil
      if winner.is_a?(Boss)
        return [nil, [[spell]]]
      else
        return [[[spell]], nil]
      end
    end

    next_losing_paths = []
    next_winning_paths = []
    next_spell_options = state.spell_options

    next_spell_options.each do |ns|
      nwp, nlp = get_cheapest_spell_options_rec.call(ns, state.clone)
      if nwp != nil
        nwp.each do |ps|
          ps.prepend(spell)
        end
        next_winning_paths.concat(nwp)
      end
      if nlp != nil
        nlp.each do |ps|
          ps.prepend(spell)
        end
        next_losing_paths.concat(nlp)
      end
    end

    return [
      next_winning_paths.length > 0 ? next_winning_paths : nil,
      next_losing_paths.length > 0 ? next_losing_paths : nil
    ]
  }

  initial_spell_options.each do |s|
    nwp, nlp = get_cheapest_spell_options_rec.call(s, initial_state.clone)
    if nwp != nil
      winning_paths.concat(nwp)
    end
    if nlp != nil
      losing_paths.concat(nlp)
    end
  end

  winning_path_cost = Float::INFINITY
  winning_path = nil

  winning_paths.each do |wp|
    mana = wp.map { |s| s.mana_points }.reduce(&:+)
    if mana < winning_path_cost
      winning_path_cost = mana
      winning_path = wp
    end
  end

  return [winning_path, winning_path_cost]
end

wp, mana = get_cheapest_spell_options

p mana

p wp



