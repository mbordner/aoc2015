


a =

def segment_array(a)
  a = a.clone
  a << a.last + 1
  a.each_cons(2).map{ |pair|
    min = pair[0]
    max = pair[1]
    results = [[min,min]]
    if min + 1 <= max - 1
      results << [min+1,max-1]
    end
    results
  }.flatten(1)
end

p [0,2,3].each_cons(2).to_a

p segment_array([0,1,2,5])
p segment_array([0,1])
p segment_array([0,2])

