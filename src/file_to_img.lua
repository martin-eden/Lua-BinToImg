-- Frontend for image generator from binary data

--[[
  Author: Martin Eden
  Last mod.: 2026-09-26
]]

--[[ Develop
package.path = package.path .. ';../../../../?.lua'
--]]
require('workshop.base')

local output_format = arg[1]
local input_file_name = arg[2]
local output_file_name = arg[3]

local help_text = [[
Converts any file to image

Usage:

  <image_format> <input_file> <output_file>

  <image_format>: -- output image format. One of:

    png -- (p)ortable (n)etwork (g)raphics
    pgm -- (p)ortable (g)ray(m)ap

  <input_file> -- input file name

  <output_file> -- output file name

-- Martin, 2026-09
]]

local export_to_pgm
do
  local OutputClass = request('!.concepts.StreamIo.Output.File')
  local PamClass = request('!.concepts.codec_netpbm.Pam')
  local save = request('!.concepts.codec_netpbm.compile')
  export_to_pgm =
    function(Image, output_file_name)
      local Output = OutputClass.create(output_file_name)
      Output:Open()

      -- 2 is grayscale
      local Pam = PamClass.create_from_image(2, Image)
      save(Pam, Output)

      Output:Close()
    end
end

local file_to_str = request('!.convert.file_to_str')
local str_to_img = request('str_to_img')
local file_from_str = request('!.convert.file_from_str')

if not (output_format and input_file_name and output_file_name) then
  print(help_text)
  return
end

if not ((output_format == 'png') or (output_format == 'pgm')) then
  error('Unsupported output format.')
end

local Image = str_to_img(file_to_str(input_file_name))

if (output_format == 'pgm') then
  export_to_pgm(Image, output_file_name)
elseif (output_format == 'png') then
  local ShellCommand = request('!.concepts.ShellCommand')
  local os_tmpname = os.tmpname
  local os_remove = os.remove

  local pgm_name = os_tmpname()

  export_to_pgm(Image, pgm_name)

  local Command = ShellCommand.create({ 'pnmtopng', { pgm_name } })

  local is_ok, Result = Command:Execute()
  assert(is_ok, Result.error)

  file_from_str(output_file_name, Result.output)

  os_remove(pgm_name)
end

--[[
  2026 # # #
  2026-09-26
]]
