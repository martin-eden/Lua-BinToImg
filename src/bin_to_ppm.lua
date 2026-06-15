-- Frontend for image generator from binary data

--[[
  Author: Martin Eden
  Last mod.: 2026-06-15
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
local file_to_str = request('!.convert.file_to_str')
local Ant = request('TracedAnt.Interface')
local Image = request('!.concepts.Image.Interface')
local StdOut = request('!.concepts.StreamIo.Output.Pipe')
local save_image = request('!.concepts.codec_netpbm.compile')

local help_text = [[
Converts file to image in PPM text format

Usage:

  lua bin_to_ppm <input_file>

-- Martin, 2026-06-04
]]

if is_nil(Config.input_file_name) then
  print(help_text)
  return
end

local get_trace_dims =
  function(Trace)
    local Mins = { }
    local Maxs = { }

    for i = 1, #Trace[1] do
      Mins[i] = Trace[1][i]
      Maxs[i] = Trace[1][i]
    end

    for i = 2, #Trace do
      for j = 1, #Trace[i] do
        if (Trace[i][j] < Mins[j]) then
          Mins[j] = Trace[i][j]
        end
        if (Trace[i][j] > Maxs[j]) then
          Maxs[j] = Trace[i][j]
        end
      end
    end

    local Deltas = { }

    for i = 1, #Maxs do
      Deltas[i] = Maxs[i] - Mins[i] + 1
    end

    return Mins, Maxs, Deltas
  end

local rebase_trace =
  function(Trace, Mins)
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
local str_to_image =
  function(data_str)
    local Image = new(Image)
    local Ant = new(Ant)

    Image.Settings.ColorFormat = 'gs'

    Ant.State =
      {
        stride_length = 1,
        stride_covered = 0,
        num_turns_done = 0,
      }

    for i = 1, #data_str - 1 do
      move_ant(Ant)
    end

    local Trace = Ant.Trace

    do
      local Mins, Maxs, Deltas = get_trace_dims(Trace)

      rebase_trace(Trace, Mins)

      Image.Settings.Width = Deltas[2]
      Image.Settings.Height = Deltas[1]
    end

    for i = 1, #Trace do
      Image:SetPixel(Trace[i], { string.byte(data_str, i) / 255 })
    end

    return Image
  end
-- )

do
  local data_str = file_to_str(Config.input_file_name)

  local Image = str_to_image(data_str)

  save_image(Image, StdOut)
end

--[[
  2026-01-21
  2026-06-01
  2026-06-04
]]
