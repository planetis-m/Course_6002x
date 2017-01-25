import tables, hashes, math, random

type
  Location = object
    x, y: float

# ----------------------
# Location type routines
# ----------------------

proc initLocation(x, y: float): Location =
  result = Location(x: x, y: y)

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
  Drunk = object of RootObj
    name: string
  UsualDrunk = object of Drunk
  ColdDrunk = object of Drunk

# -------------------
# Drunk type routines
# -------------------

proc initDrunk(dClass: typedesc[Drunk]; name: string): dClass =
  result = dClass(name: name)

proc hash(self: Drunk): Hash =
  result = hash(self.name)
  result = !$result

proc `$`(self: Drunk): string =
  result = "This drunk is named " & self.name

method takeStep(self: Drunk): auto {.base.} =
  echo("Called takeStep base method")
  result = (0.0, 0.0)

method takeStep(self: UsualDrunk): auto =
  let stepChoices = [(0.0, 1.0), (0.0, -1.0), (1.0, 0.0), (-1.0, 0.0)]
  result = random(stepChoices)

method takeStep(self: ColdDrunk): auto =
  let stepChoices = [(0.0, 0.9), (0.0, -1.1), (1.0, 0.0), (-1.0, 0.0)]
  result = random(stepChoices)


type
  Field = object
    drunks: Table[Drunk, Location]

# -------------------
# Field type routines
# -------------------

proc initField(): Field =
  result = Field(drunks: initTable[Drunk, Location]())

proc addDrunk(self: var Field; drunk: Drunk; loc: Location) =
  if self.drunks.hasKey(drunk):
    raise newException(ValueError, "Duplicate drunk")
  self.drunks[drunk] = loc

proc getLoc(self: Field; drunk: Drunk): Location =
  if not self.drunks.hasKey(drunk):
    raise newException(ValueError, "Drunk not in field")
  result = self.drunks[drunk]

proc moveDrunk(self: var Field; drunk: Drunk) =
  if not self.drunks.hasKey(drunk):
    raise newException(ValueError, "Drunk not in field")
  let (xDist, yDist) = drunk.takeStep()
  let currentLocation = self.drunks[drunk]
  self.drunks[drunk] = currentLocation.move(xDist, yDist)

# -------------------
# Simulation routines
# -------------------

proc walk(f: var Field; d: Drunk; numSteps: int): float =
  ## Moves d numSteps times, and returns the distance between
  ## the final location and the location at the start of the walk.
  let start = f.getLoc(d)
  for s in 1 .. numSteps:
    f.moveDrunk(d)
  result = start.distFrom(f.getLoc(d))

proc simWalks(numSteps, numTrials: int; dClass: typedesc[Drunk]): seq[float] =
  ## Simulates numTrials walks of numSteps steps each.
  ## Returns a list of the final distances for each trial
  let homer = initDrunk(dClass, "Homer")
  let origin = initLocation(0.0, 0.0)
  result = @[]
  for t in 1 .. numTrials:
    var f = initField()
    f.addDrunk(homer, origin)
    result.add(round(walk(f, homer, numSteps), 1))

proc drunkTest(walkLengths: openArray[int]; numTrials: int; dClass: typedesc[Drunk]) =
  ## For each number of steps in walkLengths, runs simWalks with
  ## numTrials walks and prints results
  for numSteps in walkLengths:
    let distances = simWalks(numSteps, numTrials, dClass)
    echo("Random walk of ", numSteps, " steps")
    echo(" Mean = ", round(sum(distances)/len(distances).float, 1))
    echo(" Max = ", max(distances), " Min = ", min(distances))


randomize()
drunkTest([10, 1000, 1000, 10000], 100, UsualDrunk)
