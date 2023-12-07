import ../timing
import sequtils
import strutils
import sugar

const
  input = staticRead("./input.txt")

proc solve(data: string): int =
  for line in data.splitLines:
    let chars = line.filter((c: char) => c.isDigit)
    if chars.len == 0:
      continue

    result += parseInt(chars[0] & chars[^1])

timeit(1, 1, input, solve)