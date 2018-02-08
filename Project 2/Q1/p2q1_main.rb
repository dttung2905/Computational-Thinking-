load "p2q1.rb"
load "p2_utility.rb"

puts "p2q1 ..."
# ----- get user input for data file ------
print "Enter CSV file in data folder that contains map    (e.g. m1.csv) :"
map_data_file_name = gets.chomp
print "Enter CSV file in data folder that contains orders (e.g. o1.csv) :"
orders_data_file_name = gets.chomp

# ----- prepare data ------
# read from CSV files
map = q1_read_to_array(map_data_file_name)
original_map = Marshal.load(Marshal.dump(map))  # make a clone
orders = q1_read_to_array(orders_data_file_name)
original_orders = Marshal.load(Marshal.dump(orders))  # make a clone
# at this point, 
# - map is a 2D array that looks like this: [["disc", "zebra", "apple"], ["pen", "mouse", nil], ["sofa", nil, "durian"], ["lightsaber", "horse", "pie"]]
# - orders is a 2D array that looks like this: [["horse", "apple", "durian", "zebra"], [....<order2>....], [.....<order3>.....]]
# each order in orders represents one test case, that will be passed into your get_sequence method later.

# ----- run your method many times ------
answers = []
puts "\nRunning get_sequence using map from #{map_data_file_name}, and orders from #{orders_data_file_name}"
start_time = Time.now
for i in 0...orders.length
  answers[i] = get_sequence(map, orders[i]) # calling your method
end
time_taken = 1000*(Time.now - start_time)
puts "Execution time #{'%.01f' % time_taken}  milliseconds." # display time lapsed to 1 dec pl
puts "-------------------------------------"
puts

# ----- check your returned answers ----- 
total_score = 0
failed_test_cases = []

for i in 0...answers.length
  answer = answers[i]
  order = orders[i]
  check_ok = q1_sequence_ok?(answer, order)
  
  # print result for current test case
  puts "Test Case Number #{i}.\n  Order   :#{order}\n  Your ans:#{answer}"
  
  if check_ok == true
    # success
    score = q1_score(map, answer, true) # change to q1_score(map, answer, false) to turn off detailed printing of distances.
    total_score += score 
    puts "RESULT: passed. Score (Total dist moved by arm): #{'%.01f' % score}"
  else 
    # failure
    puts "RESULT: **** FAILED ****\nError message: #{check_ok}"
    failed_test_cases << i
  end
  puts "------------------------------------------------------"
end

# ----- print test case summary ------
puts "TEST SUMMARY:"
puts "No. of test cases: #{answers.length}. Read from \"#{map_data_file_name}\" and \"#{orders_data_file_name}\"."
puts "Execution time #{'%.01f' % time_taken} milliseconds." # display time lapsed
if failed_test_cases.length == 0
  avg_score = total_score.to_f / answers.length
  puts "OVERALL RESULT: All test cases passed!!"
  puts "Average quality score for test cases : #{'%.01f' % avg_score} (the lower the better)"
else
  puts "OVERALL RESULT: The following test cases failed: #{failed_test_cases}. You need to check your solution"
end

print "This is the fucking map = #{map}"