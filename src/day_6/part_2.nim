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
    time = newLineSplit[0].filter((c: char) => c.isDigit()).join("").parseInt()
    dist = newLineSplit[1].filter((c: char) => c.isDigit()).join("").parseInt()
    race = Race(time: time, distance: dist)
  
  return race.numWaysToWin


timeit(6, 2, input, solve)
