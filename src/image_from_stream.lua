-- Load image from stream

--[[
  Author: Martin Eden
  Last mod.: 2026-09-30
]]

-- Empty streams are not accepted

--[[
  We need to read data twice

  First time to figure out dimensions.

  In current design streams are not resettable.
  So we'll use internal array for data.
]]

local huge = math.huge
local LeftSpiral = request('concepts.LeftSpiral')
local min = math.min
local max = math.max
local str_byte = string.byte
local add_to_list = request('!.concepts.list.add_item')
local ImageClass = request('!.concepts.Image')

-- Export:
return
  function(Input)
    local Mins = { huge, huge }
    local Maxs = { -huge, -huge }
    local Bytes = { }
    do
      local CoordsIt = LeftSpiral.create()

      while true do
        local char = Input:Read(1)
        if (char == '') then break end

        do
          local Coords = CoordsIt:Get()
          for dim_i = 1, 2 do
            Mins[dim_i] = min(Mins[dim_i], Coords[dim_i])
            Maxs[dim_i] = max(Maxs[dim_i], Coords[dim_i])
          end
          CoordsIt:Advance()
        end

        add_to_list(Bytes, str_byte(char))
      end
    end

    assert(#Bytes > 0, 'Empty stream.')

    local image_width = Maxs[1] - Mins[1] + 1
    local image_height = Maxs[2] - Mins[2] + 1

    local Image =
      ImageClass.create(image_width, image_height, 1)

    do
      local CoordsIt = LeftSpiral.create()

      for _, byte in ipairs(Bytes) do
        local Color = { byte / 255 }

        local x, y
        do
          local Coords = CoordsIt:Get()
          x = (Coords[1] - Mins[1]) + 1
          y = (image_height - 1) - (Coords[2] - Mins[2]) + 1
        end

        Image:SetColor(Color, x, y)

        CoordsIt:Advance()
      end
    end

    return Image
  end

--[[
  2026 # # # # #
  2026-09-30
]]
