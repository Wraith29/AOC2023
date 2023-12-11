import ../timing
import strutils
import sequtils
import sugar

const input = staticRead("./input.txt")

type
  DataSet = object
    values: seq[int]
    differences: seq[seq[int]] = @[]

proc newValue(dataSet: var DataSet): int =
  var idx = dataSet.differences.len() - 1
  var prevDiff: int

  while idx > 0:
    prevDiff = dataSet.differences[idx][0]
    dataSet.differences[idx - 1].insert(dataSet.differences[idx - 1][0] - prevDiff, 0)

    idx -= 1

  dataSet.values[0] - dataSet.differences[0][0]

proc getDifferences(line: seq[int]): seq[int] =
  var
    index = 0
    a, b: int

  while index < line.len() - 1:
    a = line[index]
    b = line[index + 1]

    result.add(b - a)

    index += 1

proc solve(data: string): int =
  for line in data.splitLines:
    if isEmptyOrWhitespace line:
      continue

    let values = line.split(' ').filter((s: string) => not s.isEmptyOrWhitespace).map((s: string) => parseInt s)
    var ds = DataSet(values: values)

    var diff = getDifferences(values)

    ds.differences.add(diff)

    while not diff.all((val: int) => val == 0):
      diff = getDifferences(diff)
      ds.differences.add(diff)

    result += ds.newValue()

timeit(9, 2, input, solve)