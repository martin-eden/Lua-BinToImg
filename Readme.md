<table>
  <tr>
    <th colspan=3>File as image</th>
  </tr>
  <tr>
    <td>
      <table>
        <tr>
          <th>Input</th>
          <th>Output</th>
        </tr>
        <tr>
          <td>
            any file<br>
          </td>
          <td>
            <code>.png</code><br>
            <code>.pgm</code><br>
          </td>
        </tr>
        <tr>
          <td>
            <code>.png</code><br>
            <code>.pgm</code><br>
          </td>
          <td>
            any file<br>
          </td>
        </tr>
      </table>
    </td>
    <td align=center>
      Codec between any file and grayscale image<br>
      <br>
      No data is lost, that's byte-to-pixel conversion.
    </td>
    <td>
      <table>
        <tr>
          <th>Code size</th>
          <th>💾</th>
        </tr>
        <tr>
          <td align=right>60 K &gt;</td>
          <td>
            <a href="deploy/file_as_img"><code>file_as_img</code></a>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <table>
      <tr>
        <th>Updated</th>
        <td>2026-09-28</td>
      </tr>
      <tr>
        <th>Created</th>
        <td>2026-01</td>
      </tr>
      <tr>
        <th>License</th>
        <td>LGPL3</td>
      </tr>
      <tr>
        <td colspan=2 align=center>
          <a href="https://deepwiki.com/martin-eden/Lua-BinToImg">
            <img src="https://deepwiki.com/badge.svg">
          </a>
        </td>
      </tr>
    </table>
  </tr>
</table>


Lua executable as image:

![Lua executable][lua_code_img]

Combined tool code as image:

![Tool executable][file_as_img_png]


## Usage

```
Converts any file to image. Or converts image to file.

Usage:

  <action> <image_format> <input_file> <output_file>

  <action>: -- what to do. One of:

    export -- encode file as image
    import -- decode file from image

  <image_format>: -- output image format. One of:

    png -- (p)ortable (n)etwork (g)raphics
    pgm -- (p)ortable (g)ray(m)ap

  <input_file> -- input file name

  <output_file> -- output file name

-- Martin, 2026-09
```


## Shipment

Repository contains

  * Compiled code in [`deploy/`](deploy/)
  * Sample output in [`test/`](test/)
  * Complete source code in [`src/`](src/)
  * Rebuild script and tools in [`builder/`](builder/)


## Requirements

* Linux
* Lua 5.5 (5.4, 5.3) (`$ sudo apt install lua`)
* `pnmtopng` tool to convert PGM image to PNG (`$ sudo apt install netpbm`)
* `convert` tool to convert PNG to PGM image (`$ sudo apt install imagemagick`)


## Notes

* Practical data file size is several megabytes

  I've tested it on 30 MB file. Tool value diminishes with data size.

* This is data exploration tool

  You can grasp data structure from image. You can feel size
  relationships from two images.

* Implementation uses spiral filling

  Feel free to experiment with another filling algorithms

* There may be zero bytes after decoded file's data

  That's the property of representing data as image rectangle:
  you can't store exactly 3 values in 2x2 matrix.


## See also

* [`meld`][meld] -- my tool to combine Lua files
* [`workshop`][workshop] -- my personal Lua framework
* [My other projects][contents]


[file_as_img]: deploy/file_as_img

[lua_code_img]: extras/Lua.png
[file_as_img_png]: extras/file_as_img.png

[meld]: https://github.com/martin-eden/lua_code_melder
[workshop]: https://github.com/martin-eden/workshop
[contents]: https://github.com/martin-eden/contents
