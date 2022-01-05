class Grid
  attr_reader :max_x, :max_y

  def initialize
    @grid = []
    @max_x = -1
    @max_y = -1
  end

  def initialize_dup(o_grid)
    super
    @grid = []
    for y in 0..max_y do
      @grid[y] = o_grid[y].dup
    end
  end

  def add(line)
    @max_y += 1
    @grid << line
    l = line.length - 1
    if l > @max_x
      @max_x = l
    end
  end

  def surrounding?(x, y)
    points = []
    if y > 0
      if x > 0
        points << @grid[y - 1][x - 1]
      end
      points << @grid[y - 1][x]
      if x < @max_x
        points << @grid[y - 1][x + 1]
      end
    end
    if x > 0
      points << @grid[y][x - 1]
    end
    if x < @max_x
      points << @grid[y][x + 1]
    end
    if y < @max_y
      if x > 0
        points << @grid[y + 1][x - 1]
      end
      points << @grid[y + 1][x]
      if x < @max_x
        points << @grid[y + 1][x + 1]
      end
    end
    return points
  end

  def [](y)
    @grid[y]
  end

  def on?
    count = 0
    @grid.each do |row|
      row.chars.each do |c|
        if c == '#'
          count += 1
        end
      end
    end
    return count
  end

  def step
    ngrid = self.dup
    @grid.each_with_index do |row, y|
      row.chars.each_with_index do |c, x|
        neighbor_on_count = surrounding?(x, y).map { |l| l == '#' ? 1 : 0 }.reduce(&:+)
        nc = '.'
        if c == '#'
          if neighbor_on_count == 2 || neighbor_on_count == 3
            nc = '#'
          end
        else
          if neighbor_on_count == 3
            nc = '#'
          end
        end
        ngrid[y][x] = nc
      end
    end
    ngrid.turn_on_corners
    return ngrid
  end

  def turn_on_corners
    @grid[0][0] = '#'
    @grid[0][@max_x] = '#'
    @grid[@max_y][0] = '#'
    @grid[@max_y][@max_x] = '#'
  end

  def print
    @grid.each do |row|
      puts row
    end
  end

end

$grid = Grid.new

File.open("./data.txt").each do |line|
  $grid.add(line.strip)
end

$grid.turn_on_corners
$grid.print

$ngrid = $grid.dup
100.times do
  puts "-----"
  $ngrid = $ngrid.step
  $ngrid.print
end

puts $ngrid.on?
