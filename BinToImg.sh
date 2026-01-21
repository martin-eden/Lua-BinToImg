#!/bin/sh

#
# Author: Martin Eden
# Last mod.: 2026-01-21
#

#
# Calls Lua script to create text image from binary file.
# Then converts that image from text format to PNG.
#
# Requirements
#
#   "lua" - Lua 5.3 (5.4, 5.5)
#   "pnmtopng" - libnetpbm
#

InputFileName=$1
# InputFileName=/usr/local/bin/lua
# InputFileName=/usr/bin/perl
# InputFileName=/usr/bin/python3
# InputFileName=/usr/bin/avrdude

OutputFileName=Image.pnm

OutputFileName_Png=Image.png

#
# Commands are connected via "&&" because we want script to stop
# when preceding command fails.
#

lua FillSurface.lua $InputFileName $OutputFileName &&
pnmtopng $OutputFileName > $OutputFileName_Png && \
true

# 2026-01-21
