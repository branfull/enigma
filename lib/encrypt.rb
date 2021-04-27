require 'date'
require_relative 'enigma'
require 'pry'

def output
  enigma = Enigma.new
  file = File.open(ARGV[0], 'r')
  read = file.read.chomp
  file.close
  hash = enigma.encrypt(read)
  key_used = hash[:key]
  date_used = hash[:date]
  encrypted_file = File.open(ARGV[1], 'w')
  encrypted_file.write(hash[:encryption])
  encrypted_file.close
  "Created #{ARGV[1]} with the key #{key_used} and date #{date_used}"
end

puts output
