def tung()
  s = Array(1..4)
  for i in 1 ..(s.size-2)
    puts "-----------i= #{i}--------------"
    puts "s[i] = #{s[i]}"
    if s[i] / 2 == 0
      puts "this sis tung"
      puts "s[i-1] = #{s[i-1]} == s[i+1] = #{s[i+1]}"
      s[i-1] = s[i +1]
      puts "s[i-1] = #{s[i-1]}"
    end
  end
  return s
end

print tung
