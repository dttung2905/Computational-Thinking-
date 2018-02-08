# p2q1.rb

# Team ID: Gx-yy <Edit>
# Name 1: <Fill up>
# Name 2: <Fill up>
# Name 3: <Fill up>
$globalArr = []
$finalAns = []
=begin
  Method: get_sequence(map, order)
  Takes in:
   - map. a 2D array of strings representing the layout of the shelf
   - order. a 1D array of strings containing the items in an order (in no particular sequence)
            you can assume that items in order are unique. 
   e.g. map = [["disc", "zebra", "apple"], ["pen", "mouse", nil], ["sofa", nil, "durian"],   
               ["lightsaber", "horse", "pie"]]
        order = ["horse", "apple", "durian", "zebra"]
        
  Returns:
   The order with the items rearranged to your proposed sequence
   e.g. ["zebra", "apple", "durian", "horse"]

  Rules:
   - all the items in the returned array must be found in order
=end
 
def get_sequence(map, order)
	# this is a dumb but correct solution
	# shuffle randomly messes up the elements in an array
	
	#return order.shuffle
	$globalArr = []
	$finalAns = []
	printData(map, order)
	return $finalAns.collect {|ind| ind[0]}
end

#print "dist: " + calculateDistance(2,6,0,1).to_s
def calculateDistance(r1,c1,r2,c2)
	return Math.sqrt(((c1-c2) ** 2 + (r1 -r2) ** 2))
end

def printData(map, order)
	for r in 0...map.length
		for c in 0...map[r].length
			if order.include? map[r][c]
				print "\t #{map[r][c]} [#{r}][#{c}]\t"
				#$globalArr.push([map[r][c], [r][c]])
				pos = [r,c]
				arr = [map[r][c], pos]
				$globalArr.push(arr)
			else
				print "\t"
			end
		end
		puts ""
	end
	puts "====================================================================================================================================================="
	puts "===================================================================================================================================================="
	#printAns()
	calculateDistanceFromRobot()
end

def printAns() 
	for r in 0...$globalArr.length-1
		for c in 0...$globalArr[r].length
			print "#{$globalArr[r][c]},"
		end
		puts ""
	end
end

def calculateDistanceFromRobot()
	for r in 0...$globalArr.length
		#for c in 0...$globalArr[r].length
			#calculateDistance(0,0,)
			#print "#{$globalArr[r][c]},"
		#end
		pos = $globalArr[r][1]
		distanceFromRobot = calculateDistance(0,0,pos[0],pos[1])
		$globalArr[r].push(distanceFromRobot)
		#puts ""
	end
	printAns() 
	orderItem()
end

def orderItem()
$globalArr = $globalArr.sort_by { |e| e[2] }
$finalAns.push($globalArr.shift)
	while $globalArr.size > 0
		currentPost = $finalAns.last
		currentPostRow = currentPost[1][0]
		currentPostCol = currentPost[1][1]
		for r in 0...$globalArr.length
			pos = $globalArr[r][1]
			distanceFromPreviousItem = calculateDistance(currentPostRow, currentPostCol, pos[0], pos[1])
			$globalArr[r][2] = distanceFromPreviousItem
		end
		$globalArr = $globalArr.sort_by { |e| e[2] }
		$finalAns.push($globalArr.shift)
	end
	puts "Final: "  + $finalAns.to_s
end
 

