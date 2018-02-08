tung =[[28, 25], [20, 30], [20, 24], [4, 29], [15, 29], [30, 23], [26, 25], [12, 28], [25, 21], [29, 23], [5, 22], [26, 24], [5, 23], [29, 20], [10, 23], [2, 21], [23, 27], [26, 22], [25, 29], [10, 26], [4, 26], [13, 25], [19, 28], [24, 23], [7, 25], [20, 26], [23, 23], [2, 29], [21, 23], [21, 24], [15, 20], [20, 22], [13, 26], [28, 25], [7, 22], [20, 27], [7, 27], [18, 29], [2, 20], [28, 22], [6, 26], [20, 28], [14, 30], [24, 29], [8, 21], [21, 23], [19, 26], [5, 23], [25, 24], [1, 24], [7, 26], [1, 20], [11, 29], [12, 21], [10, 29], [3, 22], [9, 29], [7, 23], [12, 29], [23, 29], [23, 24], [6, 21], [23, 23], [26, 26], [16, 21], [6, 26], [30, 26], [21, 27], [2, 23], [11, 25], [6, 21], [26, 21], [11, 28], [18, 22], [28, 24], [11, 29], [29, 25], [17, 26], [8, 22], [5, 27], [28, 29], [14, 26], [27, 23], [1, 21], [17, 27], [19, 24], [9, 30], [25, 22], [18, 20], [6, 26], [3, 30], [7, 20], [15, 21], [11, 22], [23, 24], [12, 24], [21, 26], [26, 26], [8, 21], [8, 22]]
#This is to add items of the same length together
def stack_similar(first_item,beg_r,beg_c,box_no_of_rows,box_no_of_col,hashtable,answer,first_item_coor)
  puts " --------------ENTERING THE FUNCTION STACK-----------------------------------------"
  puts "xxxxxxxxhashtable = #{hashtable}"
  puts "answer = #{answer}"
  list = hashtable[first_item_coor[0]]
  listkey=hashtable[first_item_coor[0]].keys
  puts "xxxxxxxx List = #{list}"
  puts "xxxxxxxx List key #{listkey}"
  puts "xxxxxxxx first item #{first_item_coor}"
  lowest_col = beg_c
  lowest_row = beg_r
  #Access through the Hash Table to get the number of items that have the same length
  for i in 0...listkey.length
    puts "==========================================i = #{i}=========================================="
    puts "lowest_row = #{lowest_row}"
    # puts "#{list[listkey[i]]}"
    # puts "#{list}"
    # puts "#{listkey[i]}"
    temp_array = idcompile(list[listkey[i]][0],listkey[i],first_item_coor[0],lowest_row,lowest_col)
    puts "temp_array #{temp_array}"
    itemid = get_itemID(answer)
    puts "xxxxxxxx itemid #{itemid}"
    puts "itemid.include?(temp_array[0]) #{itemid.include?(temp_array[0])}"
    if itemid.include?(temp_array[0])
      puts "nexttttttttttttttttt =>>> array =#{answer}"
      next
    end
    puts "temp_array  ahooooooooo#{temp_array}"
    puts "#{temp_array[3]} < #{box_no_of_rows}&& #{temp_array[4]} <#{box_no_of_col}"
    if temp_array[3] <box_no_of_rows && temp_array[4] <box_no_of_col
      lowest_col=beg_c
      lowest_row= temp_array[3]+1
      # puts "temp_array #{temp_array}"
      # puts "lowest-row = #{lowest_row}"
      answer << temp_array
      puts "answer ahiiiiiiiiiiiiiiiiii = #{answer}"
    else
      # puts "not suitable"
      break

    end
  end
  puts "++++++++++++++++++++++EXITING THE FUNCTION +++++++++++++++++++++++++++++++++++++="
  puts " answer= #{answer}"
  return answer
end


def get_itemID(array )
  idarray =Array.new
  for i in 0...array.length
    idarray << array[i][0]

  end
  return idarray
end

def arr_lb (items) #arrange length and breath of an items
  for i in 0...items.length
    if items[i][0] < items[i][1]
      items[i][0],items[i][1] = items[i][1],items[i][0]
    end
  end
  return items
end

def inject_index(array)
  for i in 0...array.length
    array[i].push(i)

  end
  return array
end

def mean_elim(array,box_row,box_col)
  #the array is going to be sorted in ascending order
  #do cumulative sum of the array
  culsum=Array.new
  for i in 0...array.length
    if i == 0
      culsum << array[0][0]*array[0][1]

    else
      sum =  array[i][0]*array[i][1] + culsum[i-1]
      culsum << sum
    end
  end
  boxarea=box_row*box_col
  sumarea=0
  for i in 0...array.length
    sumarea += array[i][0]*array[i][1]
  end
  avgarea = sumarea/(array.length)
  while array[-1][1]*array[-1][0] > 2*avgarea && culsum[-1] >= boxarea
    array.pop
    culsum.pop
  end
  return array
end

def create_hashtable(array)
  hashtable=Hash.new{ |h,k| h[k] = Hash.new{|k,v| k[v]=[]} }
  for i in 0...array.length
    hashtable[array[i][0]][array[i][1]].push array[i][2]
    hashtable[array[i][1]][array[i][0]].push array[i][2]
  end
  return hashtable
end

#function for compiling id
def idcompile(idee,breadth,length,upperleft_r,upperleft_c)
  idarray = []
  idarray << idee
  puts "this is the idarray (id) #{idarray}"
  idarray << upperleft_r
  puts "this is the idarray (upperleft row) #{idarray}"
  idarray << upperleft_c
  puts "this is the idarray (upperleft collumn)#{idarray}"
  idarray << upperleft_r+ breadth -1
  puts "this is the idarray (lowerright row)#{idarray} = #{upperleft_r}+ #{breadth} -1 "
  idarray << upperleft_c+length -1
  puts "this is the idarray (lowerright column)#{idarray} = #{upperleft_c}+#{length}-1"
  return idarray
end

def box(box_no_of_rows,box_no_of_col,items)
  # puts"this is the untouched items #{items}"
  answer = Array.new
  #insert the index into the array first
  items=inject_index(items)
  # puts"after inject index #{items}"
  #call for sorted array
  items = arr_lb(items)
  #sort the array in the ascending order of area
  sorteditems=items.clone.sort_by{|a,b| a*b}
  # puts "this is the sorted table #{sorteditems}"
  #futher eliminate the array
  injected_items=mean_elim(sorteditems.clone,box_no_of_rows,box_no_of_col)
  hashtable =create_hashtable(injected_items)

  lowest_col = 0
  lowest_row = 0
  #find the first item in the sorted list that can be put into the box
  temp_array = Array.new
  first_item = Array.new
  first_item_coor=Array.new
  itemid=Array.new
  beg_c = 0
  beg_r = 0
  catch :take_me_out do
    for j in 0...sorteditems.length
      for i in 0...sorteditems.length
        # puts "value of i = #{i}"''
        puts "sorted item = >>>>>>>>>>>>>>#{sorteditems[i]} "
        temp_array = idcompile(sorteditems[i][2],sorteditems[i][1],sorteditems[i][0],beg_r,beg_c)
        itemid= get_itemID(answer)
        # puts "mid way answer #{answer}"
        # puts "itemid =#{itemid}"
        # puts "itemid.include?(temp_array[0]) #{itemid.include?(temp_array[0])}"
        if itemid.include?(temp_array[0])
          next
        end
        # puts "#{temp_array[3]}<= #{box_no_of_rows-1} and#{temp_array[4]} <= #{box_no_of_col-1}"

        if temp_array[3]<= box_no_of_rows-1 && temp_array[4] <= box_no_of_col-1
          lowest_col=beg_c
          lowest_row=sorteditems[i][1]
          first_item= sorteditems[i]
          first_item_coor=temp_array
          break
        else
          throw :take_me_out
        end
      end

      # puts"lowest_col = #{lowest_col}"
      # puts "lowest_row =#{lowest_row}"
      #_----------------------------------------------------------------------------------------------------------
      # puts "this is the first item #{first_item}"
      answer << temp_array
      #after putting the first block down , find boxes of similar sizes in the hash table
      #list of the key of the first block that got in
      list = hashtable[first_item[0]]
      listkey=hashtable[first_item[0]].keys
      # puts "this is the list #{list}"
      # puts "this is the listkey #{listkey}"
      # puts "+++++++++++++++++++++++++++++++++++++++++++"
      for i in 1...listkey.length
        # puts "i = #{i}"
        # puts "lowest_row = #{lowest_row}"
        # puts "#{list[listkey[i]]}"
        # puts "#{list}"
        # puts "#{listkey[i]}"
        temp_array = idcompile(list[listkey[i]][0],listkey[i],first_item[0],lowest_row,lowest_col)
        itemid = get_itemID(answer)
        if itemid.include?(temp_array[0])
          next
        end
        # puts "temp_array #{temp_array}"
        if temp_array[3] <box_no_of_rows && temp_array[4] <box_no_of_col
          lowest_col=beg_c
          lowest_row= temp_array[3]+1
          # puts "temp_array #{temp_array}"
          # puts "lowest-row = #{lowest_row}"
          answer << temp_array
          # puts "answer = #{answer}"
        else
          # puts "not suitable"
          break

        end
      end

      beg_c= first_item_coor[4]+1
      beg_r=first_item_coor[1]
      if beg_c > box_no_of_col
        # puts "beg_c = #{beg_c} > #{box_no_of_col} yessssssssssssssssssssss"
        break
      end
      # puts "beg_c = #{beg_c}"
      # puts "beg_r= #{beg_r}"
      # puts "answer #{answer}"
    end
  end
  puts "xxxxxxxxxxxxxxxxxxSTART OF THE NEXT PHASE xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  puts "answer === #{answer}"

  #continue expanding to the right first before expanding at the bottom of the box
  itemid =get_itemID(answer) #update on the item id
  #what is the right most position that the box has occupied => check the last item
  beg_c =answer[-1][4]+1
  beg_r =0
  puts "beg_c = #{beg_c}"
  puts "beg_r = #{beg_r}"
  puts "itemid = #{itemid}"
  puts "hashtable = #{hashtable}"
  remaining= box_no_of_col -beg_c
  puts "remaining = #{remaining}"
  puts "Hash Remaining#{hashtable[remaining]}"
  puts "hashtable.key?(remaining) #{hashtable.key?(remaining)}"
  if hashtable.key?(remaining) && remaining > 0
    listkey = hashtable[remaining].keys
    puts "listkey = hashtable[remaining].keys #{listkey = hashtable[remaining].keys}"
    for i in 0...listkey.length
      first_item_coor= items[hashtable[remaining][listkey[i]][0]]

      puts "first item coor = #{first_item_coor}"
      first_item_breadth = 0
      if remaining == first_item_coor[0]
        first_item_breadth = first_item_coor[1]
      else
        first_item_breadth=first_item_coor[0]
      end
      first_item =idcompile(first_item_coor[2],first_item_breadth,remaining,beg_r,beg_c)
      puts "hashtable[remaining][listkey[0]][0] #{hashtable[remaining][listkey[0]][0]}"
      puts "first item = #{first_item}"
      puts "huhu#{first_item[3]} > #{box_no_of_rows} and  itemid.include?first_item[0] #{ itemid.include?(first_item[0])}"
      if (first_item[3] > box_no_of_rows) || itemid.include?(first_item[0])
        puts "next iteration XXXXXXXXXXXXXXX"
        next
      else
        puts "take a break bitch"
        beg_r = first_item[3]+1
        beg_c =first_item[2]
        break
      end
    end
    if first_item[3] > box_no_of_rows || itemid.include?(first_item[0])
      puts "are we done ? yess"
      return answer
    end

    answer << first_item
    stackbox = stack_similar(first_item,beg_r,beg_c,box_no_of_rows,box_no_of_col,hashtable,answer,first_item_coor)
    puts "this is the stackbox #{stackbox}"
    answer= stackbox


  else



  end
  return answer
end




print box(40,20,tung)