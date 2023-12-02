import strutils
import tables
import strformat

const
  redCount = 12
  greenCount = 13
  blueCount = 14

type Game = ref object
  id, blue, red, green: int

proc `$`*(game: Game): string =
  fmt"Game(id: {game.id}, blue: {game.blue}, red: {game.red}, green: {game.green})"

proc newGame(line: string): Game =
  let splitLine = line.split(':', 2)
  let (gameId, data) = (splitLine[0], splitLine[1])

  result = new Game

  result.id = gameId.split(' ')[1].parseInt()
  for roll in data.split(";"):
    var cubes = newTable[string, int]()
    for cube in roll.split(","):
      let splitCube = cube.strip(true).split(" ")
      if splitCube[1] in cubes:
        cubes[splitCube[1]] += parseInt splitCube[0]
      else:
        cubes[splitCube[1]] = parseInt splitCube[0]

    result.red = max(cubes.getOrDefault("red", 0), result.red)
    result.green = max(cubes.getOrDefault("green", 0), result.green)
    result.blue = max(cubes.getOrDefault("blue", 0), result.blue)

proc isPossible(game: Game): bool =
  game.blue <= blueCount and game.red <= redCount and game.green <= greenCount

const data = staticRead("./input.txt")

proc solve(data: string): int =
  for line in data.strip(true, true).splitLines:
    let game = newGame(line)
    if game.isPossible():
      result += game.id

proc main =
  echo "Part 1: ", solve(data)

when isMainModule:
  main()