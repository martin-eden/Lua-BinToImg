[![DeepWiki][DeepWiki_Logo]][DeepWiki_Repo] (sometimes AI explains it better)

## What

| Created | Updated | Code size |
|:-------:|:-------:| :-------: |
| 2026-01 | 2026-06 |  < 25 K   |

Converts any binary file to grayscale PNG image.

No data is lost, that's byte-to-pixel conversion.

Lua executable as image:

![Lua executable][lua_code_img]

Tool executable as image:

![Tool executable][bin_to_ppm_img]


## Usage

`$ bin_to_png.sh <input_file>`

Reads given file and writes PNG image to current directory.
Result file name is original name with added `.png` extension.

This [Bash wrapper][bin_to_png] calls Lua file to create image in `.ppm`
format and then converts it to `.png` using `pnmtopng` tool.


## Requirements

* Bash (use Linux)
* Lua 5.3 (5.4, 5.5) (`$ sudo apt install lua`)
* `pnmtopng` tool to convert image to PNG (`$ sudo apt install netpbm`)


## Install/remove

* Copy files from [`bin/`][bin]


## Notes

* Compiled binary uses Lua 5.3

* Practical file size is several megabytes

  I've tested it on 32 MB file. It took 10 minutes, ate 32 GB memory and
  produced square image with 6 K pixels on sides.


## Details

* Implementation uses spiral filling

  For spiral filling I wrote ["ant"][Ant] class and coded spiral
  movement for that ant.

* Feel free to experiment with another filling algorithms

* [`build.sh`][build_sh] creates combined and compiled Lua file in `bin/`.
  It uses my `meld` tool for that

  You can use it to recompile to another Lua version. But you'll need
  full `workshop` repo near current date (2026-06-01) to recompile.


## See also

* [Netpbm codec][Lua-Ppm] -- codec's repo
* [`meld`][meld] -- my tool to combine Lua files
* [`workshop`][workshop] -- my personal Lua framework
* [My other projects][contents]


[DeepWiki_Logo]: https://deepwiki.com/badge.svg
[DeepWiki_Repo]: https://deepwiki.com/martin-eden/Lua-BinToImg

[lua_code_img]: extras/Lua.png
[bin_to_ppm_img]: extras/bin_to_ppm.png

[bin]: bin/
[bin_to_png]: bin/bin_to_png.sh
[Ant]: src/BlindAnt/Interface.lua
[build_sh]: build/build.sh

[Lua-Ppm]: https://github.com/martin-eden/Lua-Ppm
[meld]: https://github.com/martin-eden/lua_code_melder
[workshop]: https://github.com/martin-eden/workshop
[contents]: https://github.com/martin-eden/contents
