$day = $args[0];

$path = "day_$day"

mkdir $path
New-Item $path/part_1.nim
New-Item $path/part_2.nim
New-Item $path/sample.txt
New-Item $path/input.txt
