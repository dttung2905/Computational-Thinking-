#Now we are going to attempt to solve it using dynamic programming


#basic case is g(i,s) = distance of the tour starting from the point i , going to all the point in the set S
#and return to the beginning point ( in this case we indicate it as 1)

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
  coord_item2 = h[item2]
  r1=coord_item1[0]
  c1 = coord_item1[1]
  r2 = coord_item2[0]
  c2 = coord_item2[1]
  distance = dist2(r1, c1, r2, c2)
  return distance

end


$hashstore = Hash.new{|hsh,key| hsh[key] = [] }

def bitch(i,s,beg_point,hash)
  puts "----------------"
  puts "i = #{i},, s = #{s},, beg point = #{beg_point}"
  #input : i is starting point,
  # s is the array of the point to be visited,
  #beg_point : indicating the point to be returned to
  #output : g(i,s) = min {c(ji) + g(j,s-{j})}
  if s == nil
    twopointdist = distance2points2(hash,beg_point,i)
    puts "twopointdist #{twopointdist}"
    $hashstore["c(#{i},#{beg_point}"]= twopointdist
  else
    for j in 0...s.length
      puts "j= #{j}"
      if $hashstore["c(#{i},#{j}"] != nil
        mindist = 1.0/0.0
        puts "i = #{i}"
        dist1 = distance2points2(hash,i,s[j])
        puts "this is dist 1 #{dist1}"
        dist2 = bitch(s[j],s-[j],beg_point,hash)
        $hashstore["c(#{i},#{j}"] = dist1
        $hashstore["g(#{j},#{s-[j]}"]=dist2
        totaldist = dist1 +dist2
        if totaldist <mindist
          mindist=totaldist
        end
        puts "this is the dist1 = #{dist1}"
        puts "this is the dist2 = #{dist2}"
        puts "this is the Totaldist = #{totaldist}"

      end
    end
    $hashstore["g(#{i},#{s}"]=mindist
  end
  return $hashstore["g(#{i},#{s}"]
end

def get_sequence(map,order)
  h=array_to_hash2(map)
  puts "this is h #{h }"
  ref_point = "ORIGIN"
  array = order
  answer = bitch(ref_point,array,ref_point,h)
  return  puts answer
end


puts $hashstore
get_sequence(map,order)