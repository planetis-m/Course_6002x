import math

iterator get_partitions_ordered*[T](s: openArray[T]): seq[seq[T]] =
  # http://stackoverflow.com/a/25460561/
  let n = len(s)-1
  for partition_index in 0 .. <(2 ^ n):
    # current partition, e.g., [['a', 'b'], ['c', 'd', 'e']]
    var partition = newSeq[seq[T]]()
    # used to accumulate the subsets, e.g., ['a', 'b']
    var subset = newSeq[T]()
    for position in 0 .. n:
      subset.add(s[position])
      # check whether to "break off" a new subset
      if (1 shl position and partition_index) > 0 or position == n:
        partition.add(subset)
        subset.setLen(0)
    yield partition

iterator get_partitions*[T](s: openArray[T]): seq[seq[T]] =
  # http://stackoverflow.com/a/41499670/
  var lists = newSeq[seq[T]]()
  var indexes = newSeq[int](len(s))
  lists.add(@s)
  block outer:
    while true:
      yield lists
      var index = 0
      var i = indexes.len - 1
      while true:
        if i <= 0:
          break outer
        index = indexes[i]
        discard lists[index].pop
        if lists[index].len > 0:
          break
        discard lists.pop
        dec(i)
      inc(index)
      if index >= lists.len:
        lists.add(newSeq[T]())
      while i < indexes.len:
        indexes[i] = index
        lists[index].add(s[i])
        index = 0
        inc(i)

when isMainModule:
  for elt in get_partitions(['a', 'b', 'c', 'd']):
    echo elt
