import ../timing
import regex
import strutils
import tables

const
  input = staticRead("./input.txt")
  redCount = 12
  greenCount = 13
  blueCount = 14

type Game = ref object
  id, blue, red, green: int

proc newGame(line: string): Game =
  const gameIdPattern = re2 "Game\\s(?P<gameId>[0-9]+):"
  
  var gameIdMatch: RegexMatch2

  discard find(line, gameIdPattern, gameIdMatch)
  let gameId = parseInt line[gameIdMatch.group("gameId")]

  let splitLine = line.split(':', 2)
  let (_, data) = (splitLine[0], splitLine[1])

  result = new Game

  result.id = gameId
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

proc solve(data: string): int =
  for line in data.strip(true, true).splitLines:
    let game = newGame(line)
    if game.isPossible():
      result += game.id

timeit(2, 1, input, solve)
