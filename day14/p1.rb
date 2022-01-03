=begin

This year is the Reindeer Olympics! Reindeer can fly at high speeds, but must rest occasionally to recover
their energy. Santa would like to know which of his reindeer is fastest, and so he has them race.

Reindeer can only either be flying (always at their top speed) or resting (not moving at all), and always
spend whole seconds in either state.

For example, suppose you have the following Reindeer:

Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
After one second, Comet has gone 14 km, while Dancer has gone 16 km. After ten seconds, Comet has gone 140 km,
while Dancer has gone 160 km. On the eleventh second, Comet begins resting (staying at 140 km), and Dancer continues
on for a total distance of 176 km. On the 12th second, both reindeer are resting. They continue to rest until the
138th second, when Comet flies for another ten seconds. On the 174th second, Dancer flies for another 11 seconds.

In this example, after the 1000th second, both reindeer are resting, and Comet is in the lead at 1120 km (poor Dancer
has only gotten 1056 km by that point). So, in this situation, Comet would win (if the race ended at 1000 seconds).

Given the descriptions of each reindeer (in your puzzle input), after exactly 2503 seconds, what distance has the
winning reindeer traveled?

=end

class Reindeer
  def initialize(name, speed, duration, rest_duration)
    @name = name
    @speed = speed
    @duration = duration
    @rest_duration = rest_duration
  end

  def travel_stats
    [@speed, @duration, @duration + @rest_duration]
  end
end

class Herd < Hash
  def add(name, speed, duration, rest_duration)
    reindeer = Reindeer.new(name, speed, duration, rest_duration)
    self[name] = reindeer
  end

  def names
    self.keys.sort
  end

  def reindeer(name)
    self[name]
  end

  def race(secs)
    leader_name = nil
    leader_distance = 0

    names.each do |name|
      deer = reindeer(name)
      speed, sprint_duration, sprint_rest_duration = deer.travel_stats
      distance = secs / sprint_rest_duration * speed * sprint_duration
      secs_remaining = secs % sprint_rest_duration

      if secs_remaining < sprint_duration
        distance += secs_remaining * speed
      else
        distance += sprint_duration * speed
      end

      if distance > leader_distance
        leader_distance = distance
        leader_name = name
      end
    end

    [leader_name, leader_distance]
  end
end

$herd = Herd.new

File.open("./data.txt").each do |line|
  caps = line.match(/^(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds.$/).captures
  $herd.add(caps[0], caps[1].to_i, caps[2].to_i, caps[3].to_i)
end

leader, distance = $herd.race(2503)

puts leader, distance