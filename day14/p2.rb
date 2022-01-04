=begin

Seeing how reindeer move in bursts, Santa decides he's not pleased with the old scoring system.

Instead, at the end of each second, he awards one point to the reindeer currently in the lead. (If there are multiple
reindeer tied for the lead, they each get one point.) He keeps the traditional 2503 second time limit, of course,
as doing otherwise would be entirely ridiculous.

Given the example reindeer from above, after the first second, Dancer is in the lead and gets one point. He stays
in the lead until several seconds into Comet's second burst: after the 140th second, Comet pulls into the lead and
gets his first point. Of course, since Dancer had been in the lead for the 139 seconds before that, he has
accumulated 139 points by the 140th second.

After the 1000th second, Dancer has accumulated 689 points, while poor Comet, our old champion, only has 312. So,
with the new scoring system, Dancer would win (if the race ended at 1000 seconds).

Again given the descriptions of each reindeer (in your puzzle input), after exactly 2503 seconds,
how many points does the winning reindeer have?

=end

class Reindeer
  attr_reader :name, :speed, :duration, :rest_duration

  def initialize(name, speed, duration, rest_duration)
    @name = name
    @speed = speed
    @duration = duration
    @rest_duration = rest_duration
  end

  def travel_stats
    [@speed, @duration, @rest_duration]
  end
end

class RaceStats < Hash
  attr_reader :distances, :scores, :timer_resting, :timer_running

  def initialize()
    @distances = {}
    @scores = {}
    @timer_resting = {}
    @timer_running = {}
    @deer = {}
  end

  def track(deer)
    name = deer.name
    @deer[name] = deer
    @timer_running[name] = deer.duration
    @timer_resting[name] = 0
    @distances[name] = 0
    @scores[name] = 0
  end

  def tick(secs = 1)
    secs.times do
      leader_distance = 0

      @deer.keys.each do |name|
        if @timer_running[name] > 0
          @distances[name] += @deer[name].speed
          @timer_running[name] -= 1
          if @timer_running[name] == 0
            @timer_resting[name] = @deer[name].rest_duration
          end
        else
          @timer_resting[name] -= 1
          if @timer_resting[name] == 0
            @timer_running[name] = @deer[name].duration
          end
        end

        if @distances[name] > leader_distance
          leader_distance = @distances[name]
        end
      end

      @distances.each do |n, v|
        if v == leader_distance
          @scores[n] += 1
        end
      end
    end
  end

  def winner
    score = 0
    name = nil
    @scores.each do |n, v|
      if @scores[n] > score
        score = @scores[n]
        name = n
      end
    end
    return name
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

  def size
    self.keys.length
  end

  def reindeer(name)
    self[name]
  end

  def race(secs)
    stats = RaceStats.new

    names.each do |name|
      deer = reindeer(name)
      stats.track(deer)
    end

    secs.times do
      stats.tick
    end

    name = stats.winner
    [name, stats.scores[name], stats.distances[name]]
  end
end

$herd = Herd.new

File.open("./data.txt").each do |line|
  caps = line.match(/^(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds.$/).captures
  $herd.add(caps[0], caps[1].to_i, caps[2].to_i, caps[3].to_i)
end

leader, score, distance = $herd.race(2503)

puts leader, score, distance