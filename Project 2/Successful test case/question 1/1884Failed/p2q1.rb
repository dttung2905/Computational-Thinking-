# p2q1.rb

# Team ID: Gx-yy <Edit>
# Name 1: Dao Thanh Tung
# Name 2: Ang Kah Eng
# Name 3: YOng Fu Xiang

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
#Calculate distance between two points

def dist2(r1, c1, r2, c2)
  return Math.sqrt((c1-c2)**2 + (r1-r2)**2)
end


def distance2points2(map,point1,point2)
  h=array_to_hash2(map)
  item1 = point1
  item2 = point2
  coord_item1 = h[item1]
  coord_item2 = h[item2]
  r1=coord_item1[0]
  c1 = coord_item1[1]
  r2 = coord_item2[0]
  c2 = coord_item2[1]
  distance = dist2(r1, c1, r2, c2)
  return distance

end



#Create an array with key as the name of the items and x,y coordinate as value of the items
def array_to_hash2(map)
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


def get_sequence(map, order)
  puts "Map #{map}"
  puts "order #{order}"
  #Now we are using the greedy 1 algorithm
  #create an answer list
  ref_point = "ORIGIN"
  visited_point_array = Array.new
  unvisited_point_array = order.clone
  # puts "-------------this is the unvisited point #{unvisited_point_array}"
  while unvisited_point_array.length >0 #when there is still member to be visited
    #create an array of all the distance from a reference point to the rest of the point in unvisited array
    #pick the smallest distance and remove the element from the unvisited array, push into the visited array
    #repeat the process
    current_min_dist_beg=Array.new
    current_min_dist= Array.new
    if ref_point == "ORIGIN" && unvisited_point_array.length > 1
      for i in 0...unvisited_point_array.length
        distance = distance2points2(map,unvisited_point_array[i],ref_point)
        current_min_dist_beg << distance
      end
      # now we have a list of the distance from the reference point to the rest of the point. => pick the smallest one
      index_beg =current_min_dist_beg.index(current_min_dist_beg.min) #index of the next point to visit
      #remove the item from the unvisited list and push into the visited
      visited_point_beg = unvisited_point_array.delete_at(index_beg)
      visited_point_array << visited_point_beg
      #now we have to update the reference point to be the visited point just now
      ref_point= visited_point_beg
      index_last = current_min_dist_beg.index(current_min_dist_beg.min)
      visited_point_last = unvisited_point_array.delete_at(index_last)
      # puts "Last point to be visited #{visited_point_last}"



    end
    # puts "==>>>>> #{unvisited_point_array}"
    # puts "reference point #{ref_point}"
    for i in 0...unvisited_point_array.length
      # puts "current min dist = #{current_min_dist}"
      distance = distance2points2(map,unvisited_point_array[i],ref_point)
      # puts "cal dist between #{unvisited_point_array[i]} and  ref_point = #{ref_point} ==> distance = #{distance}"

      current_min_dist << distance

    end
    # puts "---------------------------------------------------------------------------------------------"
    # puts "this is the current min dist #{current_min_dist}"
    # now we have a list of the distance from the reference point to the rest of the point. => pick the smallest one
    index =current_min_dist.index(current_min_dist.min) #index of the next point to visit
    #remove the item from the unvisited list and push into the visited
    visited_point = unvisited_point_array.delete_at(index)
    visited_point_array << visited_point
    # puts " this is the visited point #{visited_point}"
    #now we have to update the reference point to be the visited point just now
    ref_point= visited_point





  end
  visited_point_array << visited_point_last
  return  visited_point_array
end
