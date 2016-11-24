import tables, sequtils

type
  Food = object
    name: string
    value, calories: int

proc density(f: Food): float =
  f.value / f.calories

proc `$`(f: Food): string =
  f.name & ": <" & $f.value & ", " & $f.calories & ">"

proc newFood(n: string, val, cal: int): Food =
  result = Food(name: n, value: val, calories: cal)

proc buildMenu(items: Table[string, tuple[a, b: int]]): seq[Food] =
  let m = len(items)
  result = newSeq[Food](m)
  for i, v in items.pairs:
    let t = newFood(i, v.a, v.b)
    result.add(t)

let names = @["wine", "beer", "pizza", "burger", "fries",
              "cola", "apple", "donut"]

let values = @[89,90,95,100,90,79,50,10]
let calories = @[123,154,258,354,365,150,95,195]

let items = zip(names, zip(values, calories)).toTable
let foods = buildMenu(items)
