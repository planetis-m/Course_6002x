import sequtils, gnuplot

template rangeFloat(incr: untyped): untyped {.dirty.} =
  var res = a
  while res <= b:
    yield res
    incr

iterator `..`(a, b: float): float {.inline.} =
  rangeFloat:
    res += 1.0

iterator arange(a, b: float, step = 1.0): float {.inline.} =
  rangeFloat:
    res += step

iterator linspace(a, b: float, num = 50): float {.inline.} =
  let step = (b - a) / float(num - 1) # subtrack 1 to match numpy
  rangeFloat:
    res += step

proc arange(a, b: float, step = 1.0): seq[float] =
  accumulateResult(arange(a, b, step))

proc linspace(a, b: float, num = 50): seq[float] =
  accumulateResult(linspace(a, b, num))

# Tests
# echo toSeq(1..5)
# echo toSeq(0.0..10.0)
# echo toSeq(arange(0.0, 20.0, 3.0))
# echo toSeq(linspace(0.0, 10.0, 9))

set_style(Points)

cmd "set yrange[-0.5: 1]"
plot arange(0.0, 10.0, 1.25), repeat(0.5, 9) # ranges are inclusive
plot linspace(0.0, 10.0, 8), repeat(0, 8)
discard readChar stdin
