=begin

The elves bought too much eggnog again - 150 liters this time. To fit it all into your refrigerator,
you'll need to move it into smaller containers. You take an inventory of the capacities of the available containers.

For example, suppose you have containers of size 20, 15, 10, 5, and 5 liters. If you need to store 25 liters,
there are four ways to do it:

15 and 10
20 and 5 (the first 5)
20 and 5 (the second 5)
15, 5, and 5

Filling all containers entirely,
how many different combinations of containers can exactly fit all 150 liters of eggnog?

=end

LITRES = 150

$digits = []
File.open("./data.txt").each do |line|
  $digits << line.to_i
end

$combos = []

$digits.permutation.each do |arr|
  sum = 0
  for i in 0 .. arr.length do
    sum += arr[i]
    if sum >= LITRES
      if sum == LITRES
        $combos << arr[0..i]
      end
      break
    end
  end
end

p $combos
puts $combos.length