import strutils
import sequtils
import ../timing
import sugar

const input = staticRead("./sample.txt")

type
  Race = object
    time, distance: int



proc solve(data: string): int =

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
  
  echo timeLine, ", ", distLine
  
  echo races


timeit(6, 1, input, solve)
