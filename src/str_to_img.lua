-- Store string data to image

--[[
  Author: Martin Eden
  Last mod.: 2026-09-27
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
      local update_mins_maxs =
        function(Coords)
          for i, coord in ipairs(Coords) do
            Mins[i] = min(Mins[i], coord)
            Maxs[i] = max(Maxs[i], coord)
          end
        end

      local CoordsIt = LeftSpiral.create()

      update_mins_maxs(CoordsIt:Get())
      for i = 2, #data_str do
        CoordsIt:Advance()
        update_mins_maxs(CoordsIt:Get())
      end
    end

    local image_width = Maxs[1] - Mins[1] + 1
    local image_height = Maxs[2] - Mins[2] + 1

    local Image =
      ImageClass.create(image_width, image_height, 1)

    do
      local set_pixel =
        function(Coords, byte_idx)
          local Color = { str_byte(data_str, byte_idx) / 255 }
          local x = Coords[1] - Mins[1] + 1
          local y = Coords[2] - Mins[2] + 1
          Image:SetColor(Color, x, y)
        end

      local CoordsIt = LeftSpiral.create()

      set_pixel(CoordsIt:Get(), 1)
      for i = 2, #data_str do
        CoordsIt:Advance()
        set_pixel(CoordsIt:Get(), i)
      end
    end

    return Image
  end

--[[
  2026 # # # #
  2026-09-27
]]
