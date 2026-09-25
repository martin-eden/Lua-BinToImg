[![DeepWiki][DeepWiki_Logo]][DeepWiki_Repo] will answer your questions

## What

<table>
  <tr>
    <th colspan=3 align=center>File to image</th>
  </tr>
  <tr>
    <td>
      <table>
        <tr>
          <th>Updated</th>
          <td>2026-09-26</td>
        </tr>
        <tr>
          <th>Created</th>
          <td>2026-01</td>
        </tr>
        <tr>
          <th>Code size</th>
          <td>&lt; 50 K</td>
        </tr>
        <tr>
          <th>License</th>
          <td>LGPL3</td>
        </tr>
      </table>
    </td>
    <td align=center>
      Converts any file to grayscale image.
    </td>
    <td>
      <table>
        <tr>
          <th>Input</th>
          <th>Output</th>
        </tr>
        <tr>
          <td>
            <code>*</code><br>
          </td>
          <td>
            <code>.png</code><br>
            <code>.pgm</code><br>
          </td>
        </tr>
        <tr>
          <td colspan=2 align=center>
            💾<a href="deploy/file_to_img"><code>file_to_img</code></a>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

No data is lost, that's byte-to-pixel conversion.

Lua executable as image:

![Lua executable][lua_code_img]

Combined tool code as image:

![Tool executable][file_to_img_png]


## Usage

```
Converts any file to image

Usage:

  <image_format> <input_file> <output_file>

  <image_format>: -- output image format. One of:

    png -- (p)ortable (n)etwork (g)raphics
    pgm -- (p)ortable (g)ray(m)ap

  <input_file> -- input file name

  <output_file> -- output file name

-- Martin, 2026-09
```

Reads given file and writes `.png` or `.pgm` image file.


## Shipment

Repository contains

  * Compiled code in [`deploy/`](deploy/)
  * Sample output in [`extras/`](extras/)
  * Complete source code in [`src/`](src/)
  * Rebuild script and tools in [`builder/`](builder/)


## Requirements

* Linux
* Lua 5.5 (5.4, 5.3) (`$ sudo apt install lua`)
* `pnmtopng` tool to convert image to PNG (`$ sudo apt install netpbm`)


## Install/remove

* Copy file [`file_to_img`][file_to_img] from `deploy/`.


## Notes

* Practical data file size is several megabytes

  I've tested it on 30 MB file.

  Tool value diminishes with data size.
  It is not designed to be fast or efficient for large files.

* This is data exploration tool

  You can grasp data structure from image. You can feel size
  relationships from two images.

* Implementation uses spiral filling

  For spiral filling I wrote ["ant"][Ant] class and coded spiral
  movement for that ant.

  Feel free to experiment with another filling algorithms


## See also

* [`meld`][meld] -- my tool to combine Lua files
* [`workshop`][workshop] -- my personal Lua framework
* [My other projects][contents]


[DeepWiki_Logo]: https://deepwiki.com/badge.svg
[DeepWiki_Repo]: https://deepwiki.com/martin-eden/Lua-BinToImg

[lua_code_img]: extras/Lua.png
[file_to_img_png]: extras/file_to_img.png

[file_to_img]: deploy/file_to_img

[Ant]: src/BlindAnt/Interface.lua

[meld]: https://github.com/martin-eden/lua_code_melder
[workshop]: https://github.com/martin-eden/workshop
[contents]: https://github.com/martin-eden/contents
