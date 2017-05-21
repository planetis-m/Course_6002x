import random, math


type
  RouletteKind = enum
    Fair = "Fair Roulette"
    European = "European Roulette"
    American = "American Roulette"
  Roulette = ref object
    kind: RouletteKind
    pockets: seq[int]
    ball: int
    blackOdds, redOdds, pocketOdds: float

proc newRoulette(rEnum: RouletteKind): Roulette =
  new(result)
  var WheelRange: Slice[int]
  case rEnum
  of Fair:
    WheelRange = 1..36
  of European:
    WheelRange = 1..37
  of American:
    WheelRange = 1..38
  result.pockets = @[]
  for i in WheelRange:
    result.pockets.add(i)

  result.ball = 0
  result.blackOdds = 1.0
  result.redOdds = 1.0
  result.pocketOdds = len(result.pockets).float - 1.0

proc spin(self: Roulette) =
  self.ball = random(self.pockets)

proc isBlack(self: Roulette): bool =
  if self.ball > 36:
    return false
  if (self.ball > 0 and self.ball <= 10) or
    (self.ball > 18 and self.ball <= 28):
    self.ball mod 2 == 0
  else:
    self.ball mod 2 == 1

proc isRed(self: Roulette): bool =
  self.ball <= 36 and not self.isBlack()

proc betBlack(self: Roulette, amt: float): float =
  if self.isBlack():
    amt*self.blackOdds
  else: -amt

proc betRed(self: Roulette, amt: float): float =
  if self.isRed():
    amt*self.redOdds
  else: -amt*self.redOdds

proc betPocket(self: Roulette, pocket: string, amt: float): float =
  if pocket == $self.ball:
    amt*self.pocketOdds
  else: -amt

proc playRoulette(game: Roulette, numSpins: int, toPrint = true): auto =
  let luckyNumber = "2"
  let bet = 1
  var totRed, totBlack, totPocket = 0.0
  for _ in 1 .. numSpins:
    game.spin()
    totRed += game.betRed(bet.float)
    totBlack += game.betBlack(bet.float)
    totPocket += game.betPocket(luckyNumber, bet.float)
  if toPrint:
    echo(numSpins, " spins of ", game.kind)
    echo("Expected return betting red = ",
          $(100*totRed/numSpins.float) & "%")
    echo("Expected return betting black = ",
          $(100*totBlack/numSpins.float) & "%")
    echo("Expected return betting ", luckyNumber, " = ",
          $(100*totPocket/numSpins.float) & "%\n")
  (totRed/numSpins.float, totBlack/numSpins.float, totPocket/numSpins.float)

# let numSpins = 1000000
# let game = newRoulette(RouletteKind.Fair)
# discard playRoulette(game, numSpins)

proc findPocketReturn(game: Roulette, numTrials: int, trialSize: int, toPrint: bool): seq[float] =
  result = @[]
  for _ in 1 .. numTrials:
    let trialVals = playRoulette(game, trialSize, toPrint)
    result.add(trialVals[2])

proc simAll(rouletteKinds: set[RouletteKind], gameLengths: openarray[int], numTrials: int) =
  for numSpins in gameLengths:
    echo("\nSimulate betting a pocket for ", numTrials,
         " trials of ", numSpins, " spins each.")
    for rEnum in rouletteKinds:
      let game = newRoulette(rEnum)
      let pocketReturns = game.findPocketReturn(numTrials, numSpins, false)
      echo("Exp. return for ", game.kind, " = ",
            $(100*sum(pocketReturns)/len(pocketReturns).float) & "%")

simAll({Fair, European, American},
       [100, 1000, 10000, 100000], 20)
