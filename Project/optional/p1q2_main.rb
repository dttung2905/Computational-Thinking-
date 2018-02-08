load "p1q2.rb"
load "p1_utility.rb"

puts "p1 QUESTION 2..."
# ----- get user input for data file ------
puts "Manually check the dimensions of your items in your CSV file. You must enter box dimensions that can fit the largest item."
print "Enter standard box dimension (no of rows)    :"
box_no_of_rows = gets.to_i
print "Enter standard box dimension (no of columns) :"
box_no_of_col  = gets.to_i
print "Enter CSV file in data folder (e.g. dataA.csv) :"
data_file_name = gets.chomp

# ----- prepare data ------

# read from data_file_name and store in test_case
# ONLY THE *LAST* LINE in the CSV will be stored as an array in test_case
# the remaining lines will be ignored. In other words, there is only ONE test case for each run
test_case = []
read_file("data/"+data_file_name).each{ |line|
  array = line.split(",").map(&:strip).map(&:to_i)
  test_case = array.each_slice(2).to_a
}
# at this point, test_case is a 2D array which looks like this:
# [[1, 3], [10, 2], [3, 10], [7, 10], [7, 1], [1, 5], [8, 9], [7, 3]]

original_test_case = Marshal.load(Marshal.dump(test_case)) # make a clone
no_of_items = test_case.length

# ----- check if all items can fit into standard box ------
check_standard_box_size(box_no_of_rows, box_no_of_col, test_case)

# ----- run ONE test case ------
start_time = Time.now
puts "\nRunning test case"
answer = pack(box_no_of_rows, box_no_of_col, test_case)  # <-- answer will be a 3D array
time_taken = Time.now - start_time
puts "Execution time #{'%.02f' % time_taken} seconds." # display time lapsed to 2 decimal places
puts 

# ----- show results ------
puts "-------------------------------------"
puts "Test case with standard box dimensions #{box_no_of_rows} x #{box_no_of_col}"
puts "Test case input: #{original_test_case.inspect}"
puts "Number of items in test case: #{no_of_items}"
puts "Your method returned: #{answer.inspect}"

# checking code

# check if all items are in answer first
items_found = get_itemID(answer)
puts "Items found in all your boxes: #{items_found.inspect}"

# check items_found
error = check_items(items_found, no_of_items) # error will be true or false
puts

# check layout of boxes, one at a time
result = true
if error == false
  # check the layout of each box in answer
  for j in 0...answer.length
    current_box_layout = answer[j]
    puts "Examining box number #{j}... Your layout: #{current_box_layout.inspect}"
    result = item_dimensions_correct?(box_no_of_rows, box_no_of_col, original_test_case, current_box_layout)
    if result == true
      result = no_overlapping_items?(box_no_of_rows, box_no_of_col, current_box_layout)
    end
    if result != true
      puts "Error: #{result}"
      break
    end
    puts "Box #{j} is OK"
  end
end

# print result
puts
puts "TEST SUMMARY:"
if error == false and result == true
  quality = answer.length # this is the number of boxes
  puts "RESULTS: passed. Quality (no. of boxes used): #{quality} (The lower the better)"
else 
  puts "RESULTS: **** FAILED ****"  
end
puts "-------------------------------------"

