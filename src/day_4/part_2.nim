import tables
import regex
import sequtils
import strformat
import strutils
import sugar

const
  input = staticRead("./input.txt")

type Card = ref object
  id: int
  winningNumbers, inputNumbers: seq[int]

proc newCard(id: int; winningNumbers, inputNumbers: seq[int]): Card =
  Card(id: id, inputNumbers: inputNumbers, winningNumbers: winningNumbers)

proc `$`*(c: Card): string =
  fmt"Card(cardId: {c.id}, winningNumbers: {c.winningNumbers}, inputNumbers: {c.inputNumbers})"

proc winCount(c: Card): int =
  for n in c.inputNumbers:
    if n in c.winningNumbers:
      result += 1

proc getCards(data: string): seq[Card] =
  const pattern = re2 "Card\\s*(?P<cardId>[0-9]*):\\s(?P<winningNumbers>[0-9\\s]*)\\s\\|\\s(?P<inputNumbers>[0-9\\s]*)"

  var
    m: RegexMatch2
  
  for line in data.splitLines:
    if not line.find(pattern, m):
      ## Shouldn't ever happen but JIC
      continue

    let
      cardId = parseInt line[m.group("cardId")]
      winningNumbers = line[m.group("winningNumbers")]
      inputNumbers = line[m.group("inputNumbers")]
      card = newCard(
        cardId,
        winningNumbers
          .split(' ')
          .filter((num: string) => num.len() > 0)
          .map((num: string) => parseInt strip(num, true, true)),
        inputNumbers
          .split(' ')
          .filter((num: string) => num.len() > 0)
          .map((num: string) => parseInt strip(num, true, true))
      )
    
    result.add card

proc solve(data: string): int =
  let cards = getCards(data)
  var cardTable = newTable[int, int]() ## Id / Count

  for i in 1 .. cards.len():
    cardTable[i] = 1

  for card in cards:
    for i in card.id + 1 ..< card.id + 1 + card.winCount():
      cardTable[i] += cardTable[card.id]

  for v in cardTable.values():
    result += v

echo "Day 4 - Part 2: ", solve(input)

