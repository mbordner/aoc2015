=begin
For example, given the following distances:

London to Dublin = 464
London to Belfast = 518
Dublin to Belfast = 141

The possible routes are therefore:

Dublin -> London -> Belfast = 982
London -> Dublin -> Belfast = 605
London -> Belfast -> Dublin = 659
Dublin -> Belfast -> London = 659
Belfast -> Dublin -> London = 605
Belfast -> London -> Dublin = 982

The shortest of these is London -> Dublin -> Belfast = 605,
and so the answer is 605 in this example.
=end



File.open("./test.txt").each do |line|
  caps = line.match(/^(\w+)\sto\s(\w+)\s=\s(\d+)$/).captures
  $locations[caps[0]]=caps[0]
  $locations[caps[1]]=caps[1]

end
