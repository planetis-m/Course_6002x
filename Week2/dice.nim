import random, math

# randomize()

proc rollDie(): int =
   ## returns a random int between 1 and 6
   random([1,2,3,4,5,6])

proc testRoll(n = 10) =
   var res = ""
   for i in 0 .. <n:
      res &= $rollDie()
   echo res

proc runSim(goal, numTrials: int) =
   var total = 0
   for i in 1 .. numTrials:
      var res = ""
      for j in 1 .. len($goal):
         res &= $rollDie()
      if res == $goal:
         total += 1
   echo("Actual probability = ",
         round(1/(6^len($goal)), 8))
   let estProbability = round(total/numTrials, 8)
   echo("Estimated Probability = ", estProbability)

runSim(11111, 1_000_000)

proc fracBoxCars(numTests: int): float =
   var numBoxCars = 0
   for i in 1 .. numTests:
      if rollDie() == 6 and rollDie() == 6:
         numBoxCars += 1
   return numBoxCars/numTests

echo("Frequency of double 6 = ",
     fracBoxCars(100_000)*100, "%")
