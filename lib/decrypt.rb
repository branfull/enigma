require 'date'
require_relative 'enigma'
require 'pry'

def output
  enigma = Enigma.new
  file = File.open(ARGV[0], 'r')
  read = file.read.chomp
  file.close
  decrypt_key = ARGV[2]
  decrypt_date = ARGV[3]
  hash = enigma.decrypt(read, ARGV[2], ARGV[3])
  key_used = hash[:key]
  date_used = hash[:date]
  encrypted_file = File.open(ARGV[1], 'w')
  encrypted_file.write(hash[:decryption])
  encrypted_file.close
  "Created #{ARGV[1]} with the key #{key_used} and date #{date_used}"
end

puts output
