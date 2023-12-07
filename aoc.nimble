# Package

version = "0.1.0"
author = "Isaac Naylor"
description = "Advent of Code 2023"
license = "MIT"
bin = @[
    "src/day_1/part_1", "src/day_1/part_2",
    "src/day_2/part_1", "src/day_2/part_2",
    "src/day_3/part_1", "src/day_3/part_2",
    "src/day_4/part_1", "src/day_4/part_2",
    "src/day_5/part_1", "src/day_5/part_2",
    ]
    # "src/day_6/part_1", "src/day_6/part_2",

# Deps

requires "nim"
requires "regex"
requires "weave"