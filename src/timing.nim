import times
import strformat
import sugar

proc timeit*(day, part: int; data: string; fn: (string) -> int): void =
  let startTime = cpuTime()
  let res = fn(data)
  let endTime = cpuTime()

  echo fmt"Day {day} - Part {part}: {res} - {endTime - startTime} ms"