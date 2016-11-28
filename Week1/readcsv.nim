import streams

const filename = slurp"card.csv"

type
  Card[W: static[int]] =
    array[1..W, string]



proc processCsvFile(W: static[int]): Card[W] =
  let ss = newStringStream(filename)
  var
    pos = 4
    index = 1
  while not ss.atEnd():
    result[index] = ss.readStr(4)
    ss.setPosition(pos + 1)
    inc(pos, 5)
    inc(index)
  ss.close()

let card = processCsvFile(10*10)
