
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

def getVolume(box)
  box.to_a.reduce(&:*)
end

def getPerimeter(box)
  box.to_a.sort.take(2).reduce(&:+) * 2
end

def getRibbonRequirements(box)
  getVolume(box) + getPerimeter(box)
end

#tb = Box.new(2,3,4)
#puts getPaperRequirements(tb)
#puts getVolume(tb)
#puts getPerimeter(tb)


requirements = 0

getData("./data.txt").each do |box|
  requirements += getRibbonRequirements(box)
end

# too high 2049639
puts requirements
