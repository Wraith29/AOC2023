import ../timing
import strutils
import regex
import tables

const
  input = staticRead("./input.txt")
  nodePattern = re2 "(?P<id>[A-Z]{3})\\s=\\s\\((?P<left>[A-Z]{3}),\\s(?P<right>[A-Z]{3})\\)"

type
  Node = tuple[left, right: string] 

proc getNodes(data: string): Table[string, Node] =
  var m: RegexMatch2

  for line in data.splitLines:
    if not find(line, nodePattern, m):
      continue

    let
      id = line[m.group "id"]
      left = line[m.group "left"]
      right = line[m.group "right"]
    
    result[id] = (left, right)

proc solve(data: string): int =
  let instructions = data.splitLines(false)[0]
  let nodes = getNodes(data)
  
  var id = "AAA"
  var node = nodes[id]

  var index = 0
  while id != "ZZZ":
    let instruction = instructions[index]

    if instruction == 'R':
      id = node.right
    else:
      id = node.left

    node = nodes[id]

    result += 1
    ## Reset the index if we reach the end
    if index >= instructions.len() - 1:
      index = 0
    else:
      index += 1
  
timeit(8, 1, input, solve)