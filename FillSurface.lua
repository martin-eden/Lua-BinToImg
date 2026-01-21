-- Frontend for image generator from binary data

--[[
  Author: Martin Eden
  Last mod.: 2026-01-21
]]

-- [[ Release
require('workshop')
--]]
--[[ Develop
package.path = package.path .. ';../../../?.lua'
require('workshop.base')
--]]

local Config =
  {
    InputFileName = arg[1] or 'FillSurface.lua',
    OutputFileName = arg[2] or 'TextAsImage.pnm',
  }

local Ant = request('BlindAnt.Interface')
local t2s = request('!.table.as_string')

local RebaseTrace =
  function(Trace)
    if (#Trace == 0) then
      return
    end

    local Mins = {}
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

    local Maxs = {}
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

    Trace.Deltas = {}
    for i = 1, #Maxs do
      Trace.Deltas[i] = Maxs[i] - Mins[i] + 1
    end

    for i = 1, #Trace do
      for j = 1, #Trace[i] do
        Trace[i][j] = Trace[i][j] - Mins[j] + 1
      end
    end

  end

local MoveAnt =
  function(Ant)
    -- Move ant by one step on spiral path

    local StrideLength = Ant.State.StrideLength
    local StrideCovered = Ant.State.StrideCovered
    local TurnsDone = Ant.State.TurnsDone

    if (StrideCovered == StrideLength) then
      if (TurnsDone == 2) then
        StrideLength = StrideLength + 1
        TurnsDone = 0
      else
        Ant:TurnLeft()
        TurnsDone = TurnsDone + 1
        StrideCovered = 0
      end
    end

    Ant:Step()

    StrideCovered = StrideCovered + 1

    -- print(Ant.Position[1], Ant.Position[2], Ant.Direction, StrideLength, StrideCovered, TurnsDone)

    Ant.State.StrideLength = StrideLength
    Ant.State.StrideCovered = StrideCovered
    Ant.State.TurnsDone = TurnsDone
  end

-- (
local ProcessInput =
  function(Data, Image)
    Ant.State =
      {
        StrideLength = 1,
        StrideCovered = 0,
        TurnsDone = 0,
      }

    for i = 1, #Data - 1 do
      MoveAnt(Ant)
    end

    local Trace = Ant:GetTrace()

    RebaseTrace(Trace)
    -- print('Rebased trace')
    -- print(t2s(Trace))

    Image.Settings.Width = Trace.Deltas[2]
    Image.Settings.Height = Trace.Deltas[1]

    for i = 1, #Trace do
      -- assert_nil(Image:GetPixel(Trace[i]))
      -- print(i, string.byte(Data, i))
      Image:SetPixel(Trace[i], { string.byte(Data, i) / 255 })
    end

  end
-- )

local InputFile = request('!.concepts.StreamIo.Input.File')
local OutputFile = request('!.concepts.StreamIo.Output.File')
local ImageCodec = request('!.concepts.Netpbm.Interface')
local ImageBase = request('!.concepts.Image.Interface')
local FileAsString = request('!.file_system.file.as_string')

local DataStr = FileAsString(Config.InputFileName)
local Image = new(ImageBase)

do
  Image.Settings.ColorFormat = 'gs'
  ProcessInput(DataStr, Image)
end

do
  OutputFile:Open(Config.OutputFileName)
  do
    ImageCodec.Output = OutputFile
    ImageCodec:Save(Image)
  end
  OutputFile:Close()
end

--[[
  2026-01-21
]]
