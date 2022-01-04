=begin

--- Day 17: No Such Thing as Too Much ---
The elves bought too much eggnog again - 150 liters this time. To fit it all into your refrigerator, you'll need to move it into smaller containers. You take an inventory of the capacities of the available containers.

For example, suppose you have containers of size 20, 15, 10, 5, and 5 liters. If you need to store 25 liters, there are four ways to do it:

15 and 10
20 and 5 (the first 5)
20 and 5 (the second 5)
15, 5, and 5
Filling all containers entirely, how many different combinations of containers can exactly fit all 150 liters of eggnog?

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

p outputs
puts outputs.length

puts outputs.uniq.length




