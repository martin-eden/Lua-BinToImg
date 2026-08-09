#!/bin/sh

#
# Author: Martin Eden
# Last mod.: 2026-08-09
#

#
# Calls Lua script that creates image in PNM format from binary file.
# Then calls tool to convert image from PNM to PNG.
#
# Required tools:
#
#   lua -- Lua 5.3 (5.4, 5.5) -- $ sudo apt install lua
#   pnmtopng -- libnetpbm -- $ sudo apt install netpbm
#

set -eu

print_help() {
  cat <<'HELP'
Convert any file to PNG

$ bin_to_png.sh <input_file>

Creates output .png file with with same name and location as <input_file>
HELP
}

if [ $# -eq 0 ]; then
  print_help
  exit 0
fi

input_file="$1"

output_file_ppm="${input_file}.ppm"
output_file_png="${input_file}.png"

./bin_to_ppm "$input_file" > "$output_file_ppm"

pnmtopng "$output_file_ppm" > "$output_file_png"

rm "$output_file_ppm"

# 2026-01-21
# 2026-05-30
# 2026-06-01
