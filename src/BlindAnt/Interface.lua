-- Blind ant on squares grid interface

--[[
  Author: Martin Eden
  Last mod.: 2026-06-15
]]

-- Imports:
local add_to_list = request('!.concepts.list.add_item')

local Directions =
  {
    { 1, 0 },
    { 0, 1 },
    { -1, 0 },
    { 0, -1 },
  }

local Interface =
  {
    -- [Methods]
    Step =
      function(Me)
        local Direction = Directions[Me.direction]

        for i = 1, #Me.Position do
          Me.Position[i] = Me.Position[i] + Direction[i]
        end

        add_to_list(Me.Trace, new(Me.Position))
      end,

    TurnLeft =
      function(Me)
        local direction = Me.direction

        direction = direction + 1

        if (direction == 5) then direction = 1 end

        Me.direction = direction
      end,

    TurnRight =
      function(Me)
        local direction = Me.direction

        direction = direction - 1

        if (direction == 0) then direction = 4 end

        Me.direction = direction
      end,

    -- [State]
    direction = 1,
    Position = { 0, 0 },
    Trace = { { 0, 0 } },
  }

-- Export:
return Interface

--[[
  2026-01-21
  2026-06-01
  2026-06-04
  2026-06-15
]]
