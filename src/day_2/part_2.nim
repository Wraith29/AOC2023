import strutils
import strformat

const
  redCount* = 12
  greenCount* = 13
  blueCount* = 14

type Game = ref object
  id: int
  blue, red, green: seq[int]

proc `$`*(game: Game): string =
  fmt"Game(id: {game.id}, blue: {game.blue}, red: {game.red}, green: {game.green})"

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

const data = staticRead("./input.txt")

proc solve(data: string): int =
  for line in data.strip(true, true).splitLines:
    let game = newGame(line)
    let gamePower = max(game.red) * max(game.blue) * max(game.green)
    result += gamePower

proc main =
  echo "Part 2: ", solve(data)

when isMainModule:
  main()