import algorithm
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
  result = Food(name: n, value: val, calories: cal)

proc getValue(f: Food): int =
  result = f.value

proc getCost(f: Food): int =
  result = f.calories

# -------------
# Menu routines
# -------------

proc initMenu(size = 0): Menu =
  newSeq(result, size)

proc toMenu(n: seq[string]; val, cal: seq[int]): Menu =
  let m = min(n.len, val.len, cal.len)
  result = initMenu(m)
  for i in 0 .. <m:
    result[i] = newFood(n[i], val[i], cal[i])

# -----------
# Greedy impl
# -----------

proc greedy(items: Menu, maxCost: int, cmp: proc(x, y: Food): int): (Menu, int) =
  var itemsCopy = sorted(items, cmp, SortOrder.Descending)
  var result = initMenu()
  var totalValue, totalCost = 0
  for i in itemsCopy:
    if (totalCost + i.getCost()) <= maxCost:
      result.add(i)
      totalCost += i.getCost()
      totalValue += i.getValue()
  return (result, totalValue)

proc testGreedy(items: Menu, constraint: int, cmp: proc(x, y: Food): int) =
  let (taken, val) = greedy(items, constraint, cmp)
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

# -----------
# Course Code
# -----------

let names = @["wine", "beer", "pizza", "burger", "fries",
              "cola", "apple", "donut", "cake"]

let values = @[89, 90, 95, 100, 90, 79, 50, 10]
let calories = @[123, 154, 258, 354, 365, 150, 95, 195]

let foods = toMenu(names, values, calories)
testGreedys(foods, 1000)
