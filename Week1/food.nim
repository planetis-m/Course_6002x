import algorithm, tables, random

# ----------------
# type definitions
# ----------------

type
   Food = object
      name: string
      value, calories: int
   Menu = seq[Food]

# -------------
# Food routines
# -------------

proc density(f, j: Food): int =
   f.value * j.calories - j.value * f.calories

proc `$`(f: Food): string =
   f.name & ": <" & $f.value & ", " & $f.calories & ">"

proc newFood(n: string, val, cal: int): Food =
   Food(name: n, value: val, calories: cal)

proc getValue(f: Food): int =
   f.value

proc getCost(f: Food): int =
   f.calories

# -------------
# Menu routines
# -------------

proc initMenu(size = 0): Menu {.inline.} =
   newSeq(result, size)

proc toMenu(n: seq[string]; val, cal: seq[int]): Menu =
   let m = min([n.len, val.len, cal.len])
   result = initMenu(m)
   for i in 0 .. <m:
      result[i] = newFood(n[i], val[i], cal[i])

# -----------
# Greedy impl
# -----------

proc greedy(items: Menu, maxCost: int, cmp: proc(x, y: Food): int): (int, Menu) =
   var itemsCopy = sorted(items, cmp, Descending)
   var takenItems = initMenu()
   var totalValue, totalCost = 0
   for i in itemsCopy:
      if (totalCost + i.getCost()) <= maxCost:
         takenItems.add(i)
         totalCost += i.getCost()
         totalValue += i.getValue()
   (totalValue, takenItems)

proc testGreedy(items: Menu, constraint: int, cmp: proc(x, y: Food): int) =
   let (val, taken) = greedy(items, constraint, cmp)
   echo("Total value of items taken = ", val)
   for item in taken:
      echo("   ", item)

proc testGreedys(foods: Menu, maxUnits: int) =
   echo("Use greedy by value to allocate ", maxUnits, " calories")
   testGreedy(foods, maxUnits, proc(x, y: Food): int = getValue(x) - getValue(y))
   echo("\nUse greedy by cost to allocate ", maxUnits, " calories")
   testGreedy(foods, maxUnits, proc(x, y: Food): int = getCost(y) - getCost(x))
   echo("\nUse greedy by density to allocate ", maxUnits, " calories")
   testGreedy(foods, maxUnits, density)

# ----------------
# Search Tree Impl
# ----------------

proc maxVal(toConsider: Menu, avail: int): (int, Menu) =
   # Assumes toConsider a list of items, avail a weight
   # Returns a tuple of the total value of a solution to the
   # 0/1 knapsack problem and the items of that solution
   if toConsider.len == 0 or avail == 0:
      result = (0, nil)
   elif toConsider[0].getCost() > avail:
      #Explore right branch only
      result = maxVal(toConsider[1..^1], avail)
   else:
      let nextItem = toConsider[0]
      #Explore left branch
      var (withVal, withToTake) = maxVal(toConsider[1..^1],
                                  avail - nextItem.getCost())
      withVal += nextItem.getValue()
      #Explore right branch
      let (withoutVal, withoutToTake) = maxVal(toConsider[1..^1], avail)
      #Choose better branch
      if withVal > withoutVal:
         result = (withVal, withToTake & nextItem)
      else:
         result = (withoutVal, withoutToTake)

proc testMaxVal(foods: Menu, maxUnits: int) =
   echo("Use search tree to allocate ", maxUnits, " calories")
   let (val, taken) = maxVal(foods, maxUnits)
   echo("Total value of items taken = ", val)
   for item in taken:
      echo("   ", item)

# -------------------
# Dynamic Programming
# -------------------

proc buildLargeMenu(numItems, maxVal, maxCost: int): Menu =
   result = initMenu(numItems)
   for i in 0 .. <numItems:
      result[i] = newFood($i, random(1..maxVal+1), random(1..maxCost+1))

proc fastMaxVal(toConsider: Menu, avail: int, memo = newTable[(int, int), (int, Menu)]()): (int, Menu) =
   # Assumes toConsider a list of items, avail a weight
   # Returns a tuple of the total value of a solution to the
   # 0/1 knapsack problem and the items of that solution
   if memo.hasKey((toConsider.len, avail)):
      result = memo[(toConsider.len, avail)]
   elif toConsider.len == 0 or avail == 0:
      result = (0, nil)
   elif toConsider[0].getCost() > avail:
      #Explore right branch only
      result = fastMaxVal(toConsider[1..^1], avail, memo)
   else:
      let nextItem = toConsider[0]
      #Explore left branch
      var (withVal, withToTake) = fastMaxVal(toConsider[1..^1],
                                             avail - nextItem.getCost(), memo)
      withVal += nextItem.getValue()
      #Explore right branch
      let (withoutVal, withoutToTake) = fastMaxVal(toConsider[1..^1], avail, memo)
      #Choose better branch
      if withVal > withoutVal:
         result = (withVal, withToTake & nextItem)
      else:
         result = (withoutVal, withoutToTake)
      memo[(toConsider.len, avail)] = result

proc testFastMaxVal(foods: Menu, maxUnits: int) =
   echo("Use search tree to allocate ", maxUnits, " calories")
   let (val, taken) = fastMaxVal(foods, maxUnits)
   echo("Total value of items taken = ", val)
   for item in taken:
      echo("   ", item)

# -----------
# Course Code
# -----------

let names = @["wine", "beer", "pizza", "burger", "fries",
              "cola", "apple", "donut", "cake"]

let values = @[89, 90, 95, 100, 90, 79, 50, 10]
let calories = @[123, 154, 258, 354, 365, 150, 95, 195]

# let foods = toMenu(names, values, calories)
# testGreedys(foods, 750)
# echo ""
# testMaxVal(foods, 750)

let items = buildLargeMenu(50, 90, 250)
testFastMaxVal(items, 750)
