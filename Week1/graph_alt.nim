import tables, hashes, deques

type
   Node = object
      name: string

# ------------------
# Node type routines
# ------------------

proc initNode(name: string): Node =
   result.name = name

proc getName(n: Node): string =
   result = n.name

proc hash(n: Node): Hash =
   result = hash(n.name)

proc `$`(n: Node): string =
   result = n.name

type
   Edge = object
      src, dest: Node

# ------------------
# Edge type routines
# ------------------

proc initEdge(src, dest: Node): Edge =
   result.src = src
   result.dest = dest

proc getSource(e: Edge): Node =
   result = e.src

proc getDestination(e: Edge): Node =
   result = e.dest

proc `$`(e: Edge): string =
   result = $e.src & "->" & $e.dest

type
   Digraph = ref object of RootObj
      edges: Table[Node, Node]

   Graph = ref object of Digraph

# ---------------------
# Digraph type routines
# ---------------------

proc initGraph(T: typedesc[Graph | Digraph]): T =
   new(result)
   result.edges = initTable[Node, Node]()

proc addEdge(d: Digraph; edge: Edge) =
   d.edges.add(edge.src, edge.dest)

iterator childrenOf(d: Digraph; node: Node): Node =
   for dest in d.edges.allValues(node):
      yield dest

proc hasNode(d: Digraph; node: Node): bool =
   result = d.edges.hasKey(node)

proc getNode(d: Digraph; name: string): Node =
   for n in keys(d.edges):
      if n.getName() == name:
         return n
   raise newException(KeyError, "No node found with name")

proc `$`(d: Digraph): string =
   result = ""
   for src, dest in d.edges:
      result.add($src & "->" & $dest & "\n")

# -------------------
# Graph type routines
# -------------------

proc addEdge(g: Graph; edge: Edge) =
   Digraph(g).addEdge(edge)
   let rev = initEdge(edge.dest, edge.src)
   Digraph(g).addEdge(rev)

proc `$`[T](path: seq[T]): string =
   result = ""
   for i in 0 ..< path.len:
      result.add($path[i])
      if i != len(path) - 1:
         result.add("->")

proc buildCityGraph(T: typedesc[Graph | Digraph]): T =
   result = initGraph(T)
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
   var path = path
   path.add(start)
   var shortest = shortest
   echo("Current DFS path: ", path)
   if start == finish:
      return path
   for node in graph.childrenOf(start):
      if node notin path:
         if len(shortest) == 0 or len(path) < len(shortest):
            let newPath = dfs(graph, node, finish, path, shortest)
            if newPath.len != 0:
               shortest = newPath
      else:
         echo("Already visited ", node)
   result = shortest

proc bfs(graph: Digraph, start, finish: Node): seq[Node] =
   ## Returns a shortest path from start to end in graph
   result = @[]
   var initPath = @[start]
   var pathQueue = initDeque[seq[Node]]()
   pathQueue.addFirst(initPath)
   while len(pathQueue) != 0:
      #Get and remove oldest element in pathQueue
      let tmpPath = pathQueue.popFirst()
      echo("Current BFS path: ", tmpPath)
      let lastNode = tmpPath[^1]
      if lastNode == finish:
         return tmpPath
      for nextNode in graph.childrenOf(lastNode):
         if nextNode notin tmpPath:
            var newPath = tmpPath
            newPath.add(nextNode)
            pathQueue.addLast(newPath)

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
