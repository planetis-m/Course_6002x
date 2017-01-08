import tables, hashes

type
  Node = object
    name: string

# ------------------
# Node type routines
# ------------------

proc initNode(name: string): Node =
  result = Node(name: name)

proc getName(n: Node): string =
  result = n.name

proc hash(n: Node): Hash =
  result = hash(n.name)
  result = !$result

proc `$`(n: Node): string =
  result = n.name


type
  Edge = object
    src, dest: Node

# ------------------
# Edge type routines
# ------------------

proc initEdge(src, dest: Node): Edge =
  result = Edge(src: src, dest: dest)

proc getSource(e: Edge): Node =
  result = e.src

proc getDestination(e: Edge): Node =
  result = e.dest

proc `$`(e: Edge): string =
  result = $e.src & "->" & $e.dest


type
  Digraph = object of RootObj
    edges: Table[Node, seq[Node]]
  Graph = object of Digraph

# ---------------------
# Digraph type routines
# ---------------------

proc addNode(d: var Digraph; node: Node) =
  if d.edges.hasKey(node):
    raise newException(ValueError, "Duplicate node")
  d.edges[node] = @[]

proc addEdge[T: Digraph](d: var T; edge: Edge) =
  if not (d.edges.hasKey(edge.src) and d.edges.hasKey(edge.dest)):
    raise newException(ValueError, "Node not in graph")
  d.edges[edge.src].add(edge.dest)

proc childrenOf(d: Digraph; node: Node): seq[Node] =
  assert d.edges.hasKey(node)
  result = d.edges[node]

proc hasNode(d: Digraph; node: Node): bool =
  result = d.edges.hasKey(node)

proc getNode(d: Digraph; name: string): Node =
  let n = initNode(name)
  assert d.edges.hasKey(n)
  result = n

proc `$`(d: Digraph): string =
  result = ""
  for src, dests in d.edges:
    for dest in dests:
      result &= $src & "->" & $dest & "\n"

# -------------------
# Graph type routines
# -------------------

proc initGraph(T: typedesc[Graph | Digraph]): T =
  result = T(edges: initTable[Node, seq[Node]]())

proc addEdge(g: var Graph; edge: Edge) =
  addEdge[Digraph](g, edge)
  let rev = initEdge(edge.dest, edge.src)
  addEdge[Digraph](g, rev)

proc `$`(g: Graph): string =
  result = ""
  for src, dests in g.edges:
    for dest in dests:
      result &= $src & "->" & $dest & "\n"


proc buildCityGraph(T: typedesc[Graph | Digraph]): T =
  result = initGraph(T)
  for name in ["Boston", "Providence", "New York", "Chicago",
              "Denver", "Phoenix", "Los Angeles"]:
    result.addNode(initNode(name))

  result.addEdge(initEdge(initNode("Boston"), initNode("Providence")))
  result.addEdge(initEdge(initNode("Boston"), initNode("New York")))
  result.addEdge(initEdge(initNode("Providence"), initNode("Boston")))
  result.addEdge(initEdge(initNode("Providence"), initNode("New York")))
  result.addEdge(initEdge(initNode("New York"), initNode("Chicago")))
  result.addEdge(initEdge(initNode("Chicago"), initNode("Denver")))
  result.addEdge(initEdge(initNode("Denver"), initNode("Phoenix")))
  result.addEdge(initEdge(initNode("Denver"), initNode("New York")))
  result.addEdge(initEdge(initNode("Los Angeles"), initNode("Boston")))

echo buildCityGraph(Digraph)
