import tables, hashes, math, random


type
   Location = object
      x, y: float

# ----------------------
# Location type routines
# ----------------------

proc initLocation(x, y: float): Location =
   result = Location(x: x, y: y)

proc hash(self: Location): Hash =
   result = hash(self.x) !& hash(self.y)
   result = !$result

proc getX(self: Location): float =
   result = self.x

proc getY(self: Location): float =
   result = self.y

proc `$`(self: Location): string =
   result = "<" & $self.x & ", " & $self.y & ">"

proc move(self: Location; deltaX, deltaY: float): Location =
   result = Location(x: self.x + deltaX, y: self.y + deltaY)

proc distFrom(self, other: Location): float =
   let xDist = self.x - other.x
   let yDist = self.y - other.y
   sqrt(pow(xDist, 2.0) + pow(yDist, 2.0))

type
   DrunkKind = enum
      UsualDk = "Usual Drunk"
      ColdDk = "Cold Drunk"
   Drunk = object
      name: string
      stepChoices: array[4, (float, float)]

# -------------------
# Drunk type routines
# -------------------

proc initDrunk(dEnum: DrunkKind; name: string): Drunk =
   case dEnum
   of UsualDk:
      result.stepChoices = [(0.0, 1.0), (0.0, -1.0), (1.0, 0.0), (-1.0, 0.0)]
   of ColdDk:
      result.stepChoices = [(0.0, 0.9), (0.0, -1.1), (1.0, 0.0), (-1.0, 0.0)]
   result.name = name

proc hash(self: Drunk): Hash =
   result = hash(self.name)
   result = !$result

proc `$`(self: Drunk): string =
   result = "This drunk is named " & self.name

proc takeStep(self: Drunk): auto =
   result = random(self.stepChoices)


type
   FieldKind = enum
      NormalFk, OddFk
   Field = ref object
      drunks: Table[Drunk, Location]
      case kind: FieldKind
      of OddFk:
         wormholes: Table[Location, Location]
      else:
         discard

# -------------------
# Field type routines
# -------------------

proc newField(): Field =
   new(result)
   result.drunks = initTable[Drunk, Location]()
   result.kind = NormalFk

proc newOddField(numHoles = 1000, xRange = 100, yRange = 100): Field =
   new(result)
   result.drunks = initTable[Drunk, Location]()
   result.kind = OddFk
   result.wormholes = initTable[Location, Location]()
   for w in 1 .. numHoles:
      let
         x = random(-xRange..xRange+1)
         y = random(-yRange..yRange+1)
         newX = random(-xRange..xRange+1)
         newY = random(-yRange..yRange+1)
         loc = initLocation(x.float, y.float)
         newLoc = initLocation(newX.float, newY.float)
      result.wormholes[loc] = newLoc

proc addDrunk(self: Field; drunk: Drunk; loc: Location) =
   if self.drunks.hasKey(drunk):
      raise newException(ValueError, "Duplicate drunk")
   self.drunks[drunk] = loc

proc getLoc(self: Field; drunk: Drunk): Location =
   if not self.drunks.hasKey(drunk):
      raise newException(ValueError, "Drunk not in field")
   result = self.drunks[drunk]

proc moveDrunk(self: Field; drunk: Drunk) =
   if not self.drunks.hasKey(drunk):
      raise newException(ValueError, "Drunk not in field")
   let (xDist, yDist) = drunk.takeStep()
   let currentLocation = self.drunks[drunk]
   self.drunks[drunk] = currentLocation.move(xDist, yDist)
   if self.kind == OddFk:
      let loc = self.drunks[drunk]
      if self.wormholes.hasKey(loc):
         self.drunks[drunk] = self.wormholes[loc]

# -------------------
# Simulation routines
# -------------------

proc walk(f: Field; d: Drunk; numSteps: int): float =
   ## Moves d numSteps times, and returns the distance between
   ## the final location and the location at the start of the walk.
   let start = f.getLoc(d)
   for s in 1 .. numSteps:
      f.moveDrunk(d)
   result = start.distFrom(f.getLoc(d))

proc simWalks(numSteps, numTrials: int; dEnum: DrunkKind): seq[float] =
   ## Simulates numTrials walks of numSteps steps each.
   ## Returns a list of the final distances for each trial
   let homer = initDrunk(dEnum, "Homer")
   let origin = initLocation(0.0, 0.0)
   result = @[]
   for t in 1 .. numTrials:
      let f = newField()
      f.addDrunk(homer, origin)
      result.add(round(walk(f, homer, numSteps), 1))

proc drunkTest(walkLengths: openarray[int]; numTrials: int; dEnum: DrunkKind) =
   ## For each number of steps in walkLengths, runs simWalks with
   ## numTrials walks and prints results
   for numSteps in walkLengths:
      let distances = simWalks(numSteps, numTrials, dEnum)
      echo(dEnum, " random walk of ", numSteps, " steps")
      echo(" Mean = ", round(sum(distances)/len(distances).float, 1))
      echo(" Max = ", max(distances), " Min = ", min(distances))

# drunkTest([10, 1000, 1000, 10000], 100, UsualDk)

proc simAll(drunkKinds: set[DrunkKind], walkLengths: openarray[int], numTrials: int) =
   for dEnum in drunkKinds:
      drunkTest(walkLengths, numTrials, dEnum)

# simAll({UsualDk, ColdDk},
#        [1, 10, 100, 1000, 10000], 100)

template writeData(f: File; a, b: typed) =
   for i in 0 .. high(a):
      f.writeLine(a[i], " ", b[i])
   f.write("\n\n")

proc simDrunk(walkLengths: openarray[int]; numTrials: int; dEnum: DrunkKind): seq[float] =
   ## Same as drunkTest, returns the mean of the trials
   result = @[]
   for numSteps in walkLengths:
      echo("Starting simulation of ", numSteps, " steps")
      let trials = simWalks(numSteps, numTrials, dEnum)
      let mean = sum(trials)/len(trials).float
      result.add(mean)

proc simAllToFile(drunkKinds: set[DrunkKind], walkLengths: openarray[int], numTrials: int) =
   let fs = open("plotting-means.dat", fmWrite)
   for dEnum in drunkKinds:
      echo("Starting simulation of ", dEnum)
      let means = simDrunk(walkLengths, numTrials, dEnum)
      fs.writeData(walkLengths, means)
   fs.close()

# simAllToFile({UsualDk, ColdDk},
#              [1, 10, 100, 1000, 10000], 100)

proc getFinalLocs(numSteps, numTrials: int; dEnum: DrunkKind): seq[Location] =
   result = @[]
   let d = initDrunk(dEnum, "Homer")
   let origin = initLocation(0.0, 0.0)
   for t in 1 .. numTrials:
      let f = newField()
      f.addDrunk(d, origin)
      for s in 1 .. numSteps:
         f.moveDrunk(d)
      result.add(f.getLoc(d))

proc plotLocs(drunkKinds: set[DrunkKind], numSteps, numTrials: int) =
   let fs = open("plotting-locations.dat", fmWrite)
   for dEnum in drunkKinds:
      let locs = getFinalLocs(numSteps, numTrials, dEnum)
      var xVals, yVals = newSeq[float]()
      for loc in locs:
         xVals.add(loc.getX)
         yVals.add(loc.getY)
      # let meanX = sum(abs(xVals))/len(xVals).float
      # let meanY = sum(abs(yVals))/len(yVals).float
      fs.writeData(xVals, yVals)
   fs.close()

# plotLocs({UsualDk, ColdDk}, 10000, 1000)

proc traceWalk(fields: openArray[Field]; numSteps: int) =
   let fs = open("plotting-tracewalk.dat", fmWrite)
   for f in fields:
      let d = initDrunk(UsualDk, "Homer")
      let origin = initLocation(0.0, 0.0)
      f.addDrunk(d, origin)
      var locs = newSeq[Location]()
      for s in 1 .. numSteps:
         f.moveDrunk(d)
         locs.add(f.getLoc(d))
      var xVals, yVals = newSeq[float]()
      for loc in locs:
         xVals.add(loc.getX())
         yVals.add(loc.getY())
      fs.writeData(xVals, yVals)
   fs.close()

# TraceWalk using Field and oddField
traceWalk([newField(), newOddField()], 500)
