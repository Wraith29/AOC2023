import strutils
import sequtils
import ../timing
import sugar

const input = staticRead("./input.txt")

type
  Race = object
    time, distance: int

proc numWaysToWin(r: Race): int =
  for i in 1 ..< r.time:
    let remainingTime = r.time - i
    if i * remainingTime > r.distance:
      result += 1

proc solve(data: string): int =
  result = 1

  let
    newLineSplit = data.split(Newlines).filter((s: string) => not s.isEmptyOrWhitespace)
    timeLine = newLineSplit[0]
      .split(Whitespace)[1..^1]
      .filter((s: string) => not s.isEmptyOrWhitespace)
      .map((s: string) => parseInt s)
    distLine = newLineSplit[1]
      .split(Whitespace)[1..^1]
      .filter((s: string) => not s.isEmptyOrWhitespace)
      .map((s: string) => parseInt s)
    races = collect:
      for (time, dist) in zip(timeLine, distLine):
        Race(time: time, distance: dist)
  
  for race in races:
    result *= race.numWaysToWin()

timeit(6, 1, input, solve)
