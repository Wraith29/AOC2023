import ../timing
import sequtils
import tables
import sugar

const input = staticRead("./sample.txt")

type
  NodeDirection = enum
    EastAndWest = '-'
    Ground = '.'
    SouthAndWest = '7'
    SouthAndEast = 'F'
    NorthAndWest = 'J'
    NorthAndEast = 'L'
    Start = 'S'
    NorthAndSouth = '|'
    Unknown

  NodePosition = enum
    Above, Below, Left, Right

  Node = object
    id, x, y: int
    direction: NodeDirection

proc getRelativePosition(first, second: Node): NodePosition =
  if first.x == second.x - 1:
    return Right
  elif first.x == second.x + 1:
    return Left 
  elif first.y == second.y - 1:
    return Below
  elif first.y == second.y + 1:
    return Above

proc fromChar(c: char): NodeDirection =
  return case c:
    of '-': EastAndWest
    of '.': Ground
    of '7': SouthAndWest
    of 'F': SouthAndEast
    of 'J': NorthAndWest
    of 'L': NorthAndEast
    of 'S': Start
    of '|': NorthAndSouth
    else: Unknown

proc getValidMoves(node: Node, nodes: seq[Node]): seq[int] =
  ## Returns the ID of the valid nodes
  for otherNode in nodes:
    if otherNode.id == node.id: continue

    # Above
    if otherNode.x == node.x and otherNode.y - 1 == node.y:
      add(result, otherNode.id)
    # Below
    elif otherNode.x == node.x and otherNode.y + 1 == node.y:
      add(result, otherNode.id)
    # Left
    elif otherNode.y == node.y and otherNode.x - 1 == node.x:
      add(result, otherNode.id)
    # Right
    elif otherNode.y == node.y and otherNode.x + 1 == node.x:
      add(result, otherNode.id)

proc getNodes(data: string): Table[int, Node] =
  var
    id = 0
    rowCount = 0
    colCount = 0

  for node in data:
    if node == '\n':
      rowCount += 1
      colCount = 0
      continue

    let direction = fromChar(node)

    if direction != Ground and direction != Unknown:
      result[id] = Node(id: id, direction: direction, x: colCount, y: rowCount)

    colCount += 1
    id += 1

proc getLoop(nodes: Table[int, Node]): seq[int] =
  let values = nodes.values.toSeq()

   

proc solve(data: string): int =
  let nodes = getNodes(data)

  let loop = getLoop(nodes)

  echo loop

  1

timeit(10, 1, input, solve)