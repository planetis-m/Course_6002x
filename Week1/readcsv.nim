import strutils

const data = slurp"card.csv"

type
  Card = seq[string]

proc processCsvFile(): Card =
  result = data.split({','} + NewLines)
  discard result.pop()

const card = processCsvFile()
