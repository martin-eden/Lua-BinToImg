-- Frontend for binary ↔ image codec

--[[
  Author: Martin Eden
  Last mod.: 2026-09-30
]]

--[[ Develop
package.path = package.path .. ';../../../../?.lua'
--]]
require('workshop.base')

local action = arg[1]
local format = arg[2]
local input_file_name = arg[3]
local output_file_name = arg[4]

local help_text = [[
Converts any file to image. Or converts image to file.

Usage:

  <action> <image_format> <input_file> <output_file>

  <action>: -- what to do. One of:

    export -- encode file as image
    import -- decode file from image

  <image_format>: -- output image format. One of:

    png -- (p)ortable (n)etwork (g)raphics
    pgm -- (p)ortable (g)ray(m)ap

  <input_file> -- input file name

  <output_file> -- output file name

-- Martin, 2026-09
]]

if not
  (action and format and input_file_name and output_file_name)
then
  print(help_text)
  return
end

if not ((format == 'png') or (format == 'pgm')) then
  error('Unsupported image format.')
end

local ShellCommand = request('!.concepts.ShellCommand')
local file_from_str = request('!.convert.file_from_str')
local os_tmpname = os.tmpname
local os_remove = os.remove

if (action == 'export') then
  local img_from_bin
  do
    local InputFile = request('!.concepts.StreamIo.Input.File')
    local image_from_stream = request('image_from_stream')
    local OutputFile = request('!.concepts.StreamIo.Output.File')
    local PamClass = request('!.concepts.codec_netpbm.Pam')
    local save = request('!.concepts.codec_netpbm.compile')
    img_from_bin =
      function(output_file_name, input_file_name)
        local Image
        do
          local Input = InputFile.create(input_file_name)
          Input:Open()
          Image = image_from_stream(Input)
          Input:Close()
        end
        do
          local Output = OutputFile.create(output_file_name)
          Output:Open()
          -- 2 is grayscale
          local Pam = PamClass.create_from_image(2, Image)
          save(Pam, Output)
          Output:Close()
        end
      end
  end

  if (format == 'pgm') then
    img_from_bin(output_file_name, input_file_name)
  elseif (format == 'png') then
    local pgm_name = os_tmpname()

    img_from_bin(pgm_name, input_file_name)

    local Command =
      ShellCommand.create(
        {
          'convert',
          {
            'pgm:' .. pgm_name,
            'png:' .. output_file_name,
          }
        }
      )

    local is_ok, Result = Command:Execute()
    assert(is_ok, Result.error)

    os_remove(pgm_name)
  end
elseif (action == 'import') then
  local bin_from_img
  do
    local OutputFile = request('!.concepts.StreamIo.Output.File')
    local InputFile = request('!.concepts.StreamIo.Input.File')
    local load = request('!.concepts.codec_netpbm.parse')
    local image_to_stream = request('image_to_stream')
    bin_from_img =
      function(output_file_name, input_file_name)
        local Output = OutputFile.create(output_file_name)
        Output:Open()
        local Input = InputFile.create(input_file_name)
        Input:Open()
        local Image = load(Input):GetImage()
        Input:Close()
        image_to_stream(Image, Output)
        Output:Close()
      end
  end

  if (format == 'pgm') then
    bin_from_img(output_file_name, input_file_name)
  elseif (format == 'png') then
    local pgm_name = os_tmpname()

    local Command =
      ShellCommand.create(
        {
          'convert',
          {
            '-compress',
            'none',
            'png:' .. input_file_name,
            'pgm:' .. pgm_name,
          }
        }
      )

    local is_ok, Result = Command:Execute()
    assert(is_ok, Result.error)

    bin_from_img(output_file_name, pgm_name)

    os_remove(pgm_name)
  end
end

--[[
  2026 # # # # #
  2026-09-30
]]
