=begin

--- Part Two ---
While playing with all the containers in the kitchen, another load of eggnog arrives!
The shipping and receiving department is requesting as many containers as you can spare.

Find the minimum number of containers that can exactly fit all 150 liters of eggnog.
How many different ways can you fill that number of containers and still hold exactly 150 litres?

In the example above, the minimum number of containers was two. There were three ways to
use that many containers, and so the answer there would be 3.

=end

LITRES = 150

$digits = []
File.open("./data.txt").each do |line|
  $digits << line.to_i
end

def combos_rec(desired_sum, cur_sum, cur_group, still_avail, outputs)

  if cur_sum == desired_sum
    outputs << cur_group.sort
    return
  end

  still_avail.each_with_index do |candidate, index|
    if cur_sum + candidate <= desired_sum
      temp_sum = cur_sum + candidate
      temp_cur_group = cur_group.dup
      temp_cur_group << candidate
      temp_still_avail = still_avail.dup[index + 1..]
      combos_rec(desired_sum, temp_sum, temp_cur_group, temp_still_avail, outputs)
    else
      return
    end
  end

end

def combos(goal, containers)
  outputs = []
  cur_sum = 0
  cur_group = []
  still_avail = containers.dup.sort

  combos_rec(goal, cur_sum, cur_group, still_avail, outputs)
  return outputs
end

outputs = combos(LITRES, $digits)

min_size = Float::INFINITY
min_containers = nil

outputs.each do |containers|
  if containers.length < min_size
    min_size = containers.length
    min_containers = containers
  end
end

count = 0
outputs.each do |containers|
  if containers.length == min_size
    count += 1
  end
end



p min_containers
puts min_size
puts count




