import random, math, strutils

type
   RouletteKind = enum
      Fair = "Fair Roulette"
      European = "European Roulette"
      American = "American Roulette"

   Roulette = object
      kind: RouletteKind
      pockets: Slice[int]
      ball: int
      blackOdds, redOdds, pocketOdds: float

proc initRoulette(rEnum: RouletteKind): Roulette =
   result.pockets = case rEnum
      of Fair:
         1..36
      of European:
         1..37
      of American:
         1..38
   result.kind = rEnum
   result.ball = 0
   result.blackOdds = 1.0
   result.redOdds = 1.0
   result.pocketOdds = float(len(result.pockets) - 1)

proc spin(self: var Roulette) =
   self.ball = rand(self.pockets)

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
   else: -amt

proc betPocket(self: Roulette, pocket: int, amt: float): float =
   if pocket == self.ball:
      amt*self.pocketOdds
   else: -amt

proc playRoulette(game: var Roulette, numSpins: int, toPrint = true): auto =
   let luckyNumber = 2
   let bet = 1.0
   var totRed, totBlack, totPocket = 0.0
   for s in 1 .. numSpins:
      game.spin()
      totRed += game.betRed(bet)
      totBlack += game.betBlack(bet)
      totPocket += game.betPocket(luckyNumber, bet)
   if toPrint:
      echo(numSpins, " spins of ", game.kind)
      echo("Expected return betting red = ",
            $(100*totRed/numSpins.float), "%")
      echo("Expected return betting black = ",
            $(100*totBlack/numSpins.float), "%")
      echo("Expected return betting ", luckyNumber, " = ",
            $(100*totPocket/numSpins.float), "%\n")
   (totRed/numSpins.float, totBlack/numSpins.float, totPocket/numSpins.float)

# let numSpins = 1_000_000
# var game = initRoulette(RouletteKind.Fair)
# discard playRoulette(game, numSpins)

proc findPocketReturn(game: var Roulette, numTrials: int, trialSize: int,
                      toPrint: bool): seq[float] =
   result = @[]
   for t in 1 .. numTrials:
      let trialVals = playRoulette(game, trialSize, toPrint)
      result.add(trialVals[2])

proc getMeanAndStd(xa: seq[float]): auto =
   let mean = sum(xa)/len(xa).float
   var tot = 0.0
   for x in xa:
      tot += pow(x - mean, 2.0)
   let std = sqrt(tot/len(xa).float)
   (mean, std)

template ff(f: float, prec: int = 3): string = formatFloat(f, ffDecimal, prec)

proc simAll(rouletteKinds: set[RouletteKind], gameLengths: openarray[int],
            numTrials: int) =
   for numSpins in gameLengths:
      echo("\nSimulate betting a pocket for ", numTrials,
            " trials of ", numSpins, " spins each.")
      for rEnum in rouletteKinds:
         var game = initRoulette(rEnum)
         let pocketReturns = game.findPocketReturn(numTrials, numSpins, false)
         # echo("Exp. return for ", game.kind, " = ",
         #       $(100*sum(pocketReturns)/len(pocketReturns).float), "%")
         let (mean, std) = getMeanAndStd(pocketReturns)
         echo("Exp. return for ", game.kind, " = ", ff(100*mean),
              "%, +/- ", ff(100*1.96*std), "% with 95% confidence")

simAll({Fair, European, American},
       [100, 1000, 10000, 100000], 20)
