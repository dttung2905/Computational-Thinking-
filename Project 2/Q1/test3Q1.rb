map = [["xenophobia", "barbarians", "soldier", "granddaughters", "accordance", "dazzler", "atheists", "isolationism", "defoliants", "imprimatur"], ["duplicates", "president", "allure", "redfaced", "executioners", "detailing", "disfigurements", "wordiest", "necessaries", "freshers"], ["felonious", "burs", "exposes", "scare", "architectonic", "condition", "handier", "cozier", "peacefulness", "unenlightening"], ["vanes", "financed", "climbing", "leverage", "perspectives", "dendrites", "risings", "phosphate", "democratisation", "alkyl"], ["snowflake", "gunboats", "hazarded", "shootings", "lilliput", "jigs", "infatuated", "fusses", "geldings", "rovings"], ["schema", "daunting", "traps", "exes", "amphibious", "groan", "monkish", "procreate", "gritting", "commonplace"], ["disdainful", "papal", "disparity", "teacup", "penances", "corkage", "splattered", "beakers", "afterward", "gossipy"], ["suckers", "simile", "immunises", "doomsday", "celestial", "reported", "jubilant", "flush", "subsuming", "roadhouse"], ["droned", "roebuck", "ribbons", "corroded", "phrasing", "journeyed", "aubergine", "beaten", "paltrier", "homosexual"], ["knew", "muslin", "parsley", "dollies", "coprolite", "overthrow", "centrifuges", "crisps", "winders", "jaywalking"], ["retaliates", "consequentially", "adulterer", "deanery", "aye", "expectantly", "devoting", "blackguard", "injects", "nominator"], ["rancour", "baguettes", "sullying", "soaped", "crafted", "pith", "visas", "deceit", "reassembling", "plaudits"], ["angst", "niece", "microwave", "calculating", "burdens", "immanence", "mistreatment", "dreadlocks", "rushing", "confectioners"], ["reflexion", "ratiocination", "immobile", "futon", "lucidity", "liberalise", "repairable", "flatten", "outrage", "bout"], ["railroad", "callisthenics", "icy", "costumed", "discounts", "assisted", "minding", "antiquated", "wiping", "whim"], ["tiny", "album", "seized", "foiling", "generating", "potash", "polar", "foolishly", "inflicted", "rioted"], ["definable", "valuing", "mullioned", "downhill", "circumference", "dissemble", "layby", "aquatic", "headwords", "diner"], ["downgraded", "childlike", "pathology", "invigorate", "conjugates", "refitted", "amputating", "sending", "compassionately", "clangers"], ["slushy", "genetics", "engineers", "openers", "archers", "generalisations", "auditive", "chivalric", "syllabic", "commutator"], ["minke", "twanged", "manipulated", "aqueducts", "layouts", "graphical", "sword", "reverting", "tapir", "eigenvalues"]]

order = ["calculating", "pith", "downhill", "unenlightening", "vanes", "jigs", "expectantly", "minding", "atheists", "devoting"]


def dist2(r1, c1, r2, c2)
  return Math.sqrt((c1-c2)**2 + (r1-r2)**2)
end

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

def distance2points2(hash,point1,point2)
  h=hash
  item1 = point1
  item2 = point2
  coord_item1 = h[item1]
  # puts "coord_item1 = #{coord_item1}"
  coord_item2 = h[item2]
  r1=coord_item1[0]
  c1 = coord_item1[1]
  r2 = coord_item2[0]
  c2 = coord_item2[1]
  distance = dist2(r1, c1, r2, c2)
  # puts "distance = #{distance}"
  return distance

end

#first we have to create a matrix of distance between 2 points
def distancematrix(hash,order )

  h = Hash.new{|hsh,key| hsh[key] = {} }
  for i in 0...order.length
    for j in (i+1)...order.length
      point1= order[i]
      point2= order[j]
      # puts "point1 = #{point1}"
      # puts "point2 = #{point2}"
      distance = distance2points2(hash,point1,point2)
      h[point1][point2]= distance
      # puts "this is h = #{h}"
    end
  end
  return h
end




def binh(from,to,hashdistance,order)
  #insert the origin into the array first
  answer= Array.new
  answer << "ORIGIN"
  hash = Hash.new
  keys =  hash.keys
  for i in 0...keys.length
    visitednode = keys[i]
    unvisitednode=order-visitednode
    for j in 0...unvisitednode.length
      #insert that another one element into the list
      newhash = Hash.new
      oldist= hash[visitednode]
      last_point = visitednode[-1]
      newpoint = unvisitednode[j]
      visitednode << newpoint
      newhash[visitednode]= oldist+ distance2points2(hash,last_point,newpoint)

      puts "newhash #{newhash}"

    end
  end
  return
end



def get_sequence(map,order)
  h= array_to_hash2(map)
  order = order
  ref_point = "ORIGIN"
  matrix = distancematrix(h,order)
  # puts "matrix = #{matrix}"
  tung= binh("ORIGIN","ORIGIN",matrix,order)
  puts tung



end


get_sequence(map,order)