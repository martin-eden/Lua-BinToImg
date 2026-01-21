## What

(2026-01)

Converts any binary file to grayscale PNG image.

No data is lost, that's byte-to-pixel conversion.

Lua executable as image:

![Lua executable][lua_code_img]


## Requirements

* Bash
* Lua 5.3 (5.4, 5.5)
* `libnetpbm` toolset to convert image to PNG


## Install/remove

* Copy files from [`bin/`][bin]


## Usage

`$ bin_to_png.sh <input_file>`

It reads given file and writes PNG image to current directory.
Result file name is original name with added `.png` extension.


## Details

[Shell script][bin_to_png] wraps my Lua tool that converts any binary
file to image in PNM format (text format). Then it calls `pnmtopng`
tool to convert it to PNG.

* Implementation uses spiral filling. For spiral filling I wrote ["ant"][Ant]
class and coded spiral logic for that ant.

* Feel free to experiment with another filling algorithms.

* Distribution format is standalone frontend scripts and packed Lua
backend. Current version of my personal Lua framework is available [here][workshop].

* [`build.sh`][build_sh] creates combined Lua file in `bin/`.
  It uses my "meld" tool for that.

## See also

* [`meld`][meld] -- my tool to combine Lua files
* [`workshop`][workshop] -- my personal Lua framework
* [My other projects][contents]

[lua_code_img]: extras/Lua.png
[bin]: bin/
[bin_to_png]: src/bin_to_png.sh
[Ant]: src/BlindAnt/Interface.lua
[build_sh]: build/build.sh

[meld]: https://github.com/martin-eden/lua_code_melder
[workshop]: https://github.com/martin-eden/workshop
[contents]: https://github.com/martin-eden/contents
