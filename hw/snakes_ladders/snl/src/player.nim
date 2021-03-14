import net

type
  Player* = object
    name: string
    conn: Socket

when isMainModule:
  echo("Hello Player!!!")
