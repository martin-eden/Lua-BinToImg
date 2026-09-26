#!/bin/bash

#
# Create combined Lua file from sources. Create images for Readme.
#
# Author: Martin Eden
# Last mod.: 2026-09-28
#

#
# Results are placed in "deploy/"
#
# Toolchain uses my "lua code melder" tool to combine files into one:
#
#   https://github.com/martin-eden/lua_code_melder
#
# Toolchain uses my "lua code formatter" tool to strip comments:
#
#   https://github.com/martin-eden/lua_code_formatter
#

set -e -u

#
# src/
#

cd ../src

rm -r -f workshop/

lua ../builder/deploy.lua

mv deploy/workshop/ .
rm -r deploy/

#
# builder/
#

cd ../builder

# ( Combine all Lua code, reformat and strip comments

./meld ../src/ file_as_img > ../deploy/file_as_img.melded.lua

./reformat_lua \
  ../deploy/file_as_img.melded.lua \
  ../deploy/file_as_img.melded.stripped.lua \
  --~keep-comments \
  --right-margin=72
rm ../deploy/file_as_img.melded.lua

mv \
  ../deploy/file_as_img.melded.stripped.lua \
  ../deploy/file_as_img.lua

# )

#
# deploy/
#

cd ../deploy

# ( Add shebang to compiled code

echo '#!/usr/local/bin/lua' > file_as_img.shebanged.lua
echo >> file_as_img.shebanged.lua
cat file_as_img.lua >> file_as_img.shebanged.lua
rm file_as_img.lua
mv file_as_img.shebanged.lua file_as_img
chmod +x file_as_img

# )

#
# Create test data
#
rm -r ../test/output
mkdir ../test/output
./file_as_img export pgm ../test/input.bin ../test/output/test.pgm
./file_as_img export png ../test/input.bin ../test/output/test.png
./file_as_img import pgm ../test/output/test.pgm ../test/output/test_from_pgm.bin
./file_as_img import png ../test/output/test.png ../test/output/test_from_png.bin

#
# Create images used in "Readme.md"
#
# rm -r ../extras
# mkdir ../extras
./file_as_img export png /usr/local/bin/lua ../extras/Lua.png
./file_as_img export png ../deploy/file_as_img ../extras/file_as_img.png

# 2026-06-01
# 2026-08-09
# 2026-09-28
