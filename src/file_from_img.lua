-- Frontend for binary data loader from image

--[[
  Author: Martin Eden
  Last mod.: 2026-09-26
]]

--[[ Develop
package.path = package.path .. ';../../../../?.lua'
--]]
require('workshop.base')

local input_format = arg[1]
local input_file_name = arg[2]
local output_file_name = arg[3]

local help_text = [[
Creates file from image

Usage:

  <image_format> <input_file> <output_file>

  <image_format>: -- input image format. One of:

    png -- (p)ortable (n)etwork (g)raphics
    pgm -- (p)ortable (g)ray(m)ap

  <input_file> -- input file name

  <output_file> -- output file name

-- Martin, 2026-09
]]

local load_pgm
do
  local InputClass = request('!.concepts.StreamIo.Input.File')
  local load = request('!.concepts.codec_netpbm.parse')
  load_pgm =
    function(input_file_name)
      local Input = InputClass.create(input_file_name)
      Input:Open()

      local Pam = load(Input)

      Input:Close()

      return Pam:GetImage()
    end
end

local file_to_str = request('!.convert.file_to_str')
local str_from_img = request('str_from_img')
local file_from_str = request('!.convert.file_from_str')

if not (input_format and input_file_name and output_file_name) then
  print(help_text)
  return
end

if not ((input_format == 'png') or (input_format == 'pgm')) then
  error('Unsupported input format.')
end

if (input_format == 'pgm') then
  file_from_str(output_file_name, str_from_img(load_pgm(input_file_name)))
elseif (input_format == 'png') then
  local ShellCommand = request('!.concepts.ShellCommand')
  local os_tmpname = os.tmpname
  local os_remove = os.remove

  local pgm_name = os_tmpname()

  local Command =
    ShellCommand.create(
      {
        'convert',
        {
          '-compress',
          'none',
          input_file_name,
          'pgm:' .. pgm_name,
        }
      }
    )

  local is_ok, Result = Command:Execute()
  assert(is_ok, Result.error)

  file_from_str(output_file_name, str_from_img(load_pgm(pgm_name)))

  os_remove(pgm_name)
end

--[[
  2026 # # #
  2026-09-26
]]
