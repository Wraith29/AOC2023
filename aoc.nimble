# Package

version = "0.1.0"
author = "Isaac Naylor"
description = "Advent of Code 2023"
license = "MIT"
binDir = "bin"
namedBin = {
    "src/day_1/part_1": "day_1/part_1",
    "src/day_1/part_2": "day_1/part_2",
    "src/day_2/part_1": "day_2/part_1",
    "src/day_2/part_2": "day_2/part_2",
    "src/day_3/part_1": "day_3/part_1",
    "src/day_3/part_2": "day_3/part_2",
    "src/day_4/part_1": "day_4/part_1",
    "src/day_4/part_2": "day_4/part_2",
    "src/day_5/part_1": "day_5/part_1", 
}.toTable()
    # "src/day_5/part_2", ## Day 5 part 2 is disabled currently
    # "src/day_6/part_1", "src/day_6/part_2",

# Deps

requires "nim"
requires "regex"
requires "weave"

# Tasks

task cb, "Clean build artifacts":
    rmDir "bin"

task day, "Run a specific day":
    let dayNumber = commandLineParams[3]

    exec "nim c -d:release -o:bin/day_" & dayNumber & "/part_1.exe src/day_" & dayNumber & "/part_1.nim"
    exec "nim c -d:release -o:bin/day_" & dayNumber & "/part_2.exe src/day_" & dayNumber & "/part_2.nim"

    withDir("bin/day_" & dayNumber):
        exec findExe("part_1")
        exec findExe("part_2")
