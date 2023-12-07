# Package

version = "0.1.0"
author = "Isaac Naylor"
description = "Advent of Code 2023"
license = "MIT"
binDir = "bin"
namedBin = {
    "src/day_1/part_1": "d1p1",
    "src/day_1/part_2": "d1p2",
    "src/day_2/part_1": "d2p1",
    "src/day_2/part_2": "d2p2",
    "src/day_3/part_1": "d3p1",
    "src/day_3/part_2": "d3p2",
    "src/day_4/part_1": "d4p1",
    "src/day_4/part_2": "d4p2",
    "src/day_5/part_1": "d5p1", 
    }
    # "src/day_5/part_2", ## Day 5 part 2 is disabled currently
    # "src/day_6/part_1", "src/day_6/part_2",

# Deps

requires "nim"
requires "regex"
requires "weave"