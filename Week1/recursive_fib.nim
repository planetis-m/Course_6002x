import tables, bigints

proc fib(x: Natural; store = {0:0.initBigInt, 1:1.initBigInt}.newTable): BigInt =
  #
  # assumes x an int >= 0
  #
  # returns Fibonacci of x
  #
  if store.hasKey(x):
    result = store[x]
  else:
    result = fib(x - 1, store) + fib(x - 2, store)
    store[x] = result

# Iterative is 2x faster
proc fibs(x: Natural): BigInt =
  var
    a = 0.initBigInt
    b = 1.initBigInt
  for i in 2 .. x:
    let tmp = a + b
    a = b
    b = tmp
  return b

echo fib(100000)
