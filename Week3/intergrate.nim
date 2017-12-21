import math, random, strutils

type
   Function = proc(x: float): float
   Rule = proc(f: Function; x, h: float): float

proc trapezium(f: Function; x, h: float): float =
   result = (f(x) + f(x+h)) / 2.0

proc simpson(f: Function, x, h: float): float =
   result = (f(x) + 4.0*f(x+h/2.0) + f(x+h)) / 6.0

proc integrate(f: Function; a, b: float; steps: int; meth: Rule): float =
   let h = (b - a) / float(steps)
   for i in 0 ..< steps:
      result += meth(f, a + float(i)*h, h)
   result = h * result

proc gaussian(x, mu, sigma: float): float =
   let factor1 = 1.0/(sigma*sqrt(2.0*Pi))
   let factor2 = exp(-pow(x-mu, 2.0)/(2.0*sigma*sigma))
   result = factor1 * factor2

proc checkEmpirical(numTrials: int) =
   template ff(f: float): string = formatFloat(f, ffDecimal, 4)
   template randz(a, b: int): float = float(rand(b - a) + a)
   for t in 1 .. numTrials:
      let mu = randz(-10, 10)
      let sigma = randz(1, 10)
      echo("For mu = ", mu, " and sigma = ", sigma)
      for numStd in [1.0, 1.96, 3.0]:
         let area = integrate(proc (x: float): float = gaussian(x, mu, sigma),
                              mu-numStd*sigma,
                              mu+numStd*sigma, 50, simpson)
         echo("  Fraction within ", numStd, " std = ", ff(area))

checkEmpirical(3)
