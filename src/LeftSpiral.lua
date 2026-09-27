-- Iterator over left-turning square spiral cells

--[[
  Author: Martin Eden
  Last mod.: 2026-09-27
]]

--[[
  Here (unlike [BlindAnt] we're using screen/image axes: Y goes down.
]]

--[[
  Storage format

    1 [t] -- "blind ant" instance
    2 [t] -- our spiral state
      1 [i] -- stride covered
      2 [i] -- stride length
      3 [i] -- num turns done
]]

local get_coords =
  function(Me)
    return new(Me[1].Position)
  end

local advance =
  function(Me)
    local Ant = Me[1]
    local State = Me[2]

    local stride_covered = State[1]
    local stride_length = State[2]
    local num_turns_done = State[3]

    if (stride_covered == stride_length) then
      if (num_turns_done == 2) then
        stride_length = stride_length + 1
        num_turns_done = 0
      else
        Ant:TurnRight()
        num_turns_done = num_turns_done + 1
        stride_covered = 0
      end
    end

    Ant:Step()

    stride_covered = stride_covered + 1

    State[1] = stride_covered
    State[2] = stride_length
    State[3] = num_turns_done
  end

local Interface
local create
do
  local Ant = request('BlindAnt.Interface')
  local attach_methods = request('!.table.attach_methods')
  create =
    function()
      local Me = { new(Ant), { 0, 1, 0 } }
      attach_methods(Me, Interface)

      return Me
    end
end

Interface =
  {
    create = create,
    Get = get_coords,
    Advance = advance,
  }

-- Export:
return Interface

--[[
  2026-09-27
]]
