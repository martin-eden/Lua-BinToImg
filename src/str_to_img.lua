-- Store string data to image

--[[
  Author: Martin Eden
  Last mod.: 2026-09-26
]]

-- Uses "ant" moving in spiral path to place data at coordinates

local AntClass = request('TracedAnt.Interface')

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

local get_trace_dims
do
  local min = math.min
  local max = math.max

  get_trace_dims =
    function(Trace)
      local Mins = { }
      local Maxs = { }

      for i = 1, #Trace[1] do
        Mins[i] = Trace[1][i]
        Maxs[i] = Trace[1][i]
      end

      for i = 2, #Trace do
        for j = 1, #Trace[i] do
          local val = Trace[i][j]
          Mins[j] = min(Mins[j], val)
          Maxs[j] = max(Maxs[j], val)
        end
      end

      return Mins, Maxs
    end
end

local ImageClass = request('!.concepts.Image')
local str_byte = string.byte

-- Export:
return
  function(data_str)
    local Ant = new(AntClass)

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

    local Mins
    local image_width
    local image_height
    do
      local Maxs
      Mins, Maxs = get_trace_dims(Trace)

      image_width = Maxs[2] - Mins[2] + 1
      image_height = Maxs[1] - Mins[1] + 1
    end

    local Image =
      ImageClass.create(image_width, image_height, 1)

    for i = 1, #Trace do
      local Color = { str_byte(data_str, i) / 255 }
      local x = Trace[i][1] - Mins[1] + 1
      local y = Trace[i][2] - Mins[2] + 1
      Image:SetColor(Color, x, y)
    end

    return Image
  end

--[[
  2026 # # #
  2026-09-26
]]
