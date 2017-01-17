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
  Digraph = ref object of RootObj
    edges: Table[Node, seq[Node]]
  Graph = ref object of Digraph

proc initGraph(T: typedesc[Graph | Digraph]): T =
  result = T(edges: initTable[Node, seq[Node]]())

# ---------------------
# Digraph type routines
# ---------------------

proc addNode(d: Digraph; node: Node) =
  if d.edges.hasKey(node):
    raise newException(ValueError, "Duplicate node")
  d.edges[node] = @[]

proc addEdge(d: Digraph; edge: Edge) =
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

proc addEdge(g: Graph; edge: Edge) =
  Digraph(g).addEdge(edge)
  let rev = initEdge(edge.dest, edge.src)
  Digraph(g).addEdge(rev)


proc `$`[T](path: seq[T]): string =
  result = ""
  for i in 0 .. <path.len:
    result &= $path[i]
    if i != len(path) - 1:
      result &= "->"

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
  result.addEdge(initEdge(initNode("Chicago"), initNode("Phoenix")))
  result.addEdge(initEdge(initNode("Chicago"), initNode("Denver")))
  result.addEdge(initEdge(initNode("Denver"), initNode("Phoenix")))
  result.addEdge(initEdge(initNode("Denver"), initNode("New York")))
  result.addEdge(initEdge(initNode("Los Angeles"), initNode("Boston")))


proc dfs(graph: Digraph; start, finish: Node; path, shortest = newSeq[Node]()): seq[Node] =
  var path = path & @[start]
  var shortest = shortest
  echo("Current DFS path: ", path)
  if start == finish:
    return path
  for node in graph.childrenOf(start):
    if $start == "Boston": echo node
    if node notin path:
      if $start == "Boston": echo node
      if len(shortest) == 0 or len(path) < len(shortest):
        let newPath = dfs(graph, node, finish, path, shortest)
        if newPath.len != 0:
          shortest = newPath
    else:
      echo("Already visited ", node)
  result = shortest

proc shortestPath(graph: Digraph; start, finish: Node): seq[Node] =
  result = dfs(graph, start, finish)

proc testSP(source, destination: string) =
  let g = buildCityGraph(Digraph)
  let sp = shortestPath(g, initNode(source), initNode(destination))
  if len(sp) != 0:
    echo("Shortest path from ", source, " to ",
         destination, " is ", sp)
  else:
    echo("There is no path from ", source, " to ", destination)

testSP("Boston", "Phoenix")
# Correct: Boston->New York->Chicago->Phoenix
