import regex
import strformat
import math
import strutils

const
  input = staticRead("./input.txt")

type Symbol = ref object
  width, row, col: int

proc `$`*(s: Symbol): string =
  fmt"Symbol(row: {s.row}, col: {s.col})"

func gridPos*(symbol: Symbol): int =
  (symbol.row * symbol.width) + symbol.col

proc findSymbols(data: string, rowWidth: int): seq[Symbol] =
  const pattern = re2 "[^.0-9]"
  var
    lastFoundPos = 0
    match: RegexMatch2

  while find(data, pattern, match, lastFoundPos):
    let
      row = int floor(match.boundaries.a / rowWidth)
      col = match.boundaries.a - (rowWidth * row)
    
    result.add Symbol(width: rowWidth, row: row, col: col)

    lastFoundPos = match.boundaries.a + 1

proc isAdjacentTo(symbol: Symbol; pos: tuple[l, r, c: int]): bool =
  if symbol.row - 1 <= pos.r and symbol.row + 1 >= pos.r:
    let
      lowest = pos.c - 1
      highest = pos.c + pos.l + 1

    if symbol.col >= lowest and symbol.col <= highest:
      return true

  false

proc solve(input: string): int =
  let
    data = input.splitLines().join("")
    width = input.splitLines[0].strip(true, true).len()
    symbols = findSymbols(data, width)
    pattern = re2 "([0-9]{1,3})"

  var
    lastMatchPos = 0
    match: RegexMatch2

  while find(data, pattern, match, lastMatchPos):
    let
      length = match.boundaries.b - match.boundaries.a
      row = int floor(match.boundaries.a / width)
      col = match.boundaries.a - (width * row)

    for symbol in symbols:
      if symbol.isAdjacentTo((l: length, r: row, c: col)):
        result += parseInt data[match.group 0]
        break

    lastMatchPos = match.boundaries.b+1

echo "Day 3 - Part 1: ", solve(input)
