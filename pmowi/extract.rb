require 'byebug'
data = File.read('TBKAT.DAT')
data[3..-3].split("\r\n.").each_with_index do |d, i|
  lines = d.split("\r\n")
  name = lines.shift
  puts name
  File.write("data/#{name}.csv", lines.map(&:strip).join("\n"))
end
