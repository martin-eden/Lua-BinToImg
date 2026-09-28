-- Load string data from image

--[[
  Author: Martin Eden
  Last mod.: 2026-09-28
]]

local huge = math.huge
local LeftSpiral = request('concepts.LeftSpiral')
local min = math.min
local denormalize = request('!.concepts.Image.Color.Denormalize')
local str_char = string.char
local add_to_list = request('!.concepts.list.add_item')
local tbl_concat = table.concat

return
  function(Image)
    local width = Image:GetWidth()
    local height = Image:GetHeight()

    local area = width * height

    local Mins = { huge, huge }
    do
      local CoordsIt = LeftSpiral.create()
      for i = 1, area do
        local Coords = CoordsIt:Get()
        for dim_i, coord in ipairs(Coords) do
          Mins[dim_i] = min(Mins[dim_i], coord)
        end
        CoordsIt:Advance()
      end
    end

    local Chars = { }
    do
      local CoordsIt = LeftSpiral.create()

      for i = 1, area do
        local Coords = CoordsIt:Get()

        local x = (Coords[1] - Mins[1]) + 1
        local y = (height - 1) - (Coords[2] - Mins[2]) + 1

        if
          not (
            ((x >= 1) and (x <= width)) and
            ((y >= 1) and (y <= height))
          )
        then
          break
        end

        local Color = denormalize(Image:GetColor(x, y))

        add_to_list(Chars, str_char(Color[1]))

        CoordsIt:Advance()
      end
    end

    return tbl_concat(Chars)
  end

--[[
  2026 #
  2026-09-28
]]
