import random, math, strutils

# randomize()
type DiceFace = range[1 .. 6]

template ff(f: float, prec: int = 3): string =
   formatFloat(f, ffDecimal, prec)

proc rollDie(): DiceFace =
   ## returns a random int between 1 and 6
   rand(1 .. 6)

proc testRoll(n = 10) =
   var res = ""
   for i in 1 .. n:
      res.add $rollDie()
   echo res

proc runSim(goal: string, numTrials: int) =
   var total = 0
   for i in 1 .. numTrials:
      var res = ""
      for j in 1 .. len(goal):
         res.add $rollDie()
      if res == goal:
         total += 1
   echo("Actual probability = ", ff(1/(6^len(goal)), 8))
   echo("Estimated Probability = ", ff(total/numTrials, 8))

runSim("11111", 1_000_000)

proc fracBoxCars(numTests: int): float =
   var numBoxCars = 0
   for i in 1 .. numTests:
      if rollDie() == 6 and rollDie() == 6:
         numBoxCars.inc
   return numBoxCars/numTests

echo("Frequency of double 6 = ", fracBoxCars(100_000)*100, "%")
