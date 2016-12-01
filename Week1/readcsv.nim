import strutils, os

const data = slurp"card.csv"

type
  Card = seq[string]

proc processCsvFile(): Card =
  result = data.split({','} + NewLines)
  discard result.pop()

let card = processCsvFile()

var f = open("data", fmWrite)
discard f.writeBuffer(addr data[0], len(data) * sizeof(data[0]))
close(f)
