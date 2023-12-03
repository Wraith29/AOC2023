import regex
import strformat
import sequtils
import math
import strutils
import sugar

const
  input = staticRead("./sample.txt")

type Symbol = ref object
  width, row, col: int

func gridPos(symbol: Symbol): int =
  (symbol.row * symbol.width) + symbol.col

proc findSymbols(data: string, rowWidth: int): seq[Symbol] =
  const pattern = re2 "[*#+%=/@$-&]"
  var
    lastFoundPos = 0
    match: RegexMatch2

  while find(data, pattern, match, lastFoundPos):
    let
      row = int floor(match.boundaries.a / rowWidth)
      col = match.boundaries.a - (rowWidth * row)
    
    result.add Symbol(width: rowWidth, row: row, col: col)

    lastFoundPos = match.boundaries.a + 1

proc solve(data: string): int =
  let
    grid = data.splitLines.map((line: string) => line.strip(true, true)).collect()
    width = grid[0].len()
    symbols = findSymbols(data, width)

  var idx = 0
  while idx < data.len():
    if data[idx] == '.':
      idx += 1
      continue

    idx += 1

  1


echo "Day 3 - Part 1: ", solve(input)