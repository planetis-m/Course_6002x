import math, random, strutils

type Function = proc(x: float): float

proc simpson(f: Function; a, b: float; n: int): float =
   assert(n mod 2 == 0, "number of steps must be even")
   let h = (b - a) / float(n)
   var s = f(a) + f(b)
   for i in countup(1, n-1, 2):
      s += 4.0 * f(a + float(i) * h)
   for i in countup(2, n-2, 2):
      s += 2.0 * f(a + float(i) * h)
   result = s * h / 3.0

proc gaussian(x, mu, sigma: float): float =
   let factor1 = 1.0/(sigma*sqrt(2.0*Pi))
   let factor2 = exp(-pow(x-mu, 2.0)/(2.0*pow(sigma, 2.0)))
   result = factor1 * factor2

proc checkEmpirical(numTrials: int) =
   proc ff(f: float): string = formatFloat(f, ffDecimal, 4)
   proc randz(a, b: int): float = float(rand(b - a) + a)
   for t in 1 .. numTrials:
      let mu = randz(-10, 10)
      let sigma = randz(1, 10)
      echo("For mu = ", mu, " and sigma = ", sigma)
      for numStd in [1.0, 1.96, 3.0]:
         let area = simpson(proc (x: float): float = gaussian(x, mu, sigma),
                            mu-numStd*sigma,
                            mu+numStd*sigma, 20)
         echo("  Fraction within ", numStd, " std = ", ff(area))

checkEmpirical(3)
