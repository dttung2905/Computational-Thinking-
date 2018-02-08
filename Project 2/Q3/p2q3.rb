# p2q3.rb

# Team ID: Gx-yy <Edit>
# Name 1: Dao Thanh Tung
# Name 2: Ang Kah Eng
# Name 3: YOng Fu Xiang


=begin
 Method: get_layout(historical_orders)
 Takes in:
   - historical_orders, a 2D array of orders. Each order is a 1D array of items (Strings)
     e.g. historical_orders = [["disc",    "zebra", "apple",  "sofa",    "kitty",      "pen",   "mouse", "watermelon"], 
                               ["sofa",    "hair",  "durian", "pen",     "lightsaber", "horse", "pie",   "box", "ox", "cucumber"], 
                               ["sausage", "cd",    "car",    "dracula", "sofa",       "pen"]]      
 Returns:
   a 2D array of items (Strings) that represent your proposed layout of the shelf
   e.g. [["disc", "zebra", "apple", "kitty", "sausage"], ["pen", "mouse", "watermelon", "cd"], ["sofa", "hair", "durian", "car"], ["lightsaber", "horse", "pie", "dracula"], ["box", "ox", "cucumber"]]

 Rules:
   - there must be 5 rows in your returned array. (returns a 2D array with length of 5)
   - all items in your returned array must be unique.    
   - all items in historical_orders must appear in your returned array
=end



def score( array )
  array = array.each_with_object(Hash.new(0)){|key,hash|
    hash[key] += 1}
  return array
end

def lengthscore(orig_array)
  orig_array = orig_array
  h = Hash.new
  for i in 0...orig_array.length
    for j in 0...orig_array[i].length
      item = orig_array[i][j]
      if h[item] == nil
        keyarray = [0,0] # [frequency, avg item length]
        h[item] = keyarray
      end
      # puts "h[item][0] #{h[item][0]}"
      # puts "h[item][1] #{h[item][1]}"

      h[item][0] +=1
      # puts "h[item][0] #{h[item][0]}"
      # puts "this is the length #{orig_array[i].length}"

      h[item][1] += orig_array[i].length

    end
  end
  #After that we have to divide the first one by total occurence
  return h
end


# Then we sum up the score in the form of key => [frequency , length size ]
def finalscore(h,flattenarray,originalarray)
  # puts "==>> #{originalarray}"
  max_index = originalarray.each_index.max_by { |i| originalarray[i].size }
  # puts "max index = #{max_index}"
  # puts "abcscs = #{originalarray[max_index].length}"
  maxsize = originalarray[max_index].length+1
  min_index = originalarray.each_index.min_by { |i| originalarray[i].size }
  minsize = originalarray[min_index].length+1
  frequency = flattenarray.length
  # puts "***** max= #{maxsize} min = #{minsize}  f= #{frequency}"
  h.each do |key,value|
    # if key == "B00APE06UA"
    #   puts "value = #{value }"
    #   puts "value[0] = #{value[0] }"
    #   puts "value[1] = #{value[1]}== #{(value[1]-minsize+1)}/#{(maxsize-minsize)}"
    #   puts "value[0] = #{value[0]} == #{value[0].clone}/#{frequency}"
    # end

    # value[0]= 10000*value[0]/frequency
    # value[1]= 100*(value[1]-minsize+1)/(maxsize-minsize)
    value [1] = 10000*( value[1]/value[0])
    # if key =="B00APE06UA"
    #   puts "value [1] = #{value[1]}"
    #   puts " ==>>>> #{value[0]} =========#{value[1]} #{(value[1]-minsize+1)}/#{(maxsize-minsize)}  "
    # end
    total_score = value[0]+value[1]
    # puts" #{total_score}"
    h[key] = total_score
  end
  return h
end


#determine the average length of each of the
def get_layout(historical_orders)
  # first we have to create a ranking of all the historical order
  historical_orders=historical_orders

  hist_order_flatten = historical_orders.flatten
  # uniq_order = hist_order.uniq
  #Create a hash table to store the frequency of the items
  # h=Hash.new
  # for i in 0...uniq_order.length
  #   key = uniq_order[i]
  #   count = hist_order.count(key)
  #   h[key]= count
  # end
  l_score = lengthscore(historical_orders)
  h = finalscore(l_score,hist_order_flatten,historical_orders)

  h_sorted = h.sort_by {|k,v| v}
  h_sorted= Hash[h_sorted.map {|key, value| [key, value]}]
  ranked_order = h_sorted.keys.reverse
  # puts "this is ranked order = #{ranked_order}"

  #This is the algo filled by columns
  layout = [[], [], [], [], []]
  row_counter = 0
  # for i in 0...ranked_order.length
  #   layout[row_counter] << ranked_order[i]
  #   row_counter += 1
  #   row_counter %= 5  # if row_counter becomes 5, it gets reset back to 0
  # end

  # this is the algo filled by row
  per_row = (ranked_order.length)/5
  layout =ranked_order.each_slice(per_row).to_a



  return layout
end
