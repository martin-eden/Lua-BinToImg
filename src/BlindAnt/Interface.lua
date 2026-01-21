-- Blind ant on squares grid interface

--[[
  Author: Martin Eden
  Last mod.: 2026-06-01
]]

local TurnLeft =
  function(Me)
    local direction = Me.direction

    if (direction == 4) then
      direction = 1
    else
      direction = direction + 1
    end

    Me.direction = direction
  end

local TurnRight =
  function(Me)
    local direction = Me.direction

    if (direction == 1) then
      direction = 4
    else
      direction = direction - 1
    end

    Me.direction = direction
  end

local UpdateTrace =
  function(Me)
    table.insert(Me.Trace, new(Me.Position))
  end

local Step =
  function(Me)
    for i = 1, #Me.Position do
      Me.Position[i] = Me.Position[i] + Me.Directions[Me.direction][i]
    end
    Me:UpdateTrace()
  end

local GetTrace =
  function(Me)
    return new(Me.Trace)
  end

local Interface =
  {
    -- [Main]
    TurnLeft = TurnLeft,
    TurnRight = TurnRight,
    Step = Step,

    GetTrace = GetTrace,

    -- [Internal]
    Directions =
      {
        { 1, 0 },
        { 0, 1 },
        { -1, 0 },
        { 0, -1 },
      },
    direction = 1,
    Position = { 0, 0 },
    Trace = { { 0, 0 } },
    UpdateTrace = UpdateTrace,
  }

-- Export:
return Interface

--[[
  2026-01-21
  2026-06-01
]]
