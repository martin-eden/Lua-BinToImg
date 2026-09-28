-- Oriented point on squares grid

--[[
  Author: Martin Eden
  Last mod.: 2026-09-28
]]

--[[
  Here we're using mathematical axes orientation: Y axis goes up
]]

--[[
  Storage format

    1 [i] -- direction
    2 [t] -- position
      1 [i] -- axis X coordinate
      2 [i] -- axis Y coordinate
]]

local step
do
  local Directions =
    {
      [1] = { 1, 0 },
      [2] = { 0, 1 },
      [3] = { -1, 0 },
      [4] = { 0, -1 },
    }

  step =
    function(Me)
      local Position = Me[2]
      local Direction = Directions[Me[1]]

      for i = 1, 2 do
        Position[i] = Position[i] + Direction[i]
      end

      Me[2] = Position
    end
end

local turn_left =
  function(Me)
    local direction = Me[1]

    direction = direction + 1
    if (direction == 5) then direction = 1 end

    Me[1] = direction
  end

local turn_right =
  function(Me)
    local direction = Me[1]

    direction = direction - 1
    if (direction == 0) then direction = 4 end

    Me[1] = direction
  end

local Interface
local create
do
  local attach_methods = request('!.table.attach_methods')
  create =
    function()
      local Me = { 1, { 0, 0 } }
      attach_methods(Me, Interface)

      return Me
    end
end

Interface =
  {
    create = create,
    Step = step,
    TurnLeft = turn_left,
    TurnRight = turn_right,
    GetDirection = function(Me) return Me[1] end,
    GetPosition = function(Me) return Me[2] end,
  }

-- Export:
return Interface

--[[
  2026 # # # #
  2026-09-28
]]
