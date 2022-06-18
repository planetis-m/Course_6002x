
iterator partitionsOrdered*[T](s: openArray[T]): seq[seq[T]] =
   # http://stackoverflow.com/a/25460561/
   let n = len(s) - 1
   for partitionIndex in 0 ..< 1 shl n: # 2 ^ n
      # current partition, e.g., [['a', 'b'], ['c', 'd', 'e']]
      var partition = newSeq[seq[T]]()
      # used to accumulate the subsets, e.g., ['a', 'b']
      var subset = newSeq[T]()
      for position in 0 .. n:
         subset.add(s[position])
         # check whether to "break off" a new subset
         if (1 shl position and partitionIndex) > 0 or position == n:
            partition.add(subset)
            subset.shrink(0)
      yield partition

iterator partitions*[T](s: openArray[T]): seq[seq[T]] =
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
   var result1: seq[seq[seq[char]]]
   for elt in partitionsOrdered(['a', 'b', 'c', 'd']):
      result1.add elt
   assert result1 == @[
      @[@['a', 'b', 'c', 'd']],
      @[@['a'], @['b', 'c', 'd']],
      @[@['a', 'b'], @['c', 'd']],
      @[@['a'], @['b'], @['c', 'd']],
      @[@['a', 'b', 'c'], @['d']],
      @[@['a'], @['b', 'c'], @['d']],
      @[@['a', 'b'], @['c'], @['d']],
      @[@['a'], @['b'], @['c'], @['d']]]
   var result2: seq[seq[seq[char]]]
   for elt in partitions(['a', 'b', 'c', 'd']):
      result2.add elt
   assert result2 == @[
      @[@['a', 'b', 'c', 'd']],
      @[@['a', 'b', 'c'], @['d']],
      @[@['a', 'b', 'd'], @['c']],
      @[@['a', 'b'], @['c', 'd']],
      @[@['a', 'b'], @['c'], @['d']],
      @[@['a', 'c', 'd'], @['b']],
      @[@['a', 'c'], @['b', 'd']],
      @[@['a', 'c'], @['b'], @['d']],
      @[@['a', 'd'], @['b', 'c']],
      @[@['a'], @['b', 'c', 'd']],
      @[@['a'], @['b', 'c'], @['d']],
      @[@['a', 'd'], @['b'], @['c']],
      @[@['a'], @['b', 'd'], @['c']],
      @[@['a'], @['b'], @['c', 'd']],
      @[@['a'], @['b'], @['c'], @['d']]]
