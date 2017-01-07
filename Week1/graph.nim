import tables, hashes

# ------------------
# Node type routines
# ------------------

type
  Node = object
    name: string


proc newNode(name: string): Node =
  result = Node(name: name)

proc getName(n: Node): string =
  result = n.name

proc hash(n: Node): Hash =
  result = hash(n.name)
  result = !$result

proc `$`(n: Node): string =
  result = n.name

# ------------------
# Edge type routines
# ------------------

type
  Edge = object
    src, dest: Node


proc newEdge(src, dest: Node): Edge =
  result = Edge(src: src, dest: dest)

proc getSource(e: Edge): Node =
  result = e.src

proc getDestination(e: Edge): Node =
  result = e.dest

proc `$`(e: Edge): string =
  result = $e.src & "->" & $e.dest

# ---------------------
# Digraph type routines
# ---------------------

type
  Digraph = object
    edges: Table[Node, seq[Node]]


template exists(key: untyped): untyped {.dirty.} =
  d.edges.hasKey(key)

template modify(key: untyped): untyped {.dirty.} =
  d.edges[key]

template `!`(field: untyped): untyped {.dirty.} =
  edge.field

proc newDigraph(): Digraph =
  result = Digraph(edges: initTable[Node, seq[Node]]())

proc addNode(d: var Digraph; node: Node) =
  if exists(node):
    raise newException(ValueError, "Duplicate node")
  modify(node) = @[]

proc addEdge(d: var Digraph; edge: Edge) =
  if not (exists(!src) and exists(!dest)):
    raise newException(ValueError, "Node not in graph")
  modify(!src).add(!dest)
