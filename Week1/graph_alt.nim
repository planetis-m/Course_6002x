import macros, tables, hashes, deques

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
   Digraph = object
      edges: Table[Node, Node]

# ---------------------
# Digraph type routines
# ---------------------

proc initGraph(): Digraph =
   result.edges = initTable[Node, Node]()

proc addEdge(d: var Digraph; edge: Edge) =
   d.edges.add(edge.src, edge.dest)

iterator childrenOf(d: Digraph; node: Node): Node =
   for dest in d.edges.allValues(node):
      yield dest

proc hasNode(d: var Digraph; node: Node): bool =
   d.edges.hasKey(node)

proc getNode(d: Digraph; name: string): Node =
   for n in keys(d.edges):
      if n.getName() == name:
         return n
   raise newException(KeyError, "No node found with name")

proc `$`(d: Digraph): string =
   result = ""
   for src, dest in d.edges:
      result.add($src & "->" & $dest & "\n")

proc `$`(path: seq[Node]): string =
   result = ""
   for i in 0 ..< path.len:
      result.add($path[i])
      if i != len(path) - 1:
         result.add("->")

proc graphDslImpl(head, body: NimNode): NimNode =
   template adder(graph, src, dest): untyped =
      graph.addEdge(initEdge(initNode(src), initNode(dest)))

   if body.kind == nnkInfix and $body[0] == "->":
      result = getAst(adder(head, body[1], body[2]))
   elif body.kind == nnkInfix and $body[0] == "--":
      result = newStmtList()
      result.add getAst(adder(head, body[1], body[2]))
      result.add getAst(adder(head, body[2], body[1]))
   else:
      result = copyNimNode(body)
      for n in body:
         result.add graphDslImpl(head, n)

macro edges(head, body: untyped): untyped =
   result = graphDslImpl(head, body)
   echo result.repr

proc buildCityGraph(): Digraph =
   result = initGraph()
   edges(result):
      "Boston" -- "Providence"
      "Boston" -> "New York"
      "Providence" -> "New York"
      "New York" -> "Chicago"
      "Chicago" -> "Denver"
      "Denver" -> "Phoenix"
      "Denver" -> "New York"
      "Los Angeles" -> "Boston"

proc dfs(graph: Digraph; start, finish: Node; path, shortest = newSeq[Node]()): seq[Node] =
   var shortest = shortest
   var path = path
   path.add(start)
   echo("Current DFS path: ", path)
   if start == finish:
      return path
   for node in graph.childrenOf(start):
      # echo path
      if node notin path:
         if len(shortest) == 0 or len(path) < len(shortest):
            let newPath = dfs(graph, node, finish, path, shortest)
            if newPath.len != 0:
               shortest = newPath
      else:
         echo("Already visited ", node)
   shortest

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
   dfs(graph, start, finish)

proc testSP(source, destination: string) =
   let g = buildCityGraph()
   let sp = shortestPath(g, initNode(source), initNode(destination))
   if len(sp) != 0:
      echo("Shortest path from ", source, " to ",
           destination, " is ", sp)
   else:
      echo("There is no path from ", source, " to ", destination)

# testSP("Chicago", "Boston")
testSP("Boston", "Phoenix")
# Correct: Boston->New York->Chicago->Denver->Phoenix
