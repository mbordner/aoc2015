require 'digest'

num = 0
secret = 'ckczppom'
until Digest::MD5.hexdigest(secret + num.to_s).match(/^0{5}/)
  num+=1
end

puts Digest::MD5.hexdigest(secret + num.to_s)

puts num