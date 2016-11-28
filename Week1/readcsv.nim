import strutils

const data = "card.csv"

type
  Card = seq[string]

template withFile(f, fn, actions: untyped): untyped =
  var f: File
  if open(f, fn):
    try:
      actions
    finally:
      close(f)
  else:
    quit("cannot open: " & fn)

proc processCsvFile(): Card =
  withFile(fs, data):
    let s = readAll(fs)
    result = s.split({','} + NewLines)
    discard result.pop()

let card = processCsvFile()
echo card
