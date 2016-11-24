# ----------------
# type definitions
# ----------------

type
  Food = object
    name: string
    value, calories: int
  Menu = object
    foods: seq[Food]

# -------------
# Food routines
# -------------

proc density(f: Food): float =
  f.value / f.calories

proc `$`(f: Food): string =
  f.name & ": <" & $f.value & ", " & $f.calories & ">"

proc newFood(n: string, val, cal: int): Food =
  result = Food(name: n, value: val, calories: cal)

proc getFoods(n: seq[string]; val, cal: seq[int]): auto =
  return iterator: Food =
    for i in 0 .. high(n):
      yield newFood(n[i], val[i], cal[i])

# -------------
# Menu routines
# -------------

iterator items(m: Menu): Food =
  for i in items(m.foods):
    yield i

iterator mitems(m: var Menu): var Food =
  for i in mitems(m.foods):
    yield i

proc len(m: Menu): int =
  result = len(m.foods)

proc add(m: var Menu, f: Food) =
  m.foods.add(f)

proc `$`(m: Menu): string =
  result = ""
  if m.len != 0:
    for f in items(m):
      result.add($f & "\n")

proc initMenu(size: int): Menu =
  newSeq(result.foods, size)

proc toMenu(n: seq[string]; val, cal: seq[int]): Menu =
  let m = min(n.len, val.len, cal.len)
  result = initMenu(m)
  let foods = getFoods(n, val, cal)
  for i in 0 .. <m:
    let t = foods()
    if finished(foods):
      break
    result.foods[i] = t


# -----------
# Course Code
# -----------

let names = @["wine", "beer", "pizza", "burger", "fries",
              "cola", "apple", "donut"]

let values = @[89,90,95,100,90,79,50,10]
let calories = @[123,154,258,354,365,150,95,195]

let menu = toMenu(names, values, calories)
echo menu
