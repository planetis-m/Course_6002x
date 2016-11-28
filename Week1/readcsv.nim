import streams

const filename = "card.csv"

type
  Card[W: static[int]] =
    array[1..W, string]

proc `$`[T](a: openarray[T]): string =
  ## The `$` operator for arrays.
  result = "["
  for val in a:
    if result.len > 1: result.add(", ")
    result.add($val)
  result.add("]")

proc processCsvFile(W: static[int]): Card[W] =
  let fs = newFileStream(filename, fmRead)
  if isNil(fs): quit("cannot open the file" & filename)

  var
    pos = 4
    index = 1
  while not fs.atEnd():
    result[index] = fs.readStr(4)
    fs.setPosition(pos + 1)
    inc(pos, 5)
    inc(index)
  fs.close()

let card = processCsvFile(100)
echo card
