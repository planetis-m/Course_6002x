import math


proc stdDevOfLengths(a: openArray[string]): float =
  ## returns: float, the standard deviation of the lengths of the strings,
  assert a.len != 0
  # compute mean first
  var sumVals = 0
  for s in a:
    sumVals += len(s)
  let meanVals = sumVals / len(a)
  # compute variance (average squared deviation from mean)
  var sumDevSquared = 0.0
  for s in a:
    sumDevSquared += pow(len(s).float - meanVals, 2.0)
  let variance = sumDevSquared / len(a).float
  # standard deviation is the square root of the variance
  pow(variance, 0.5)


template testFloatRes(retValue, expValue: typed): untyped =
  const E = 1e-6
  assert abs(retValue - expValue) < E

testFloatRes(stdDevOfLengths(["a", "z", "p"]), 0.0)
testFloatRes(stdDevOfLengths(["apples", "oranges", "kiwis", "pineapples"]), 1.870828693)
testFloatRes(stdDevOfLengths(["dafcymuwe", "niuxmesszqejlo"]), 2.5)
