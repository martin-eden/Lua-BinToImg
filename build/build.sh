#!/bin/bash

#
# Combines all Lua sources into one executable file.
#
# Author: Martin Eden
# Last mod.: 2026-06-01
#

#
# Uses "meld" tool to combine Lua sources:
#
#   https://github.com/martin-eden/lua_code_melder
#

set -eu

cd ../src

rm -rf workshop/

lua ../build/create_deploy.lua

bash deploy.sh
rm deploy.sh

mv deploy/workshop/ .
rm -rf deploy/

# Combines all Lua code
meld . bin_to_ppm > ../bin/bin_to_ppm.combined.lua

cd ../bin

# Compile Lua code to reduce size
luac -o bin_to_ppm.combined.luac -s  bin_to_ppm.combined.lua
rm bin_to_ppm.combined.lua

# Add shebang to compiled code
shebang='#!/usr/local/bin/lua'
echo "$shebang" > bin_to_ppm.combined.shebang.luac
cat bin_to_ppm.combined.luac >> bin_to_ppm.combined.shebang.luac
rm bin_to_ppm.combined.luac

mv bin_to_ppm.combined.shebang.luac bin_to_ppm

chmod +x bin_to_ppm

# 2026-06-01
