-- Blind ant on squares grid interface

--[[
  Author: Martin Eden
  Last mod.: 2026-01-21
]]

local TurnLeft =
  function(self)
    local Direction = self.Direction

    if (Direction == 4) then
      Direction = 1
    else
      Direction = Direction + 1
    end

    self.Direction = Direction
  end

local TurnRight =
  function(self)
    local Direction = self.Direction

    if (Direction == 1) then
      Direction = 4
    else
      Direction = Direction - 1
    end

    self.Direction = Direction
  end

local UpdateTrace =
  function(self)
    table.insert(self.Trace, new(self.Position))
  end

local Step =
  function(self)
    for i = 1, #self.Position do
      self.Position[i] = self.Position[i] + self.Directions[self.Direction][i]
    end
    self:UpdateTrace()
  end

local GetTrace =
  function(self)
    return new(self.Trace)
  end

return
  {
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
    Direction = 1,
    Position = { 0, 0 },
    Trace = { { 0, 0 } },
    UpdateTrace = UpdateTrace,
    State = {},
  }

--[[
  2026-01-21
]]
