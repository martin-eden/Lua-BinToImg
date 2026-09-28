-- Iterator over left-turning square spiral cells

--[[
  Author: Martin Eden
  Last mod.: 2026-09-28
]]

-- Here we're using mathematical axes: Y goes up

--[[
  Storage format

    1 [t] -- oriented point instance
    2 [t] -- our spiral state
      1 [i] -- stride covered
      2 [i] -- stride length
      3 [i] -- num turns done
]]

local advance =
  function(Me)
    local Point = Me[1]
    local State = Me[2]

    local stride_covered = State[1]
    local stride_length = State[2]
    local num_turns_done = State[3]

    if (stride_covered == stride_length) then
      if (num_turns_done == 2) then
        stride_length = stride_length + 1
        num_turns_done = 0
      else
        Point:TurnRight()
        num_turns_done = num_turns_done + 1
        stride_covered = 0
      end
    end

    Point:Advance()

    stride_covered = stride_covered + 1

    State[1] = stride_covered
    State[2] = stride_length
    State[3] = num_turns_done
  end

local Interface
local create
do
  local Point = request('OrientedPoint')
  local attach_methods = request('!.table.attach_methods')
  create =
    function()
      local Me = { Point.create(), { 0, 1, 0 } }
      attach_methods(Me, Interface)

      return Me
    end
end

Interface =
  {
    create = create,
    Advance = advance,
    Get = function(Me) return Me[1]:GetPosition() end,
  }

-- Export:
return Interface

--[[
  2026-09-27
]]
