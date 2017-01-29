import gnuplot, math

var
  samples = newSeq[float]()
  linear = newSeq[float]()
  quadratic = newSeq[float]()
  cubic = newSeq[float]()
  exponential = newSeq[float]()

iterator rangeFloat(a, b: float, step = 1.0): float =
  var res = a
  while res <= b:
    yield res
    res += step


for i in rangeFloat(0.0, 29.0):
  samples.add i
  linear.add i
  quadratic.add pow(i, 2.0)
  cubic.add pow(i, 3.0)
  exponential.add pow(1.5, i)

plot(samples, linear, "Linear Plot")
plot(samples, quadratic, "Quadratic Plot")
plot(samples, cubic, "Cubic Plot")
plot(samples, exponential, "Exponential Plot")

discard readChar stdin
