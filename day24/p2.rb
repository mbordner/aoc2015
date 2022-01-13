$starting = Time.now

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
$nums = File.read("./data.txt").lines(chomp: true).map(&:to_i).sort.reverse
#$nums = [11, 10, 9, 8, 7, 5, 4, 3, 2, 1]

$num_groups = 4
$sum = $nums.reduce(&:+)
$group_total = $sum / $num_groups
$sum_groups = {}

total_groups($group_total, $nums, [], $sum_groups)

$sum_groups_by_length = {}

$sum_groups.each do |k, v|
  l = v.length
  if $sum_groups_by_length.has_key?(l)
    $sum_groups_by_length[l].push(v)
  else
    $sum_groups_by_length[l] = [v]
  end
end

$length_selections = $sum_groups_by_length.keys.repeated_combination($num_groups).uniq.select { |a| a.reduce(&:+) == $nums.length }.sort
$possible_ideal_length_selections = $length_selections.select { |a| a[0] == $length_selections[0][0] }

$expected_group1_length = $possible_ideal_length_selections[0][0]

$group_pairings = []
$lowest_qe = Float::INFINITY
$lowest_qe_group = nil

$sum_groups_by_length[$expected_group1_length].each do |group1|
  diff = $nums.difference(group1)

  second_groups = {}
  total_groups($group_total, diff, [], second_groups)

  if second_groups.length > 0
    second_groups.each do |_, group2|
      diff2 = $nums.difference(group1 + group2)
      third_groups = {}
      total_groups($group_total, diff2, [], third_groups)

      if third_groups.length > 0
        third_groups.each do |_, group3|
          group4 = $nums.difference(group1 + group2 + group3)

          if group4.reduce(&:+) == $group_total
            $group_pairings.push([group1, group2, group3, group4])
            qe = group1.reduce(&:*)
            if qe < $lowest_qe
              $lowest_qe = qe
              $lowest_qe_group = group1
            end
          end
        end
      end
    end

  end

end

p $lowest_qe_group
p $lowest_qe

$ending = Time.now
$elapsed = $ending - $starting
puts "elapsed time: #{$elapsed}"
