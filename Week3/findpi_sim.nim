import random, math, strutils
import stddev

template ff(f: float, prec: int = 3): string =
   formatFloat(f, ffDecimal, prec)

proc throwNeedles(numNeedles: int): float =
   var inCircle = 0
   for t in 1 .. numNeedles:
      let x = rand(1.0)
      let y = rand(1.0)
      if sqrt(x*x + y*y) <= 1.0:
         inc(inCircle)
   4.0*(inCircle/numNeedles)

proc getEst(numNeedles, numTrials: int): (float, float) =
   var estimates: seq[float] = @[]
   for t in 1 .. numTrials:
      let piGuess = throwNeedles(numNeedles)
      estimates.add(piGuess)
   let (curEst, sDev) = getMeanAndStd(estimates)
   echo("Est. = " & $curEst & ", Std. dev. = " & $ff(sDev, 6) &
        ", Needles = " & $numNeedles)
   (curEst, sDev)

proc estPi(precision: float; numTrials: int): float =
   var numNeedles = 1000
   var sDev = precision
   var curEst = 0.0
   while sDev >= precision/1.96:
      (curEst, sDev) = getEst(numNeedles, numTrials)
      numNeedles *= 2
   curEst

#randomize()
discard estPi(0.005, 100)
