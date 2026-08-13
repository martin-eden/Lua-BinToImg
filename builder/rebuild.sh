#!/bin/bash

#
# Create combined Lua file from sources. Create images for Readme.
#
# Author: Martin Eden
# Last mod.: 2026-08-13
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

lua ../builder/create_deploy.lua

mv deploy/workshop/ .
rm -r -f deploy/

#
# builder/
#

cd ../builder

# ( Combine all Lua code, reformat and strip comments
./meld ../src/ bin_to_ppm > ../deploy/bin_to_ppm.melded.lua

./reformat_lua \
  ../deploy/bin_to_ppm.melded.lua \
  ../deploy/bin_to_ppm.melded.stripped.lua \
  --~keep-comments \
  --right-margin=72
rm ../deploy/bin_to_ppm.melded.lua

mv \
  ../deploy/bin_to_ppm.melded.stripped.lua \
  ../deploy/bin_to_ppm.lua
# )

#
# deploy/
#

cd ../deploy

# Add shebang to compiled code
echo '#!/usr/local/bin/lua' > bin_to_ppm.shebanged.lua
echo >> bin_to_ppm.shebanged.lua
cat bin_to_ppm.lua >> bin_to_ppm.shebanged.lua
rm bin_to_ppm.lua
mv bin_to_ppm.shebanged.lua bin_to_ppm

chmod +x bin_to_ppm

# Create images used in "Readme.md"
cp ../builder/create_readmes_images.sh .
./create_readmes_images.sh
rm create_readmes_images.sh

# 2026-06-01
# 2026-08-09
