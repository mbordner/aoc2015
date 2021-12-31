
Box = Struct.new(:w,:h,:l)

def getData(filename)
  boxes = []
  File.open(filename).each do |line|
    line.match(/(\d+)x(\d+)x(\d+)/) { |m|
      boxes.append(Box.new(*m.captures.map(&:to_i)))
    }
  end
  boxes
end

def getSurfaceArea(box)
  2 * getAreas(box).reduce(&:+)
end

def getAreas(box)
  [ box[:w] * box[:h], box[:w] * box[:l], box[:h] * box[:l]]
end

def getSmallestArea(box)
  getAreas(box).min()
end

def getPaperRequirements(box)
  getSurfaceArea(box) + getSmallestArea(box)
end

puts getPaperRequirements(Box.new(2,3,4))


requirements = 0

getData("./data.txt").each do |box|
  requirements += getPaperRequirements(box)
end

# too high 2049639
puts requirements