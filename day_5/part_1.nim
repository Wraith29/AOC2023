import regex
import sequtils
import strformat
import strutils
import sugar
import tables

const
  input = staticRead "./sample.txt"
  seedsPattern = re2 "seeds:\\s(?P<seeds>[0-9\\s]*)"
  mappingPattern = re2 "^(?P<src>\\w*)-to-(?P<dst>\\w*)\\smap:$"
  pattern = re2 "^(?P<dst>\\d*)\\s(?P<src>\\d*)\\s(?P<len>\\d*)$"

type
  Seed = Table[string, int]

proc newSeed(id: int): Seed =
  ## They default to the same as the ID
  {
    "id": id,
    "soil": id,
    "fertilizer": id,
    "water": id,
    "temperature": id,
    "humidity": id,
    "location": id,
  }.toTable()

proc getSeeds(line: string): TableRef[int, Seed] =
  result = newTable[int, Seed]()
  var m: RegexMatch2

  if not line.find(seedsPattern, m):
    return

  for seed in line[m.group "seeds"].split(' ').mapIt(parseInt it):
    result[seed] = newSeed(seed)

proc solve(inp: string): int =
  let
    data = inp.splitLines().filterIt(not it.isEmptyOrWhitespace)
    seeds = getSeeds(data[0])
  
  echo seeds
  
  var
    source, dest: string
    rangeMatch, mappingMatch: RegexMatch2

  for line in data[1..^1]:
    if line.find(mappingPattern, mappingMatch):
      source = line[mappingMatch.group "src"]
      dest = line[mappingMatch.group "dst"]
      continue
    
    if not line.find(pattern, rangeMatch):
      continue
  
    let
      dstRangeStart = parseInt line[rangeMatch.group "dst"]
      srcRangeStart = parseInt line[rangeMatch.group "src"]
      rangeLength = parseInt line[rangeMatch.group "len"]

    echo fmt"{dest} - {dstRangeStart} : {source} {srcRangeStart} : {rangeLength}"

    for i in 0 ..< rangeLength:
      echo srcRangeStart + i, " : ", dstRangeStart + i

  1

echo "Day 5 - Part 1: ", solve(input)
