import ../timing
import algorithm
import sequtils
import std/enumerate
import strutils
import tables

const input = staticRead("./input.txt")

const cardValues = {
  'A': 13,
  'K': 12,
  'Q': 11,
  'T': 10,
  '9': 9,
  '8': 8,
  '7': 7,
  '6': 6,
  '5': 5,
  '4': 4,
  '3': 3,
  '2': 2,
  'J': 1,
}.toTable()

type
  HandType = enum
    HighCard = 1
    OnePair = 2
    TwoPair = 3
    ThreeOfAKind = 4
    FullHouse = 5
    FourOfAKind = 6
    FiveOfAKind = 7

  Hand = object
    cards: string
    bid: int

proc toTable(hand: Hand): TableRef[char, int] =
  result = newTable[char, int]()

  for card in hand.cards:
    result[card] = result.getOrDefault(card, 0) + 1

proc handType(hand: Hand): HandType =
  let
    tableRepr = hand.toTable()
    values = tableRepr.values.toSeq()

  case tableRepr.len():
  of 1:
    return FiveOfAKind
  of 2:
    if tableRepr.hasKey('J'):
      return FiveOfAKind
    elif values.contains(4):
      return FourOfAKind
    return FullHouse
  of 3:
    if tableRepr.hasKey('J'):
      case tableRepr['J']:
      of 1:
        if values.contains(3):
          return FourOfAKind
        return FullHouse
      of 2..3:
        return FourOfAKind
      else: discard
    
    if values.contains(3):
      return ThreeOfAKind
    return TwoPair
  of 4:
    if tableRepr.hasKey('J'):
      return ThreeOfAKind
    return OnePair
  of 5:
    if tableRepr.hasKey('J'):
      return OnePair
    return HighCard

  else: discard

proc getHands(data: string): seq[Hand] =
  for line in data.splitLines:
    if isEmptyOrWhitespace line:
      continue
  
    let lineSplit = line.split(' ')

    result.add(Hand(cards: lineSplit[0], bid: parseInt lineSplit[1]))

proc cmpCards(first, second: char): int =
  if first == second: return 0
  
  if cardValues[first] > cardValues[second]:
    return 1
  return -1

proc cmp(first, second: Hand): int =
  let
    fHand = first.handType()
    sHand = second.handType()

  if fHand > sHand:
    return 1
  elif sHand > fHand:
    return -1

  for (a, b) in zip(first.cards, second.cards):
    let val = cmpCards(a, b)
    if val != 0:
      return val
  
  return 0

proc solve(data: string): int =
  let hands = sorted(getHands(data), cmp)
  
  for idx, hand in enumerate(hands):
    result += (idx + 1) * hand.bid

timeit(7, 2, input, solve)