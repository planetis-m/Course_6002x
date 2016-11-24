type
  Menu = object
    foods: seq[Food]
  Food = object
    name: string

proc `$`(f: Food): string =
  f.name & ": <, >"

proc getFood(n: seq[string]): auto =
  return iterator: Food =
    for i in 0 .. high(n):
      yield Food(name: n[i])

proc initMenu(size: int): Menu =
  newSeq(result.foods, size)

proc toMenu(n: seq[string]): Menu =
  result = initMenu(n.len)
  let foods = getFood(n)
  for i in 0 .. high(n):
    let t = foods()
    if finished(foods):
      break
    result.foods[i] = t


let names = @["wine", "beer", "pizza", "burger", "fries",
              "cola", "apple", "donut"]

let m = toMenu(names)
echo m.foods
