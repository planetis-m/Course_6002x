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

iterator foods(n: seq[string]; val, cal: seq[int]): Food =
  let m = min(n.len, val.len, cal.len)
  for i in 0 .. <m:
    yield newFood(n[i], val[i], cal[i])

proc isFilled(f: Food): bool =
  if isNil(f.name):
    return false
  elif (f.value, f.calories) == (0, 0):
    return false
  else:
    return true

# -------------
# Menu routines
# -------------

proc initMenu(size = 0): Menu =
  newSeq(result, size)

proc toMenu(n: seq[string]; val, cal: seq[int]): Menu =
  result = initMenu(n.len)
  var index = 0
  for f in foods(n, val, cal):
    result[index] = f
    inc(index)

iterator items(m: Menu): Food {.inline.} =
  ## iterates over each item of `a`.
  var i = 0
  let L = len(m)
  while i < L:
    if isFilled(m[i]): yield m[i]
    inc(i)
  assert(len(m) == L, "seq modified while iterating over it")

# -----------
# Course Code
# -----------

let names = @["wine", "beer", "pizza", "burger", "fries",
              "cola", "apple", "donut", "cake"]

let values = @[89,90,95,100,90,79,50,10]
let calories = @[123,154,258,354,365,150,95,195]

let menu = toMenu(names, values, calories)
echo menu
