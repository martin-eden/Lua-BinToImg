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

# * file_to_img
./meld ../src/ file_to_img > ../deploy/file_to_img.melded.lua

./reformat_lua \
  ../deploy/file_to_img.melded.lua \
  ../deploy/file_to_img.melded.stripped.lua \
  --~keep-comments \
  --right-margin=72
rm ../deploy/file_to_img.melded.lua

mv \
  ../deploy/file_to_img.melded.stripped.lua \
  ../deploy/file_to_img.lua

# * file_from_img
./meld ../src/ file_from_img > ../deploy/file_from_img.melded.lua

./reformat_lua \
  ../deploy/file_from_img.melded.lua \
  ../deploy/file_from_img.melded.stripped.lua \
  --~keep-comments \
  --right-margin=72
rm ../deploy/file_from_img.melded.lua

mv \
  ../deploy/file_from_img.melded.stripped.lua \
  ../deploy/file_from_img.lua

# )

#
# deploy/
#

cd ../deploy

# ( Add shebang to compiled code

# * file_to_img
echo '#!/usr/local/bin/lua' > file_to_img.shebanged.lua
echo >> file_to_img.shebanged.lua
cat file_to_img.lua >> file_to_img.shebanged.lua
rm file_to_img.lua
mv file_to_img.shebanged.lua file_to_img
chmod +x file_to_img

# * file_from_img
echo '#!/usr/local/bin/lua' > file_from_img.shebanged.lua
echo >> file_from_img.shebanged.lua
cat file_from_img.lua >> file_from_img.shebanged.lua
rm file_from_img.lua
mv file_from_img.shebanged.lua file_from_img
chmod +x file_from_img

# )
#
# Create test data
#
rm -r ../test/output
mkdir ../test/output
./file_to_img pgm ../test/input.bin ../test/output/test.pgm
./file_to_img png ../test/input.bin ../test/output/test.png
./file_from_img pgm ../test/output/test.pgm ../test/output/test_from_pgm.bin
./file_from_img png ../test/output/test.png ../test/output/test_from_png.bin

#
# Create images used in "Readme.md"
#
# rm -r ../extras
# mkdir ../extras
# ./file_to_img png /usr/local/bin/lua ../extras/Lua.png
# ./file_to_img png ../deploy/file_to_img ../extras/file_to_img.png

# 2026-06-01
# 2026-08-09
# 2026-09-28
