import
  net,
  random,
  options,
  strscans,
  sequtils

type
  Outcome = Option[int]

  Board = object
    dims: (int, int)
    traps: seq[Outcome]

  Player = object
    name: string
    pos: int
    dims: (int, int)
    conn: Socket

  Mod* = object
    board: Board
    players: seq[Player]
    currPlayer: int
    dice: Rand

proc newBoard*(dims = (0, 0), traps = newSeq[Outcome]()): Board =
  if traps.len != dims[0] * dims[1]:
    raise newException(ValueError, "Inconruent dimentions and amount of traps")

  Board(dims: dims, traps: traps)

proc dims*(b: Board): (int, int) = b.dims

proc hasTrap*(b: Board, pos: int): bool = b.traps[pos].isSome()

proc applyTrap*(b: Board, pos: int): Outcome = b.traps[pos]

proc newPlayer*(name = "John Doe", dims = (20, 5), conn: Socket): Player =
  if conn.trySend("Creating player: " & name):
    result = Player(name: name, pos: 0, dims: dims, conn: conn)
  else:
    raise newException(ValueError, "Unconnected socket")

proc advance*(p: var Player, steps: int): int =
  let
    size = p.dims[0] * p.dims[1] - 1
    nPos = p.pos + steps
    over = nPos mod size
  if nPos >= size:
     p.pos = size - over
  else:
    p.pos = nPos

  result = p.pos

proc isWinner*(p: Player): bool =
  let size = p.dims[0] * p.dims[1]
  result = p.pos == size - 1

proc readUserTraps(dims: (int, int)): seq[Outcome] =
  var
    i: int
    o: int

  result = newSeqWith[Outcome](dims[0]*dims[1], none(int))
  stdout.write("Input traps coordinates (in, out): ")

  var
    trap = stdin.readLine()

  while scanf(trap, "($i, $i)", i, o):
    result[i] = some(o)
    stdout.write("Input traps coordinates (in, out): ")
    trap = stdin.readLine()

proc newMod*(seed = 123, numPlayers = 5, dims = (20, 5)): Mod =
  let
    traps = readUserTraps(dims)
    board = newBoard(dims, traps)
    players = newSeq[Player](numPlayers)
    dice = initRand(seed)

  result = Mod(
    board: board,
    players: players,
    currPlayer: 0,
    dice: dice,
  )

proc waitForPlayers*(m: var Mod, port = 5000) =
  var conn = newSocket()
  conn.bindAddr(Port(port))

  var
    playerConn: Socket
    playerAddr: string
    player: Player

  for i in 0..<m.players.len:
    conn.acceptAddr(playerConn, playerAddr)
    conn.send("Waiting for player name...")
    let name = conn.recvLine()
    player = newPlayer(name, m.board.dims, playerConn)
    m.players[i] = player

when isMainModule:
  discard newMod()
