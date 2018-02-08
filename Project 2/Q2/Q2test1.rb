map=[["xenophobia", "barbarians", "soldier", "granddaughters", "accordance", "dazzler", "atheists", "isolationism", "defoliants", "imprimatur"], ["duplicates", "president", "allure", "redfaced", "executioners", "detailing", "disfigurements", "wordiest", "necessaries", "freshers"], ["felonious", "burs", "exposes", "scare", "architectonic", "condition", "handier", "cozier", "peacefulness", "unenlightening"], ["vanes", "financed", "climbing", "leverage", "perspectives", "dendrites", "risings", "phosphate", "democratisation", "alkyl"], ["snowflake", "gunboats", "hazarded", "shootings", "lilliput", "jigs", "infatuated", "fusses", "geldings", "rovings"], ["schema", "daunting", "traps", "exes", "amphibious", "groan", "monkish", "procreate", "gritting", "commonplace"], ["disdainful", "papal", "disparity", "teacup", "penances", "corkage", "splattered", "beakers", "afterward", "gossipy"], ["suckers", "simile", "immunises", "doomsday", "celestial", "reported", "jubilant", "flush", "subsuming", "roadhouse"], ["droned", "roebuck", "ribbons", "corroded", "phrasing", "journeyed", "aubergine", "beaten", "paltrier", "homosexual"], ["knew", "muslin", "parsley", "dollies", "coprolite", "overthrow", "centrifuges", "crisps", "winders", "jaywalking"], ["retaliates", "consequentially", "adulterer", "deanery", "aye", "expectantly", "devoting", "blackguard", "injects", "nominator"], ["rancour", "baguettes", "sullying", "soaped", "crafted", "pith", "visas", "deceit", "reassembling", "plaudits"], ["angst", "niece", "microwave", "calculating", "burdens", "immanence", "mistreatment", "dreadlocks", "rushing", "confectioners"], ["reflexion", "ratiocination", "immobile", "futon", "lucidity", "liberalise", "repairable", "flatten", "outrage", "bout"], ["railroad", "callisthenics", "icy", "costumed", "discounts", "assisted", "minding", "antiquated", "wiping", "whim"], ["tiny", "album", "seized", "foiling", "generating", "potash", "polar", "foolishly", "inflicted", "rioted"], ["definable", "valuing", "mullioned", "downhill", "circumference", "dissemble", "layby", "aquatic", "headwords", "diner"], ["downgraded", "childlike", "pathology", "invigorate", "conjugates", "refitted", "amputating", "sending", "compassionately", "clangers"], ["slushy", "genetics", "engineers", "openers", "archers", "generalisations", "auditive", "chivalric", "syllabic", "commutator"], ["minke", "twanged", "manipulated", "aqueducts", "layouts", "graphical", "sword", "reverting", "tapir", "eigenvalues"]]
order = ["condition", "ribbons", "commutator", "jaywalking", "paltrier", "coprolite", "archers", "deceit", "layby"]




def dist2(r1, c1, r2, c2)
  return Math.sqrt((c1-c2)**2 + (r1-r2)**2)
end


def distance2points2(harshtable,point1,point2)
  h=harshtable
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


def get_sequence(map, order,m)
  #Now we are using the greedy 1 algorithm
  #create an answer list
  multiplier = m
  h=array_to_hash2(map)
  ref_point = "ORIGIN"
  visited_point_array = Array.new
  unvisited_point_array = order.clone
  while unvisited_point_array.length >0 #when there is still member to be visited
    #create an array of all the distance from a reference point to the rest of the point in unvisited array
    #pick the smallest distance and remove the element from the unvisited array, push into the visited array
    #repeat the process
    current_min_dist= Array.new
    for i in 0...unvisited_point_array.length
      distance = distance2points2(h,unvisited_point_array[i],ref_point)
      current_min_dist << distance
    end
    # now we have a list of the distance from the reference point to the rest of the point. => pick the smallest one
    index =current_min_dist.index(current_min_dist.min) #index of the next point to visit
    #remove the item from the unvisited list and push into the visited
    visited_point = unvisited_point_array.delete_at(index)
    visited_point_array << visited_point
    puts " this is the visited point #{visited_point}"
    #now we have to update the reference point to be the visited point just now
    ref_point= visited_point
    puts "This is the value of m #{m}"

    puts "This is the value of multiplier #{multiplier}"
    if m == visited_point_array.length
      position = m
      visited_point_array << "ORIGIN"
      m = position +multiplier +1
    end
    #remove the "Origin" from the answer
  end
  visited_point_array.delete("ORIGIN")
  return print visited_point_array
end

get_sequence(map,order,2)