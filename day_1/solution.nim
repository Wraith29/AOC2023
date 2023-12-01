import sequtils
import strformat
import strutils
import sugar

proc loadData: string =
  const fileName = "sample.txt"

  readFile(fileName)

proc solve_1(data: string): int =
  for line in data.splitLines:
    let chars = line.filter((c: char) => isDigit c)
    if chars.len == 0: continue
    result += parseInt (chars[0] & chars[^1])

proc toLineOfInts(line: string): string =
  const charMap = {
    "zero": 0,
    "one": 1,
    "two": 2,
    "three": 3,
    "four": 4,
    "five": 5,
    "six": 6,
    "seven": 7,
    "eight": 8,
    "nine": 9,
  }

  var idx = 0
  while idx < line.len:
    let slice = substr(line, idx)
    echo slice

    if isDigit slice[0]:
      result &= $slice[0]
      idx += 1
      continue

    block a:
      for _, (t, v) in charMap:
        if slice.startsWith(t):
          result &= $v
          idx += t.len - 1
        break a

    idx += 1

proc solve_2(data: string): int =
  for line in data.splitLines:
    let chars = (toLineOfInts line).filter((c:char) => isDigit c)
    if chars.len == 0: continue
    result += parseInt $chars[0] & $chars[^1]

proc main =
  echo "Part 1: ", solve_1(loadData())
  echo "Part 2: ", solve_2(loadData())

when isMainModule:
  main()
