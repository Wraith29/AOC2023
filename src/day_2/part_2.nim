import ../timing
import strutils

const input = staticRead("./input.txt")

type Game = ref object
  id: int
  blue, red, green: seq[int]

proc newGame(line: string): Game =
  let splitLine = line.split(':', 2)
  let (gameId, data) = (splitLine[0], splitLine[1])

  result = new Game
  result.red = newSeq[int]()
  result.green = newSeq[int]()
  result.blue = newSeq[int]()

  result.id = gameId.split(' ')[1].parseInt()
  for roll in data.split(";"):
    for cube in roll.split(","):
      let splitCube = cube.strip(true).split(" ")
      case splitCube[1]:
      of "red": result.red.add(parseInt splitCube[0])
      of "green": result.green.add(parseInt splitCube[0])
      of "blue": result.blue.add(parseInt splitCube[0])

proc solve(data: string): int =
  for line in data.strip(true, true).splitLines:
    let game = newGame(line)
    let gamePower = max(game.red) * max(game.blue) * max(game.green)
    result += gamePower

timeit(2, 2, input, solve)
