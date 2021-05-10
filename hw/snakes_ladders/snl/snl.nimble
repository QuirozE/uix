# Package

version       = "0.1.0"
author        = "Edgar Quiroz"
description   = "Simple text only snakes and ladders"
license       = "MIT"
srcDir        = "src"
namedBin      = {"moder":"snlMod", "player": "snlPlay"}.toTable()


# Dependencies

requires "nim >= 1.4.4"
