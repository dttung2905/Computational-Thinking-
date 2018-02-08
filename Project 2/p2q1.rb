# p2q1.rb

# Team ID: Gx-yy <Edit>
# Name 1: <Fill up>
# Name 2: <Fill up>
# Name 3: <Fill up>
$globalArr = []
$globalArr2 = []
$finalAns = []
$BestAns = []
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
	$globalArr2 = []
	$BestAns = []
	
	printData(map, order)

	#return $finalAns.collect {|ind| ind[0]}
	
	##puts "BEST:"  +  $BestAns.to_s

	#score1 = q1_scoreMY(map, $BestAns[0])
	#score2 = q1_scoreMY(map, $BestAns[1])
	#if score1 < score2 
	#	return $BestAns[0]
	#else 
	#	return $BestAns[1]
	#end
	#test = order.permutation(2).to_a
	#print test
	ans = twoOpt(map, $BestAns[0])
	#puts "Order by greedy + 2-opt: " + ans.to_s
	#puts "====================================================================================================================================================="
	#puts "===================================================================================================================================================="
	return  ans
	#return twoOpt(map, order)
	#return randomShit(map,order)

	
end

#print "dist: " + calculateDistance(2,6,0,1).to_s
def calculateDistance(r1,c1,r2,c2)
	return Math.sqrt(((c1-c2) ** 2 + (r1 -r2) ** 2))
end

def printData(map, order)
	for r in 0...map.length
		for c in 0...map[r].length
			if order.include? map[r][c]
				#print "\t #{map[r][c]} [#{r}][#{c}]\t"
				pos = [r,c]
				arr = [map[r][c], pos]
				$globalArr.push(arr)
				#$globalArr2.push(arr)
			else
				#print "\t"
			end
		end
		#puts ""
	end
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

#This method returns the distance from Robot's arm to each item
def calculateDistanceFromRobot()
	for r in 0...$globalArr.length
		#for c in 0...$globalArr[r].length
			#calculateDistance(0,0,)
			#print "#{$globalArr[r][c]},"
		#end
		pos = $globalArr[r][1]
		distanceFromRobot = calculateDistance(0,0,pos[0],pos[1])
		$globalArr[r].push(distanceFromRobot)
		#$globalArr2[r].push(distanceFromRobot)
		#puts ""
	end
	#printAns() 
	orderItem()
	#orderItemReverse()
end

#This method first sort items in array according to the shortest distance away from Robot's arm.
#Remove the first item (nearest to Robot's arm)
#Then, for each remaining item in the $globalArr, compare it with the latest record in $finalAns
def orderItem()
$globalArr = $globalArr.sort_by { |e| e[2] }
finalAns = []
finalAns.push($globalArr.shift)
	while $globalArr.size > 0
		currentPost = finalAns.last
		currentPostRow = currentPost[1][0]
		currentPostCol = currentPost[1][1]
		for r in 0...$globalArr.length
			pos = $globalArr[r][1]
			distanceFromPreviousItem = calculateDistance(currentPostRow, currentPostCol, pos[0], pos[1])
			$globalArr[r][2] = distanceFromPreviousItem
		end
		$globalArr = $globalArr.sort_by { |e| e[2] }
		finalAns.push($globalArr.shift)
	end
	$BestAns.push(finalAns.collect {|ind| ind[0]})
	#puts "Order By Greedy: "  + finalAns.collect {|ind| ind[0]}.to_s
end

def orderItemReverse()
$globalArr2 = $globalArr2.sort_by { |e| e[3] }.reverse!
finalAns = []
finalAns.push($globalArr2.shift)
	while $globalArr2.size > 0
		currentPost = finalAns.last
		currentPostRow = currentPost[1][0]
		currentPostCol = currentPost[1][1]
		for r in 0...$globalArr2.length
			pos = $globalArr2[r][1]
			distanceFromPreviousItem = calculateDistance(currentPostRow, currentPostCol, pos[0], pos[1])
			$globalArr2[r][3] = distanceFromPreviousItem
		end
		$globalArr2 = $globalArr2.sort_by { |e| e[3] }
		finalAns.push($globalArr2.shift)
	end
	$BestAns.push(finalAns.collect {|ind| ind[0]})
	#puts "Final Order: "  + finalAns.collect {|ind| ind[0]}.to_s
	#puts "====================================================================================================================================================="
	#puts "===================================================================================================================================================="
end

#random
def randomSort(map, order)
	ans = []
	score = q1_scoreMY(map,order)
	ans.push([order, score])
	#puts "score: " + score.to_s
	for i in 0...1000
		order = order.shuffle
		score = q1_scoreMY(map,order)
		ans.push([order, score])
	end
	ans  = ans.sort_by { |e| e[1] }
	#puts ans[0][0]
	return ans[0][0]
end


def q1_scoreMY(map, answer)
  return q2_scoreMY(map, answer, 0)
end

def q2_scoreMY(map, answer, m)
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
    #if print_out == true
    #  puts "    #{item1} #{coord_item1}\t-> #{item2} #{coord_item2}\tDist:#{'%.01f' % distance}\tDist so far:#{'%.01f' % score}"
    #end
  end  
  return score
end


########################## 2-opt ##################################
def swap2(i,k, arr)
	swappedArr = []
	size = arr.size
	for c in 0..(i-1)
		swappedArr[c] = arr[c]
	end
	dec = 0
	for c in i..k
		swappedArr[c] = arr[k - dec]
		dec = dec + 1
	end
	for c in (k+1)...size
		swappedArr[c] = arr[c]
	end
	return swappedArr
end



def twoOpt(map, arr)
	best = 99999999999999
	numItems = arr.size
	visited = 0
	curent = 0
	newArr = arr
	counter = 0;
	toLoop = numItems*2*(numItems - 3)/2
	while (toLoop > 0)
	#while (visited < numItems)
		for i in 0...(numItems - 1)
			for j in (i+1)...numItems
				newerArr = swap2(i,j,newArr)
				newDistance = q1_scoreMY(map, newerArr)
				#puts "RESULTS # #{counter}: #{newerArr}   , Score: #{newDistance}"
				counter = counter + 1
				toLoop = toLoop - 1
				if (newDistance < best) 
					visited = 0
					best = newDistance
					newArr = newerArr
				end
			end
		end
		visited = visited + 1
		
	end
	#puts "counter:" + counter.to_s
	return newArr
end
