import ../timing
import math
import strformat
import regex
import strutils

const input = staticRead("./input.txt")

type PartNumber = ref object
  length, row, col, value: int

proc newPartNumber(length, row, col, value: int): PartNumber =
  PartNumber(length: length, row: row, col: col, value: value)

proc `$`*(p: PartNumber): string =
  fmt"PartNumber(length: {p.length}, row: {p.row}, col: {p.col})"

proc findPartNumbers(data: string; width: int): seq[PartNumber] =
  const pattern = re2 "[0-9]{1,3}"
  var
    lastMatchPos = 0
    match: RegexMatch2

  while find(data, pattern, match, lastMatchPos):
    let
      length = match.boundaries.b - match.boundaries.a
      row = int floor(match.boundaries.a / width)
      col = match.boundaries.a - (width * row)
      value = parseInt data[match.boundaries]
    
    result.add newPartNumber(length, row, col, value)

    lastMatchPos = match.boundaries.b + 1

proc isAdjacentTo(pn: PartNumber; symbol: tuple[row, col: int]): bool =
  if symbol.row - 1 <= pn.row and symbol.row + 1 >= pn.row:
    let
      lowest = pn.col - 1
      highest = pn.col + pn.length + 1
    
    if symbol.col >= lowest and symbol.col <= highest:
      return true
  
  false

proc solve(input: string): int =
  const pattern = re2 "[*]"
  let
    data = input.splitLines().join("")
    width = input.splitLines[0].strip(true, true).len()
    partNumbers = findPartNumbers(data, width)

  var
    lastMatchPos = 0
    match: RegexMatch2
  
  while find(data, pattern, match, lastMatchPos):
    var adjacentPartNumbers = newSeq[PartNumber]()

    let
      row = int floor(match.boundaries.a / width)
      col = match.boundaries.a - (row * width)
    
    for pn in partNumbers:
      if pn.isAdjacentTo((row: row, col: col)):
        adjacentPartNumbers.add pn

    lastMatchPos = match.boundaries.b + 1

    if adjacentPartNumbers.len != 2: continue

    result += (adjacentPartNumbers[0].value * adjacentPartNumbers[1].value)

timeit(3, 2, input, solve)