#!/bin/bash

#
# Create images of Lua and compiled code. They are used in "Readme.md"
#
# Author: Martin Eden
# Last mod.: 2026-06-06
#

set -eu

file_to_png() {
  local input_file="$1"
  local output_file="$2"

  local tmp_file_bin=/tmp/bin_to_png.work.bin
  local tmp_file_png=/tmp/bin_to_png.work.bin.png

  cp "$input_file" $tmp_file_bin
  ../bin/bin_to_png.sh $tmp_file_bin
  rm $tmp_file_bin
  mv $tmp_file_png "$output_file"
}

file_to_png '/usr/local/bin/lua' '../extras/Lua.png'
file_to_png '../bin/bin_to_ppm' '../extras/bin_to_ppm.png'

# 2026-06-06
