-- Frontend for image generator from binary data

--[[
  Author: Martin Eden
  Last mod.: 2026-06-01
]]

--[[ Develop
package.path = package.path .. ';../../../?.lua'
--]]
require('workshop.base')

local Config =
  {
    input_file_name = arg[1]
  }

-- Imports:
local Ant = request('BlindAnt.Interface')
local ImageBase = request('!.concepts.Image.Interface')
local file_to_str = request('!.convert.file_to_str')
local save_image = request('!.concepts.Codec_Netpbm.compile')
local StdOut = request('!.concepts.StreamIo.Output.Pipe')

local help_text = [[
Converts file to image in PPM text format

Usage:

  lua bin_to_ppm <input_file>

-- Martin, 2026-06-01
]]

if is_nil(Config.input_file_name) then
  print(help_text)
  return
end

local rebase_trace =
  function(Trace)
    if (#Trace == 0) then
      return
    end

    local Mins = { }
    for i = 1, #Trace[1] do
      Mins[i] = Trace[1][i]
    end

    for i = 2, #Trace do
      for j = 1, #Trace[i] do
        if (Trace[i][j] < Mins[j]) then
          Mins[j] = Trace[i][j]
        end
      end
    end

    local Maxs = { }
    for i = 1, #Trace[1] do
      Maxs[i] = Trace[1][i]
    end

    for i = 2, #Trace do
      for j = 1, #Trace[i] do
        if (Trace[i][j] > Maxs[j]) then
          Maxs[j] = Trace[i][j]
        end
      end
    end

    Trace.Deltas = { }
    for i = 1, #Maxs do
      Trace.Deltas[i] = Maxs[i] - Mins[i] + 1
    end

    for i = 1, #Trace do
      for j = 1, #Trace[i] do
        Trace[i][j] = Trace[i][j] - Mins[j] + 1
      end
    end
  end

-- Move ant by one step on spiral path
local move_ant =
  function(Ant)
    local stride_length = Ant.State.stride_length
    local stride_covered = Ant.State.stride_covered
    local num_turns_done = Ant.State.num_turns_done

    if (stride_covered == stride_length) then
      if (num_turns_done == 2) then
        stride_length = stride_length + 1
        num_turns_done = 0
      else
        Ant:TurnLeft()
        num_turns_done = num_turns_done + 1
        stride_covered = 0
      end
    end

    Ant:Step()

    stride_covered = stride_covered + 1

    Ant.State.stride_length = stride_length
    Ant.State.stride_covered = stride_covered
    Ant.State.num_turns_done = num_turns_done
  end

-- (
local process_data_str =
  function(data_str, Image)
    Ant.State =
      {
        stride_length = 1,
        stride_covered = 0,
        num_turns_done = 0,
      }

    for i = 1, #data_str - 1 do
      move_ant(Ant)
    end

    local Trace = Ant:GetTrace()

    rebase_trace(Trace)

    Image.Settings.Width = Trace.Deltas[2]
    Image.Settings.Height = Trace.Deltas[1]

    for i = 1, #Trace do
      Image:SetPixel(Trace[i], { string.byte(data_str, i) / 255 })
    end
  end
-- )

local data_str = file_to_str(Config.input_file_name)
local Image = new(ImageBase)

Image.Settings.ColorFormat = 'gs'

process_data_str(data_str, Image)

save_image(Image, StdOut)

--[[
  2026-01-21
  2026-06-01
]]
