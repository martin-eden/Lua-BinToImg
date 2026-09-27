-- Store string data to image

--[[
  Author: Martin Eden
  Last mod.: 2026-09-28
]]

-- Empty strings are not accepted

local huge = math.huge
local min = math.min
local max = math.max

local LeftSpiral = request('concepts.LeftSpiral')
local ImageClass = request('!.concepts.Image')
local str_byte = string.byte

-- Export:
return
  function(data_str)
    assert_string(data_str)
    assert(data_str ~= '')

    local Mins = { huge, huge }
    local Maxs = { -huge, -huge }
    do
      local CoordsIt = LeftSpiral.create()

      for i = 1, #data_str do
        local Coords = CoordsIt:Get()
        for dim_i = 1, 2 do
          Mins[dim_i] = min(Mins[dim_i], Coords[dim_i])
          Maxs[dim_i] = max(Maxs[dim_i], Coords[dim_i])
        end
        CoordsIt:Advance()
      end
    end

    local image_width = Maxs[1] - Mins[1] + 1
    local image_height = Maxs[2] - Mins[2] + 1

    local Image =
      ImageClass.create(image_width, image_height, 1)

    do
      local CoordsIt = LeftSpiral.create()

      for i = 1, #data_str do
        local Coords = CoordsIt:Get()

        local Color = { str_byte(data_str, i) / 255 }
        local x = (Coords[1] - Mins[1]) + 1
        local y = (image_height - 1) - (Coords[2] - Mins[2]) + 1
        Image:SetColor(Color, x, y)

        CoordsIt:Advance()
      end
    end

    return Image
  end

--[[
  2026 # # # #
  2026-09-27
]]
