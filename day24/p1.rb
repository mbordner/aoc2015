# return sets that sum up to total from the values in remaining
def total_groups(total, remaining, cur_group, result_groups)
  cur_group_sum = cur_group.length > 0 ? cur_group.reduce(&:+) : 0
  remaining.each_with_index do |val, ind|
    if val + cur_group_sum == total
      cur_group.push(val)
      cur_group = cur_group.sort_by { |e| e * -1 }
      cur_group_str = cur_group.to_s
      if result_groups.has_key?(cur_group_str) == false
        result_groups[cur_group_str] = cur_group
      end
    elsif val + cur_group_sum < total
      next_group = cur_group.dup
      next_group.push(val)
      next_remaining = remaining.dup[ind + 1..]
      if next_remaining.length > 0 && cur_group_sum + val + next_remaining.reduce(&:+) >= total
        total_groups(total, next_remaining, next_group, result_groups)
      else
        break
      end
    end
  end
end

# read the data
nums = File.read("./data.txt").lines(chomp: true).map(&:to_i).sort.reverse
#nums = [11, 10, 9, 8, 7, 5, 4, 3, 2, 1]

sum = nums.reduce(&:+)
group_total = sum / 3
sum_groups = {}

total_groups(group_total, nums, [], sum_groups)

sum_groups_by_length = {}

sum_groups.each do |k, v|
  l = v.length
  if sum_groups_by_length.has_key?(l)
    sum_groups_by_length[l].push(v)
  else
    sum_groups_by_length[l] = [v]
  end
end

length_selections = sum_groups_by_length.keys.repeated_combination(3).uniq.select { |a| a.reduce(&:+) == nums.length }.sort
possible_ideal_length_selections = length_selections.select { |a| a[0] == length_selections[0][0] }

p possible_ideal_length_selections

def pair_groups(sum_groups_by_length, length_selections)
  pairing_results = []
  length_selections.each do |l1, l2, l3|
    sum_groups_by_length[l1].product(sum_groups_by_length[l2], sum_groups_by_length[l3]).each do |a, b, c|
      if a.intersection(b).length == 0 && a.intersection(c).length == 0 && b.intersection(c).length == 0
        pairing_results.push([a, b, c])
      end
    end
  end
  return pairing_results
end

pairing_results = pair_groups(sum_groups_by_length, possible_ideal_length_selections)

uniq_first_groups = pairing_results.map { |g| g[0] }.uniq.sort.reverse

lowest_qe = Float::INFINITY
lowest_qe_group = nil

uniq_first_groups.each do |g|
  qe = g.reduce(&:*)
  if qe < lowest_qe
    lowest_qe = qe
    lowest_qe_group = g
  end
end

p lowest_qe_group
p lowest_qe