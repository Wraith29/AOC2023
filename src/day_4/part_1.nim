import ../timing
import math
import regex
import sequtils
import strutils
import sugar

const input = staticRead("./input.txt")

type Card = ref object
  id: int
  winningNumbers, inputNumbers: seq[int]

proc newCard(id: int; winningNumbers, inputNumbers: seq[int]): Card =
  Card(id: id, inputNumbers: inputNumbers, winningNumbers: winningNumbers)

proc value(c: Card): int =
  for num in c.inputNumbers:
    if num in c.winningNumbers:
      if result == 0:
        result = 1
      else:
        result *= 2

proc solve(data: string): int =
  const pattern = re2 "Card\\s*(?P<cardId>[0-9]*):\\s(?P<winningNumbers>[0-9\\s]*)\\s\\|\\s(?P<inputNumbers>[0-9\\s]*)"

  var
    cards = newSeq[Card]()
    m: RegexMatch2
  
  for line in data.splitLines:
    if not line.find(pattern, m):
      ## Shouldn't ever happen but JIC
      continue

    let
      cardId = line[m.group("cardId")]
      winningNumbers = line[m.group("winningNumbers")]
      inputNumbers = line[m.group("inputNumbers")]

    cards.add(
      newCard(
        parseInt cardId,
        winningNumbers
          .split(' ')
          .filter((num: string) => num.len() > 0)
          .map((num: string) => parseInt strip(num, true, true)),
        inputNumbers
          .split(' ')
          .filter((num: string) => num.len() > 0)
          .map((num: string) => parseInt strip(num, true, true))
      )
    )
  
  cards.map((c: Card) => c.value()).sum()

timeit(4, 1, input, solve)
