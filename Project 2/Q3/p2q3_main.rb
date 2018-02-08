load "p2q3.rb"
load "p2_utility.rb"

puts "p2q3 ..."
# ----- get user input for data file ------
print "Enter CSV file in data folder that contains historical orders (e.g. h1.csv) :"
data_file_name = gets.chomp

# ----- prepare data ------

# read from data_file_name and store in historical_orders
historical_orders = q3_read_to_array(data_file_name)
# at this point, historical_orders is a 2D array that looks like this:
# [[item1, item3, item4], [item9, item1, item6, item8]]
original_historical_orders = Marshal.load(Marshal.dump(historical_orders))  # make a clone

# ----- run your method ------
layout = nil
puts "\nRunning get_layout using historical orders from #{data_file_name}"
start_time = Time.now
layout = get_layout(historical_orders)
time_taken = 1000*(Time.now - start_time)
puts "Execution time #{'%.01f' % time_taken} milliseconds." # display time lapsed to 1 dec pl
puts "-------------------------------------"
puts 

# ----- check your returned layout ----- 
check_ok = q3_layout_ok?(original_historical_orders, layout)
if check_ok != true
  puts "RESULT: **** FAILED ****"
  puts "ERROR in your proposed layout: #{check_ok}"
end

# ----- let user choose 1 order from historical_orders to "act" as new order ------
if check_ok == true
  # get user to enter order index
  print "Enter order index (in historical orders) to use as new test order (0-#{original_historical_orders.length-1}):"
  test_order_index = gets.to_i
  
  new_order = original_historical_orders[test_order_index]
  score = q3_score(new_order, layout)
  
  # print result
  if score == -1
    puts "RESULT: **** FAILED ****"
    puts "Error message: This is likely due to an item in the new order that is not found in your layout."
  else 
    puts "RESULT: OK"  
    puts "Score (the smaller the better): #{score}"
  end
  puts "-------------------------------------"
end
print "hist order = #{historical_orders}"