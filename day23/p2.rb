class Turing

  def initialize
    reset
  end

  def reset
    @registers = [1, 0]
  end

  def a
    @registers[0]
  end

  def b
    @registers[1]
  end

  def run(program)
    ptr = 0
    while ptr >= 0 && ptr < program.length
      instr, val1, val2 = parse_instruction(program[ptr])

      case instr
      when "hlf"
        @registers[val1] /= 2
      when "tpl"
        @registers[val1] *= 3
      when "inc"
        @registers[val1] += 1
      when "jmp"
        ptr += val1
        next
      when "jie"
        if @registers[val1] % 2 == 0
          ptr += val2
          next
        end
      when "jio"
        if @registers[val1] == 1
          ptr += val2
          next
        end
      end

      ptr += 1
    end

    def to_s
      "#{a},#{b}"
    end
  end

  def parse_instruction(instruction)
    caps = instruction.match(/^(hlf|tpl|inc|jmp|jie|jio)\s((?:a|b)|(?:(?:-|\+)\d+))(?:,\s((?:-|\+)\d+))?$/).captures

    instr = caps[0]
    val1 = -1
    val2 = -1

    if caps[1].match(/(a|b)/)
      case caps[1]
      when "a"
        val1 = 0
      when "b"
        val1 = 1
      end
    else
      val1 = caps[1].to_i
    end

    if caps.length == 3
      val2 = caps[2].to_i
    end

    return [instr, val1, val2]
  end
end

=begin
program = %(inc a
jio a, +2
tpl a
inc a).lines.to_a

comp = Turing.new
comp.run(program)

puts comp
=end

program = File.read("./data.txt").lines(chomp: true).to_a

comp = Turing.new
comp.run(program)

puts comp