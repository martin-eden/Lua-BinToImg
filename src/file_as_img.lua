-- Frontend for binary ↔ image codec

--[[
  Author: Martin Eden
  Last mod.: 2026-09-28
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

  local Image = str_to_img(file_to_str(input_file_name))

  if (format == 'pgm') then
    export_to_pgm(Image, output_file_name)
  elseif (format == 'png') then
    local pgm_name = os_tmpname()

    export_to_pgm(Image, pgm_name)

    local Command = ShellCommand.create({ 'pnmtopng', { pgm_name } })

    local is_ok, Result = Command:Execute()
    assert(is_ok, Result.error)

    file_from_str(output_file_name, Result.output)

    os_remove(pgm_name)
  end
elseif (action == 'import') then
  local import_from_pgm
  do
    local InputClass = request('!.concepts.StreamIo.Input.File')
    local load = request('!.concepts.codec_netpbm.parse')
    import_from_pgm =
      function(input_file_name)
        local Input = InputClass.create(input_file_name)
        Input:Open()

        local Pam = load(Input)

        Input:Close()

        return Pam:GetImage()
      end
  end

  local str_from_img = request('str_from_img')

  if (format == 'pgm') then
    file_from_str(
      output_file_name,
      str_from_img(import_from_pgm(input_file_name))
    )
  elseif (format == 'png') then
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

    file_from_str(
      output_file_name,
      str_from_img(import_from_pgm(pgm_name))
    )

    os_remove(pgm_name)
  end
end

--[[
  2026 # # # #
  2026-09-28
]]
