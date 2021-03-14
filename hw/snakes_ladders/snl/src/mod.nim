import
  net,
  random

type
  Trap = object
    door: (Natural, Natural)

  Board = object
    dims: (Natural, Natural)
    traps: seq[Trap]

  Player = object
    name: string
    pos: int
    isWinner: bool
    conn: Socket

  Mod* = object
    board: Board
    players: seq[Player]
    dice: Rand

when isMainModule:
  echo("Hello Moderator!!!")
