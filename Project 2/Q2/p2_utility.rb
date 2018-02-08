=begin
Useful methods that you can use:

print_2d_array(a)
  e.g. a = [["disc", "zebra", "apple", "kitty", "sausage"], ["pen", "mouse", "watermelon", "cd"], ["sofa", "hair", "durian", "car"], ["lightsaber", "horse", "pie", "dracula"], ["box", "ox", "cucumber"]]
       print_2d_array(a) will print this 2d array neatly. 
       Useful only for small 2d arrays. Otherwise it becomes difficult to read

Q1:
(a) q1_read_to_array(data_file_name)
(b) q1_score(map, answer, print_out)

Q2:
(a) q2_score(map, answer, print_out, m)

Q3: 
(a) q3_read_to_array(data_file_name)
(b) q3_score(order, layout)
=end

# Method: q1_read_to_array(data_file_name)
# Takes in:
#   - data_file_name (a string) name of CSV file that contains orders or map (e.g. m1 or o1.csv)
# Returns a 2D array.  
#   e.g. returns: [["x", "apple", "xo", "light"], ["stone", "axe", "knife"]]
def q1_read_to_array(data_file_name)
  array2d = []
  
  read_file("data/"+data_file_name).each{ |line|
    array1d = line.split(",").map(&:strip).map(&:to_s)
    array2d << array1d
  }
  return array2d
end

# Method: q1_sequence_ok?(answer, order)
# Takes in:
#   - answer: a 1D array of strings (items) e.g. ["horse", "apple", "durian", "zebra"]
#   - order: a 1D array of strings (items)  e.g. ["zebra", "horse", "apple", "durian"]
# Returns:
#   - true if there is nothing wrong with answer
#   - an error message (string) if something is wrong
def q1_sequence_ok?(answer, order)
  # check (i) format of answer. assumption: order is always correct
  if answer == nil
    return "Proposed seqence is nil. Proposed sequence should be a 1D array of items (strings)."
  elsif !answer.is_a?(Array)
    return "Proposed sequence is not an array. Proposed sequence should be a 1D array of items (strings)."
  end
  answer.each{|x| if !x.is_a?(String)
                    return "Proposed sequence contains an element which is not a string. Proposed sequence should be a 1D array containing only strings."
                  end}
  
  # check (ii) contents of answer; is it same as order?
  if answer.sort == order.sort
    return true # ok
  end

  # construct error message for returning
  missing_items = order - answer
  additional_items = answer - order
  
  error_msg = "The items in order are different from the items in your proposed sequence. They must contain identical items! "
  if missing_items.length>0
    error_msg += "These items are missing from your sequence :#{missing_items}."
  end
  if additional_items.length>0
    error_msg += "These items should not be in your sequence :#{additional_items}."
  end  
  return error_msg
end

# Method: q1_score(map, answer, print_out)
# Takes in:
#   - map: a 2D array of strings (items)  e.g. [["disc", "zebra", "apple"], ["pen", "mouse", nil], ["sofa", nil, "durian"], ["lightsaber", "horse", "pie"]]
#   - answer: a 1D array of strings (items) e.g. ["horse", "apple", "durian", "zebra"]
#   - print_out: a boolean. if true, this method prints out the distances between items. This can be used for debugging. if false, no printing is done.
# Returns:
#   - a score (float), which is the total distance travelled by arm
#   - an error message (string) if something is wrong with the answer
def q1_score(map, answer, print_out)
  return q2_score(map, answer, print_out, 0)
end

# Method: q2_score(map, answer, print_out, m)
# Exactly the same as q1_score, except that it takes in an additional parameter
# Takes in:
#   - m: (an integer), the max no. of items the arm can carry before it needs to return to the origin for unloading
# The scoring will be affected because of m as well.
def q2_score(map, answer, print_out, m)
  # place map into a hashtable so that the coordinates can be easily retrieved
  h = array_to_hash(map)
  
  # calculate score
  score = 0.0
  sequence = Marshal.load(Marshal.dump(answer))  # make a clone, so that the original answer is not affected

  # insert "ORIGIN" at appropriate places into sequence
  insert_origin(sequence, m)
  
  for i in 0...sequence.length-1
    item1 = sequence[i]
    item2 = sequence[i+1]
    coord_item1 = h[item1]
    coord_item2 = h[item2]
    r1 = coord_item1[0]
    c1 = coord_item1[1]
    r2 = coord_item2[0]
    c2 = coord_item2[1]
    
    distance = dist(r1, c1, r2, c2)
    score += distance
    
    # for troubleshooting/debugging
    if print_out == true
      puts "    #{item1} #{coord_item1}\t-> #{item2} #{coord_item2}\tDist:#{'%.01f' % distance}\tDist so far:#{'%.01f' % score}"
    end
  end  
  return score
end

# Method: insert_origin(sequence, m)
# used by q1_score and q2_score only
# Takes in: 
#   - sequence: a 1D array of strings (items)
#   - m: max no. of items arm can carry. if m is zero, "ORIGIN" will be inserted at the front and back only
# Returns:
#   - nothing
# Modifies the sequence array directly, by inserting the string "ORIGIN" at correct positions.
# The 1st and last element in the modified sequence will always be "ORIGIN"
#
# e.g. insert_origin(["a", "b", "c", "d", "e"], 0) -->  ["ORIGIN", "a", "b", "c", "d", "e", "ORIGIN"]
#      insert_origin(["a", "b", "c", "d", "e"], 1) -->  ["ORIGIN", "a", "ORIGIN", "b", "ORIGIN", "c", "ORIGIN", "d", "ORIGIN", "e", "ORIGIN"]
#      insert_origin(["a", "b", "c", "d", "e"], 2) -->  ["ORIGIN", "a", "b", "ORIGIN", "c", "d", "ORIGIN", "e", "ORIGIN"]
#      insert_origin(["a", "b", "c", "d", "e"], 3) -->  ["ORIGIN", "a", "b", "c", "ORIGIN", "d", "e", "ORIGIN"]
#      insert_origin(["a", "b", "c", "d", "e"], 5) -->  ["ORIGIN", "a", "b", "c", "d", "e", "ORIGIN"]
#      insert_origin(["a", "b", "c", "d", "e"], 6) -->  ["ORIGIN", "a", "b", "c", "d", "e", "ORIGIN"]
def insert_origin(sequence, m)
  if m == 0 # special case (represents infinity m)
    sequence.unshift("ORIGIN") # insert in front
    sequence << ("ORIGIN")     # insert behind
    return
  end

  if m < sequence.length
    pos = m
    while pos < sequence.length
      sequence.insert(pos, "ORIGIN")
      pos = pos + m + 1
    end
  end
  sequence.unshift("ORIGIN") # insert in front (arm starts from origin)

  if sequence.last != "ORIGIN"
    sequence << ("ORIGIN")     # insert behind (arm ends at origin)
  end
end
  
# Method: array_to_hash(map)
# used by q1_score and q2_score only
# Takes in: 
#   - map: a 2D array of strings (items)
# Returns:
#   - hashtable of key: item, value: 1D array of [row, column]
def array_to_hash(map)
  h = Hash.new # key: item, value: 1D array of [row, column]
  for r in 0...map.length
    for c in 0...map[r].length
      item = map[r][c]
      if item!= nil
        h[item] = [r, c]
      end
    end
  end
  h["ORIGIN"] = [0, 0] # special case. always fixed at (0,0)
  return h
end

# Method: dist(r1, c1, r2, c2)
# Takes in (r1, c1) and (r2, c2)
# Returns the Euclidian distance between these 2 points (float)
def dist(r1, c1, r2, c2)
  return Math.sqrt((c1-c2)**2 + (r1-r2)**2)
end

# Method: q3_read_to_hash(data_file_name)
# Takes in:
#   - data_file_name (a string) name of CSV file that contains orders/items (e.g. musical_instruments.csv) in the data folder
# Returns a hash table. key: orderID, value: 1D array of item IDs in that order
#   e.g. returns: {"order1"=>["x", "apple", "xo", "light"], "order2"=>["stone", "axe", "knife"]}
#   Do note that the order ID is not important for this problem.
def q3_read_to_hash(data_file_name)
  h = Hash.new
  
  read_file("data/"+data_file_name).each{ |line|
    array = line.split(",").map(&:strip).map(&:to_s)
   
    orderID = array[0]
    itemID = array[1]
 
    if h[orderID] == nil
      h[orderID] = []
    end
    
    h[orderID] << itemID    
  }
  return h
end

# Method: q3_read_to_array(data_file_name)
# Takes in:
#   - data_file_name (a string) name of CSV file that contains orders/items (e.g. musical_instruments.csv) in the data folder
# Returns a 2D array of orders. Each element is an array of item IDs. 
#   e.g. returns: [["x", "apple", "xo", "light"], ["stone", "axe", "knife"]] to represent 2 orders. The first order has 4 items, and the 2nd has 3 items.
def q3_read_to_array(data_file_name)
  orders = []
  
  h = q3_read_to_hash(data_file_name)
  h.each_pair { |k,v| orders << v }
  
  return orders
end

# used for scoring q3
# takes in:
#   order - a 1D array of items (strings)
#   layout - a 2D array of items (strings) that represent your proposed layout of the shelf
#
# This method assumes that layout has been checked.
#
# Returns:
#   - the number of columns that need to be traversed in your layout to fulfil the order (will be an integer >=0). Can be zero if order is empty.
#   - -1 (negative one) if there is an item in order that cannot be found in layout. This indicates an error condition.
def q3_score(order, layout)
  # empty order?
  if order.empty?
    return 0
  end

  max_no_columns = 0 # how many columns are there in layout?
  layout.each{|x| if x.length > max_no_columns
                    max_no_columns = x.length
                  end}
  
  uncollected_items = Marshal.load(Marshal.dump(order)) # clone order
  last_column_no = 0
  
  for c in 0...max_no_columns 
    # for each column (i.e. [0][0], [1][0], [2][0], [3][0], [4][0])
    for r in 0...layout.length # layout.length should always be 5
      current_cell = layout[r][c]
      if current_cell != nil and uncollected_items.include?(current_cell)
        uncollected_items.delete(current_cell)
      end
    end
    
    # are we done collecting the order?
    if uncollected_items.empty?
      last_column_no = c
      break
    end  
    # advancing to next column in next iteration of loop 
  end
  
  if !uncollected_items.empty?
    return -1 # there are items in order that cannot be found in layout
  end
  
  # score is the number of columns traversed
  return last_column_no + 1   # need to add 1 to it because column numbering starts from 0.
end

# used for checking p2q3
# takes in:
#   historical_orders - 2D array of items (strings)
#   layout - a 2D array of items (strings) that represent your proposed layout of the shelf
#            e.g. [["disc", "zebra", "apple", "kitty", "sausage"], ["pen", "mouse", "watermelon", "cd"], ["sofa", "hair", "durian", "car"], ["lightsaber", "horse", "pie", "dracula"], ["box", "ox", "cucumber"]]
#
# This method checks that layout conforms to the following rules: 
#   (i)   there must be 5 rows in your returned array
#   (ii)  all items in your returned array must be unique. 
#   (iii) all items in historical_orders must appear in your returned array
# Returns:
#   - true, if there is no error with layout
#   - an error message (string), if there is an error
def q3_layout_ok?(historical_orders, layout)
  # (i) basic checks
  if layout == nil
    return "layout is nil. It should be a 2D array of items (strings)"
  elsif !layout.is_a?(Array)
    return "layout is not an array. It should be a 2D array of items (strings)."
  elsif layout.length != 5
    return "layout is an array of #{layout.length} elements. It should be a 2D array of 5 elements (each to represent 1 row)."
  end
  
  # check if each of the 5 elements in layout are arrays as well
  for i in 0...layout.length
    if layout[i]==nil or !layout[i].is_a?(Array)
      return "layout should be a 2D array. There are elements in layout that are not correct."
    end
  end
    
  your_items = layout.flatten.sort  
  # (ii) all items in your returned array must be unique.
  if your_items.length != your_items.uniq.length # there are duplicates
    duplicated_items = your_items.select{ |e| your_items.count(e) > 1 }.uniq
    return "layout should not contain duplicated items. These are the duplicated items in your layout :#{duplicated_items}."
  end
  
  # (iii) 
  historical_items = historical_orders.flatten.uniq.sort
  if historical_items != your_items
    missing_items = historical_items - your_items
    extra_items   = your_items - historical_items
    
    # construct long-winded error message
    temp = "layout should contain exactly the same items as the historical orders."
    
    if missing_items.length > 0
      temp += "These items are missing in your layout: #{missing_items}."
    end
    
    if extra_items.length > 0
      temp += "These items are in your layout, but not required: #{extra_items}."
    end
    
    return temp
  end
  
  # all ok
  return true  
end
   
# used for printing a 2D array neatly
# takes in:
#   a - a 2D array of items (Strings) 
#       e.g. [["disc", "zebra", "apple", "kitty", "sausage"], ["pen", "mouse", "watermelon", "cd"], ["sofa", "hair", "durian", "car"], ["lightsaber", "horse", "pie", "dracula"], ["box", "ox", "cucumber"]]
def print_2d_array(a)

  max_word_length = 0  # keeps track of the longest string in layout
  flattened = a.flatten
  flattened.each{|x| if x.length > max_word_length
                       max_word_length = x.length 
                     end}
  max_word_length += 1  # we want a space in front when printing
  
  # insert a row of numbers into layout for printing
  max_no_columns = 0
  a.each{|x| if x.length > max_no_columns
               max_no_columns = x.length
             end}
  counter_array = [*0...max_no_columns]   # [0, 1, 2, 3....max_no_columns]
  
  # clone, insert numbers into array, then print
  temp = Marshal.load(Marshal.dump(a))
  temp.unshift(counter_array) # insert in front
  print_array(temp, max_word_length) 
end

# a is a 2D array
# word_length is the actual number of characters that will be printed for each element in a. 
# if element in a is "xz", and word_length is 5, 3 spaces will be inserted in front for padding before printing
#
# e.g. if a is [[1, 2], [3, 4]]
# print_array(a, 5)
#   will print:
#     1    2
#     3    4
#
def print_array(a, word_length)
  a.each{|x|
    x.each{|y| print y.to_s.rjust(word_length)}
    puts    
  }
  puts
end

# reads a CSV file and returns an array of strings - each line in the CSV file as one string
def read_file(file)
	lines = IO.readlines(file)
	if lines != nil
		for i in 0 .. lines.length-1
			lines[i] = lines[i].sub("\n","")
		end
		return lines[0..lines.length-1]
	end
	return nil
end
