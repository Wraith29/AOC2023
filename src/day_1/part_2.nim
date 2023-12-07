import sequtils
import std/enumerate
import strutils
import sugar

const
  input = staticRead("./input.txt")
  numberMapping = ["zero", "one", "two",
                   "three", "four", "five",
                   "six", "seven", "eight", "nine"]

proc toLineOfInts(line: string): string =
  var index = 0
  while index < line.len():
    let slice = line.substr(index)

    if slice[0].isDigit():
      result &= $slice[0]
      index += 1
      continue

    block iterMapping:
      for index, text in enumerate(numberMapping):
        if slice.startsWith(text):
          result &= $index
          break iterMapping

    index += 1

proc solve(data: string): int =
  for line in data.splitLines:
    let chars = line.toLineOfInts().filter((c: char) => c.isDigit())
    if chars.len() == 0: continue

    result += parseInt($chars[0] & $chars[^1])

echo "Day 1 - Part 2: ", solve(input)