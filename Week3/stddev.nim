import math

type
   Deviator = object
      n: int
      mom1, mom2: float

proc add(s: var Deviator; x: float) =
   inc(s.n)
   let delta = x - s.mom1
   let delta_n = delta / float(s.n)
   let term1 = delta * delta_n * float(s.n - 1)
   s.mom2 += term1
   s.mom1 += delta_n

proc getMeanAndStd*(x: openarray[float]): auto =
   var d: Deviator
   for val in x:
      d.add(val)
   let mean = d.mom1
   let std = sqrt(d.mom2 / float(d.n))
   (mean, std)
