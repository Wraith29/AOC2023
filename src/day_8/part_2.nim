import ../timing
import strutils
import regex
import tables
import sequtils
import sugar
import math

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

proc followNode(instructions, startNode: string; nodes: Table[string, Node]): int =
  var
    instruction: char
    id = startNode
    node = nodes[id]
    index = 0

  while not id.endsWith("Z"):
    instruction = instructions[index]

    if instruction == 'R':
      id = node.right
    else:
      id = node.left
    
    node = nodes[id]

    result += 1

    if index >= instructions.len() - 1:
      index = 0
    else:
      index += 1

proc solve(data: string): int =
  let instructions = data.splitLines(false)[0]
  let nodes = getNodes(data)
  var answers = newSeq[int]()

  for node in nodes.keys.toSeq().filter((node: string) => node.endsWith("A")):
    answers.add(followNode(instructions, node, nodes))

  lcm(answers)

timeit(8, 2, input, solve)