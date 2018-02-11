import math, random, strutils

type Func = proc(x: float): float

proc integrate(f: Func; a, b, epsilon = 1e-8; maxRecursionDepth = 20): float =
   proc adsimp(f: Func; a, b, epsilon, s, fa, fb, fc: float; bottom: int): float =
      let
         c = (a + b)/2
         h = b - a
         d = (a + c)/2
         e = (c + b)/2
         fd = f(d)
         fe = f(e)
         sLeft = (h/12)*(fa + 4*fd + fc)
         sRight = (h/12)*(fc + 4*fe + fb)
         s2 = sLeft + sRight
      if bottom <= 0 or abs(s2 - s) <= 15*epsilon:   # magic 15 comes from error analysis
         return s2 + (s2 - s)/15
      result = adsimp(f, a, c, epsilon/2, sLeft,  fa, fc, fd, bottom-1) +
               adsimp(f, c, b, epsilon/2, sRight, fc, fb, fe, bottom-1)
   let
      c = (a + b)/2
      h = b - a
      fa = f(a)
      fb = f(b)
      fc = f(c)
      s = (h/6)*(fa + 4*fc + fb)
   result = adsimp(f, a, b, epsilon, s, fa, fb, fc, maxRecursionDepth)

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
         let area = integrate(proc (x: float): float = gaussian(x, mu, sigma),
                              mu-numStd*sigma,
                              mu+numStd*sigma, 0.001)
         echo("  Fraction within ", numStd, " std = ", ff(area))

checkEmpirical(3)
