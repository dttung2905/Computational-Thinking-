load "p2_utility.rb"



historical_orders = q3_read_to_array("h1.csv")


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
def finalscore(h)
  # puts "==>> #{originalarray}"
  # puts "h = #{h}"
  h.each do |key,value|
    # if infreq_items.include?(key)
    #   buffer = 1 #Set this value to 1.25
    # else
    #   buffer = 1
    # end


    value [1] =10000*( value[1]/value[0])
    total_score = value[0]+value[1]
    h[key] = total_score
  end

  return h
end


def freq_table(historder)
  answer = historder.each_with_object(Hash.new(0)) { |word,counts| counts[word] += 1 }
  return answer
end


#this function will generate the list of unfrequently occured
def unfreq_list(historical_array,topitems)
  historical_array=historical_array
  answer= Array.new
  for i in 0...historical_array.length
    oneorder= historical_array[i]
    remaining_array = oneorder.clone-topitems
    if remaining_array.length < oneorder.length #it means that it contains item in top item list
      #push the item in the remaining array into the answer
      for j in 0...remaining_array.length
        item = remaining_array[j]
        if !answer.include?(item)
          #if the item is not in the list, push it into the list
          answer << item
        end
      end
    end
  end
  return answer
end



#determine the average length of each of the
def get_layout(historical_orders)
  # first we have to create a ranking of all the historical order
  historical_orders=historical_orders

  hist_order_flatten = historical_orders.flatten

  l_score = lengthscore(historical_orders)

  # puts "freqtable =#{freqtable}"
  #top item in the frequency table

  #find the important but infrequent item
  # puts "this is the infreq items = #{infreq_item}"

  # puts "keys = #{topitems}"
  h = finalscore(l_score)

  h_sorted = h.sort_by {|k,v| v}.reverse
  h_sorted= Hash[h_sorted.map {|key, value| [key, value]}]
  # puts "this is h_sorted #{h_sorted}"
  ranked_order = h_sorted.keys
  topitems = ranked_order[0..10]
  infreq_item = unfreq_list(historical_orders,topitems)[0..10]
  #delete those item which are important but infrequent
  deleted_ranked_order = ranked_order-infreq_item
  deleted_ranked_order=deleted_ranked_order.insert(0,infreq_item)
  ranked_order=deleted_ranked_order.flatten

  # puts "this is ranked order #{ranked_order}"
  # puts "this is ranked order = #{ranked_order}"

  #This is the algo filled by columns
  # layout = [[], [], [], [], []]
  # row_counter = 0
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


start_time = Time.now
get_layout(historical_orders)
time_taken = 1000*(Time.now - start_time)
puts "Execution time #{'%.01f' % time_taken} milliseconds." # display time lapsed to 1 dec pl





