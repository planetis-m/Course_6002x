import tables

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


proc newDigraph(): Digraph =
  result = Digraph(edges: initTable[Node, seq[Node]]())

proc addNode(d: var Digraph; node: Node) =
  if d.edges.hasKey(node):
    raise newException(ValueError, "Duplicate node")
  d.edges[node] = @[]

proc addEdge(d: var Digraph; edge: Edge) =
  if not (d.edges.hasKey(edge.src) and d.edges.hasKey(edge.dest)):
    raise newException(ValueError, "Node not in graph")
  d.edges[edge.src].add(edge.dest)
