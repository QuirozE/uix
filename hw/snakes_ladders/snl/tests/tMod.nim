import
  moder,
  unittest,
  options,
  net

suite "Moderator tests":
  test "Create empty board":
    discard newBoard()

  test "Create board with dims and traps":
    discard newBoard(
      dims = (1, 2),
      traps = @[some(1), some(0)]
    )

  test "Get board dims":
    let b = newBoard(dims = (0, 0))
    check(b.dims == (0, 0))

  test "Check traps":
    let b = newBoard(
      dims = (1, 3),
      traps = @[some(10), none(int), some(1)]
    )

    check(b.hasTrap(0))
    check(not b.hasTrap(1))

#  test "Create player":
#    var conn = newSocket()
#    conn.connect("localhost", Port(5000))
#    discard newPlayer(conn = conn)

#  test "Move player":
#    var p = newPlayer(
#      name = "Alex",
#      dims = (2, 2),
#      conn = newSocket()
#    )

#    check(p.advance(4) == 2)
#    check(p.advance(1) == 3)

#  test "Check winner":
#    let p = newPlayer(dims = (1, 1), conn = newSocket())
#    check(p.isWinner())
