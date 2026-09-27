-- Load string data from image

--[[
  Author: Martin Eden
  Last mod.: 2026-09-28
]]

local LeftSpiral = request('concepts.LeftSpiral')
local huge = math.huge
local min = math.min
local max = math.max
local denormalize = request('!.concepts.Image.Color.Denormalize')
local str_char = string.char
local add_to_list = request('!.concepts.list.add_item')
local tbl_concat = table.concat

return
  function(Image)
    local width = Image:GetWidth()
    local height = Image:GetHeight()

    local data_len = 0

    local min_x, min_y = huge, huge
    do
      local max_x, max_y = -huge, -huge
      local CoordsIt = LeftSpiral.create()
      local area = width * height

      for i = 1, area do
        local Coords = CoordsIt:Get()

        local proposed_min_x = min(min_x, Coords[1])
        local proposed_min_y = min(min_y, Coords[2])
        local proposed_max_x = max(max_x, Coords[1])
        local proposed_max_y = max(max_y, Coords[2])

        local cur_width = (proposed_max_x - proposed_min_x) + 1
        local cur_height = (proposed_max_y - proposed_min_y) + 1
        if (cur_width > width) or (cur_height > height) then
          break
        end

        min_x = proposed_min_x
        min_y = proposed_min_y
        max_x = proposed_max_x
        max_y = proposed_max_y

        CoordsIt:Advance()
        data_len = data_len + 1
      end
    end

    local Chars = { }
    do
      local CoordsIt = LeftSpiral.create()

      for i = 1, data_len do
        local Coords = CoordsIt:Get()

        local x = (Coords[1] - min_x) + 1
        local y = (height - 1) - (Coords[2] - min_y) + 1
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
