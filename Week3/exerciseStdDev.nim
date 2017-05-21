import math


proc stdDevOfLengths(a: openArray[string]): float =
  # a: a list of strings

  # returns: float, the standard deviation of the lengths of the strings,
  #  or NaN if L is empty.

  if a.len == 0:
    return NaN
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


echo stdDevOfLengths([])
echo stdDevOfLengths(["a", "z", "p"])
echo stdDevOfLengths(["apples", "oranges", "kiwis", "pineapples"])
