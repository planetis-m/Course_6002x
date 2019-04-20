import math


type
   Item = object
      name: string
      value, weight: int
   List = seq[Item]

# -------------
# Item routines
# -------------

proc `$`(i: Item): string =
   i.name & ": <" & $i.value & ", " & $i.weight & ">"

proc newItem(n: string, val, wei: int): Item =
   Item(name: n, value: val, weight: wei)

proc getValue(i: Item): int =
   i.value

proc getCost(i: Item): int =
   i.weight

# -------------
# List routines
# -------------

proc initList(size = 0): List {.inline.} =
   newSeq(result, size)

proc toList(s: seq[(string, int, int)]): List =
   let m = len(s)
   result = initList(m)
   for i in 0 .. <m:
      result[i] = newItem(s[i][0], s[i][1], s[i][2])

# --------------
# Power Set impl
# --------------

iterator powerSet(items: List): List =
   ## generate all combinations of N items
   let n = len(items)
   # enumerate the `2^n` possible combinations
   for i in 0 ..< 2^n:
      var combo = initList()
      for j in 0 ..< n:
         # test bit jth of integer i
         if (i shr j) mod 2 == 1:
            combo.add(items[j])
      yield combo

# -------------------
# yieldAllCombos impl
# -------------------

iterator yieldAllCombos(items: List): (List, List) =
   ## Generates all combinations of N items into two bags, whereby each 
   ## item is in one or zero bags.
   ##
   ## Yields a tuple, (bag1, bag2), where each bag is represented as 
   ## a list of which item(s) are in each bag.
   let n = len(items)
   # enumerate the `3^n` possible combinations
   for i in 0 ..< 3^n:
      var bag1, bag2 = initList()
      for j in 0 ..< n:
         # test bit jth of integer i
         if (i div 3^j) mod 3 == 1:
            bag1.add(items[j])
         elif (i div 3^j) mod 3 == 2:
            bag2.add(items[j])
      yield (bag1, bag2)

# -----------
# Course Code
# -----------

let items = @[
   ("clock", 175, 10),
   ("painting", 90, 9),
   ("radio", 20, 4),
   ("vase", 50, 2),
   ("book", 10, 1),
   ("computer", 200, 20)
]

let list = toList(items)

for i, k in yieldAllCombos(list):
   echo "Bag 1: ", i, ", Bag 2: ", k
