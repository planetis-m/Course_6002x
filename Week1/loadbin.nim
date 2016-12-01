import os, posix

type
  Item = ptr array[0..3, char]
  DataArray {.unchecked.} = array[0..0, Item]
  DataPtr = ptr DataArray

type
  DataSafe = object
    when not defined(release):
      size: int
    mem: DataPtr

proc safe(p: DataPtr, s: int): DataSafe =
  when defined(release):
    DataSafe(mem: p)
  else:
    DataSafe(mem: p, size: s)

proc `[]`(p: DataSafe, i: int): Item =
  when not defined(release):
    assert i < p.size
  result = p.mem[][i]


var f = open("data", fmRead)

var a = cast[DataPtr](mmap(nil, 4096, PROT_READ, MAP_PRIVATE, getFileHandle(f), 0))

var data = safe(a, 100)
echo data[21][]

discard munmap(a, 4096)
close(f)
