import gnuplot_wrapper, math, sequtils, os

let
  samples = toSeq(0..29)
  linear = toSeq(0..29)
  quadratic = toSeq(0..29).mapIt(it^2)
  cubic = toSeq(0..29).mapIt(it^3)
  exponential = toSeq(0..29).mapIt(pow(1.5, it.float))

cmd "set multiplot layout 2, 2"
cmd "set style data lines"

plot(samples, linear, "Linear Plot")
plot(samples, quadratic, "Quadratic Plot", false)
plot(samples, cubic, "Cubic Plot", false)
plot(samples, exponential, "Exponential Plot", false)

cmd "unset multiplot"