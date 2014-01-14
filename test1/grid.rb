ARR = ("A".."Z").to_a
SIZE = ARR.size

def letter
  ARR[rand(SIZE)]
end

def line(len)
  line = Array.new
  len.times do
    line << letter
  end
  line.join(" ")
end

def gen_grid(x, y)
  y.times{ puts line(x) }
end

def close
  puts "Please provide 2 arguments."
end

if ARGV[0] && ARGV[1]
  gen_grid(ARGV[0].to_i, ARGV[1].to_i)
else
  close
end

