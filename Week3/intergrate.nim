import math, random, strutils

type Func = proc(x: float): float

proc simpson*(f: Func; a, b: float; n: int): float =
   assert n mod 2 == 0, "number of steps must be even"
   let h = (b - a) / float(n)
   let h1 = h / 3.0
   var sum = f(a) + f(b)
   var j = 3 * n - 1
   while j > 0:
      let l1 = if (j mod 3) > 0: 3.0 else: 2.0
      sum += l1 * f(a + h1 * float(j))
      dec(j)
   h * sum / 8.0

proc gaussian(x, mu, sigma: float): float =
   let factor1 = 1.0/(sigma*sqrt(2.0*Pi))
   let factor2 = exp(-pow(x-mu, 2.0)/(2.0*pow(sigma, 2.0)))
   result = factor1 * factor2

proc checkEmpirical(numTrials: int) =
   template ff(f): string = formatFloat(f, ffDecimal, 4)
   for t in 1 .. numTrials:
      let mu = float(rand(-10 .. 10))
      let sigma = float(rand(1 .. 10))
      echo("For mu = ", mu, " and sigma = ", sigma)
      for numStd in [1.0, 1.96, 3.0]:
         let area = simpson(proc (x: float): float = gaussian(x, mu, sigma),
                            mu-numStd*sigma,
                            mu+numStd*sigma, 20)
         echo("  Fraction within ", numStd, " std = ", ff(area))

checkEmpirical(3)
