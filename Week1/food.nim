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

proc density(f: Food): float =
  f.value / f.calories

proc `$`(f: Food): string =
  f.name & ": <" & $f.value & ", " & $f.calories & ">"

proc newFood(n: string, val, cal: int): Food =
  result = Food(name: n, value: val, calories: cal)

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
# Course Code
# -----------

let names = @["wine", "beer", "pizza", "burger", "fries",
              "cola", "apple", "donut", "cake"]

let values = @[89,90,95,100,90,79,50,10]
let calories = @[123,154,258,354,365,150,95,195]

let menu = toMenu(names, values, calories)
