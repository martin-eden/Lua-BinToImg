## What

(2026-01)

Converts binary file to grayscale PNG image.

No data is lost, that's byte-to-pixel conversion.

Lua executable as image:

![Lua executable][LuaCode]


## Requirements

* Bash
* Lua 5.3 (5.4, 5.5)
* `libnetpbm` toolset to convert image to PNG


## Install/remove

* Clone


## Usage

`$ BinToImg.sh <InputFileName>`

It reads given file and writes PNG image to current directory.
For implementation details see [`BinToImg.sh`][BinToImg].


## Notes

* That's a one-evening project.

* Implementation uses spiral filling. For spiral filling I wrote ["ant"][Ant]
class and coded spiral logic that ant.

* Feel free to experiment with another filling algorithms.

* Distribution format is standalone frontend scripts and packed Lua
backend. Current version of my personal Lua framework available [here][workshop].


## See also

* [My other projects][contents]


[BinToImg]: BinToImg.sh
[Ant]: BlindAnt/Interface.lua
[LuaCode]: Images/Lua.png
[workshop]: https://github.com/martin-eden/workshop
[contents]: https://github.com/martin-eden/contents
