#!/bin/bash

#
# Create combined Lua file from sources. Create images for Readme.
#
# Author: Martin Eden
# Last mod.: 2026-09-26
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
# )

#
# deploy/
#

cd ../deploy

# Add shebang to compiled code
echo '#!/usr/local/bin/lua' > file_to_img.shebanged.lua
echo >> file_to_img.shebanged.lua
cat file_to_img.lua >> file_to_img.shebanged.lua
rm file_to_img.lua
mv file_to_img.shebanged.lua file_to_img

chmod +x file_to_img

#
# Create images used in "Readme.md"
# (
rm -r ../extras
mkdir ../extras
./file_to_img png /usr/local/bin/lua ../extras/Lua.png
./file_to_img png ../deploy/file_to_img ../extras/file_to_img.png
#
# )
#

# 2026-06-01
# 2026-08-09
