import random

randomize()

type FairRoulette = ref object
    pockets: seq[int]
    ball: int
    blackOdds, redOdds, pocketOdds: float

proc newFairRoulette(): FairRoulette =
    new(result)
    result.pockets = @[]
    for i in countup(1, 36):
        result.pockets.add(i)
    result.ball = 0
    result.blackOdds = 1.0
    result.redOdds = 1.0
    result.pocketOdds = len(result.pockets).float - 1.0

proc spin(self: FairRoulette) =
    self.ball = random(self.pockets)

proc isBlack(self: FairRoulette): bool =
    if self.ball == 0:
        return false
    if (self.ball > 0 and self.ball <= 10) or
       (self.ball > 18 and self.ball <= 28):
        self.ball mod 2 == 0
    else:
        self.ball mod 2 == 1

proc isRed(self: FairRoulette): bool =
    self.ball != 0 and not self.isBlack()

proc betBlack(self: FairRoulette, amt: float): float =
    if self.isBlack():
        amt*self.blackOdds
    else: -amt

proc betRed(self: FairRoulette, amt: float): float =
    if self.isRed():
        amt*self.redOdds
    else: -amt*self.redOdds

proc betPocket(self: FairRoulette, pocket: string, amt: float): float =
    if pocket == $self.ball:
        amt*self.pocketOdds
    else: -amt

proc `$`(self: FairRoulette): string =
    "Fair Roulette"

proc playRoulette(game: FairRoulette, numSpins: int, toPrint = true): (float, float, float) =
    let luckyNumber = "2"
    let bet = 1
    var totRed, totBlack, totPocket = 0.0
    for _ in 1 .. numSpins:
        game.spin()
        totRed += game.betRed(bet.float)
        totBlack += game.betBlack(bet.float)
        totPocket += game.betPocket(luckyNumber, bet.float)
    if toPrint:
        echo(numSpins, " spins of ", game)
        echo("Expected return betting red = ",
              $(100*totRed/numSpins.float) & "%")
        echo("Expected return betting black = ",
              $(100*totBlack/numSpins.float) & "%")
        echo("Expected return betting ", luckyNumber, " = ",
              $(100*totPocket/numSpins.float) & "%\n")
    (totRed/numSpins.float, totBlack/numSpins.float, totPocket/numSpins.float)

let numSpins = 1000000
let game = newFairRoulette()
discard playRoulette(game, numSpins)
