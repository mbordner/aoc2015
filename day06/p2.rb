=begin

=end

class Point
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_s
    "(#{@x},#{@y})"
  end
end

class Instruction
  LINE_MATCHER = /^(turn on|turn off|toggle)\s+(-?\d+),(-?\d+)\s+through\s+(-?\d+),(-?\d+)$/
  attr_reader :min, :max, :command

  def initialize(line)
    caps = line.match(Instruction::LINE_MATCHER).captures
    @command = caps[0]
    @min = Point.new(caps[1].to_i, caps[2].to_i)
    @max = Point.new(caps[3].to_i, caps[4].to_i)
  end

  def to_s
    "#{@command} #{@min} #{@max}"
  end
end

class Square
  attr_reader :min, :max
  attr_accessor :brightness

  def initialize(min, max)
    @brightness = 0
    @min = min
    @max = max
  end

  def to_s
    "[#{@on} #{@min},#{@max}]"
  end

  def points_count
    (@max.y - @min.y + 1) * (@max.x - @min.x + 1)
  end
end

class Grid

  def initialize(xs, ys)
    @grid = []
    @x_map = {}
    @y_map = {}

    xs = segment_array(xs)
    ys = segment_array(ys)

    xs.each_with_index do |xpair, i|
      @grid[i] = Array.new
      @x_map[xpair[0]] = i
      ys.each_with_index do |ypair, j|
        @y_map[ypair[0]] = j
        @grid[i][j] = Square.new(Point.new(xpair[0], ypair[0]), Point.new(xpair[1], ypair[1]))
      end
    end

  end

  def segment_array(a)
    a = a.clone
    a << a.last + 1
    a.each_cons(2).map { |pair|
      min = pair[0]
      max = pair[1]
      results = [[min, min]]
      if min + 1 <= max - 1
        results << [min + 1, max - 1]
      end
      results
    }.flatten(1)
  end

  def brightness
    sum = 0
    @grid.each do |ys|
      ys.each do |square|
        sum += square.points_count * square.brightness
      end
    end
    return sum
  end

  def process_instruction(instruction)
    xstart = @x_map[instruction.min.x]
    ystart = @y_map[instruction.min.y]

    i = xstart
    j = ystart
    while i < @grid.length && instruction.max.x >= @grid[i][j].max.x
      while j < @grid[i].length && instruction.max.y >= @grid[i][j].max.y
        case instruction.command
        when "turn on"
          @grid[i][j].brightness += 1
        when "turn off"
          if @grid[i][j].brightness > 0
            @grid[i][j].brightness -= 1
          end
        when "toggle"
          @grid[i][j].brightness += 2
        end
        j += 1
      end
      i += 1
      j = ystart
    end
  end

end

$instructions = []
$xs = []
$ys = []

File.open("./data.txt").each do |line|
  if line.match(Instruction::LINE_MATCHER)
    i = Instruction.new(line)
    $instructions << i
    $xs << i.min.x << i.max.x
    $ys << i.min.y << i.max.y
  end
end

$xs = $xs.uniq.sort
$ys = $ys.uniq.sort

$grid = Grid.new($xs, $ys)

$instructions.each do |instruction|
  $grid.process_instruction(instruction)
end

puts $grid.brightness
