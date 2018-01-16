require 'digest'

NUM_ZEROES = 4

def hash(message)
  Digest::SHA256.hexdigest(message)
end

def find_nonce(message)
  nonce = "trace is a cool coin!"
  count = 0
  until valid_nonce?(nonce, message)
    nonce = nonce.next
    count += 1
  end
  puts count
end

def valid_nonce?(nonce, message)
  hash(nonce + message).start_with("0"*NUM_ZEROES)
end
