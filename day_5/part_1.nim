import regex
import options
import strformat
import sequtils
import strutils
import tables
import times

const
  input = staticRead "./input.txt"
  seedsPattern = re2 "seeds:\\s(?P<seeds>[0-9\\s]*)"
  mappingPattern = re2 "^(?P<mapping>[\\w-]*)\\smap:$"
  pattern = re2 "^(?P<dst>\\d*)\\s(?P<src>\\d*)\\s(?P<len>\\d*)$"
  ss = "seed-to-soil"
  sf = "soil-to-fertilizer"
  fw = "fertilizer-to-water"
  wl = "water-to-light"
  lt = "light-to-temperature"
  th = "temperature-to-humidity"
  hl = "humidity-to-location"

type Range = tuple[bottom, top: int]

proc `$`*(r: Range): string =
  fmt"Range({r.bottom} .. {r.top})"

proc `in`*(n: int, r: Range): bool {.inline.} =
  n >= r.bottom and n <= r.top

proc find*(t: TableRef[Range, Range], n: int): Option[tuple[k, v: Range]] =
  for k, v in t:
    if n in k:
      return some((k: k, v: v))
  none(tuple[k, v: Range])

proc value*(r: tuple[k, v: Range]; n: int): int =
  let offset = n - r.k.bottom
  r.v.bottom + offset

proc `in`*(n: int, t: TableRef[Range, Range]): bool {.inline.} =
  for key, _ in t:
    if n in key:
      return true
  false

proc valueOrDefault(t: Table[string, TableRef[Range, Range]]; k: string; n: int): int =
  if n in t[k]:
    return t[k].find(n).get().value(n)
  return n

proc getSeeds(line: string): seq[int] =
  var m: RegexMatch2
  if not line.match(seedsPattern, m):
    return @[]

  line[m.group "seeds"].split(' ').mapIt(parseInt it)

proc solve(inp: string): int =
  let
    data = inp.splitLines().filterIt(not it.isEmptyOrWhitespace)
  
  var
    mapping = {
      ss: newTable[Range, Range](),
      sf: newTable[Range, Range](),
      fw: newTable[Range, Range](),
      wl: newTable[Range, Range](),
      lt: newTable[Range, Range](),
      th: newTable[Range, Range](),
      hl: newTable[Range, Range](),
    }.toTable()
    seeds = getSeeds(data[0])
    mapStr: string
    rangeMatch, mappingMatch: RegexMatch2

  for line in data[1..^1]:
    if line.find(mappingPattern, mappingMatch):
      mapStr = line[mappingMatch.group "mapping"]
      continue
    
    if not line.find(pattern, rangeMatch):
      continue
  
    let
      dstRangeStart = parseInt line[rangeMatch.group "dst"]
      srcRangeStart = parseInt line[rangeMatch.group "src"]
      rangeLength = parseInt line[rangeMatch.group "len"]

    mapping[mapStr][(bottom: srcRangeStart, top: srcRangeStart+rangeLength-1)] = (bottom: dstRangeStart, top: dstRangeStart+rangeLength-1)
  
  var
    soil = 0
    fertilizer = 0
    water = 0
    light = 0
    temperature = 0
    humidity = 0
    location = 0
    locations = newSeq[int]()

  for seed in seeds:
    soil = valueOrDefault(mapping, ss, seed)
    fertilizer = valueOrDefault(mapping, sf, soil)
    water = valueOrDefault(mapping, fw, fertilizer)
    light = valueOrDefault(mapping, wl, water)
    temperature = valueOrDefault(mapping, lt, light)
    humidity = valueOrDefault(mapping, th, temperature)
    location = valueOrDefault(mapping, hl, humidity)
    locations.add location

  min(locations)

let
  start = cpuTime()
  res = solve(input)
  fin = cpuTime()

echo fmt"Day 5 - Part 1: {res} {fin - start}ms"
