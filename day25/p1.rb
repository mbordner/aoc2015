def get_sequence_num(row, col)
  if row + col == 2
    return 1
  end
  seq = 1
  y = 1
  (row - 1).times do
    seq += y
    y += 1
  end
  x = row + 1
  (col - 1).times do
    seq += x
    x += 1
  end
  return seq
end

def get_code(row, col)
  num = 20151125
  (get_sequence_num(row, col) - 1).times do
    num *= 252533
    num %= 33554393
  end
  return num
end

puts get_code(2981, 3075)
