# %w[<pasted_input>].map(&:to_i).each_cons(3).map { |a| a.reduce(&:+) }.each_cons(2).count { |a, b| b > a }
data = File.read("./data.txt")

puts data.count("(") - data.count(")")
