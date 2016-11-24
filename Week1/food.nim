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

proc buildMenu(n: array[8, string]; val, cal: array[8, int]): seq[Food] =
  let m = len(val)
  result = newSeq[Food](m)
  for i in 0 .. <m:
    let t = newFood(n[i], val[i], cal[i])
    result.add(t)

let names = ["wine", "beer", "pizza", "burger", "fries",
              "cola", "apple", "donut"]

let values = [89,90,95,100,90,79,50,10]
let calories = [123,154,258,354,365,150,95,195]

let foods = buildMenu(names, values, calories)
