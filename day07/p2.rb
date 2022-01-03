=begin
123 -> x
456 -> y
x AND y -> d
x OR y -> e
x LSHIFT 2 -> f
y RSHIFT 2 -> g
NOT x -> h
NOT y -> i
After it is run, these are the signals on the wires:

d: 72
e: 507
f: 492
g: 114
h: 65412
i: 65079
x: 123
y: 456
=end

class SignalValue
  FeedsLine = /^(\d+|\w+)\s+\->\s+(\w+)$/
  NotGateLine = /^NOT\s+(\w+|\d+)\s+\->\s+(\w+)$/
  MultiGateLine = /^(\w+|\d+)\s+(LSHIFT|RSHIFT|AND|OR)\s+(\w+|\d+)\s+\->\s+(\w+)$/

  def SignalValue.not(value)
    value ^ ((1 << 16) - 1)
  end

  def initialize(sources = nil)
    if sources.is_a?(Integer)
      @sources = [sources]
    else
      @sources = sources
    end
    if @sources == nil
      @sources = Array.new
    end
  end

  def add_source(source)
    @sources.unshift(source)
  end

  def eval
    if @sources.length > 0
      if @sources[0].is_a?(Integer)
        return @sources[0]
      else
        return @sources[0].eval()
      end
    end
    return nil
  end

  def to_s
    "#{@sources[0]}"
  end

end

class Wire < SignalValue
  attr_reader :identifier

  def initialize(identifier, sources = nil)
    super(sources)
    @identifier = identifier
  end

  def to_s
    "#{@identifier}"
  end
end

class MultiGate < SignalValue
  attr_reader :type

  def initialize(type, sources = nil)
    super(sources)
    @type = type
    @value = nil
  end

  def eval
    if @value != nil
      return @value
    end
    lv = @sources[0]
    rv = @sources[1]

    case @type
    when "AND"
      @value = lv.eval() & rv.eval()
    when "OR"
      @value = lv.eval() | rv.eval()
    when "LSHIFT"
      @value = lv.eval() << rv.eval()
    when "RSHIFT"
      @value = lv.eval() >> rv.eval()
    end

    @value
  end

  def to_s
    "#{@sources[0]} #{@type} #{@sources[1]}"
  end
end

class NotGate < SignalValue
  def eval
    SignalValue::not(@sources[0].eval())
  end
end

class Wires
  def initialize
    @wires = {}
  end

  def get_wire(identifier)
    if @wires.has_key?(identifier)
      return @wires[identifier]
    end
    wire = Wire.new(identifier)
    @wires[identifier] = wire
  end

  def get_values()
    values = {}
    @wires.each_key { |k| values[k] = @wires[k].eval() }
    values
  end

  def print_values()
    values = get_values()
    values.keys.sort.each do |k|
      puts "#{k}: #{values[k]}"
    end
  end
end

$wires = Wires.new

File.open("./data.txt").each do |line|
  if line.match(SignalValue::FeedsLine)
    caps = line.match(SignalValue::FeedsLine).captures
    wire = $wires.get_wire(caps[1])

    if caps[0].match(/\d+/)
      wire.add_source(SignalValue.new(caps[0].to_i))
    else
      wire.add_source($wires.get_wire(caps[0]))
    end

  elsif line.match(SignalValue::NotGateLine)
    caps = line.match(SignalValue::NotGateLine).captures
    wire = $wires.get_wire(caps[1])

    if caps[0].match(/\d+/)
      source = SignalValue.new(caps[0].to_i)
    else
      source = $wires.get_wire(caps[0])
    end

    wire.add_source(NotGate.new([source]))

  elsif line.match(SignalValue::MultiGateLine)
    caps = line.match(SignalValue::MultiGateLine).captures
    wire = $wires.get_wire(caps[3])

    sources = [caps[0], caps[2]].map do |s|
      if s.match(/\d+/)
        source = SignalValue.new(s.to_i)
      else
        source = $wires.get_wire(s)
      end
      source
    end

    wire.add_source(MultiGate.new(caps[1], sources))

  else
    puts "didn't match: #{line}"
  end
end


=begin
Now, take the signal you got on wire a, override wire b to that signal, and reset the other wires (including wire a).
What new signal is ultimately provided to wire a?
=end

$wires.get_wire("b").add_source(SignalValue.new(956))

puts $wires.get_wire("a").eval()