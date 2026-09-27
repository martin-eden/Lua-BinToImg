local huge = math.huge
local SpiralIterator = request('SpiralIterator')
local denormalize = request('!.concepts.Image.Color.Denormalize')
local tbl_concat = table.concat

-- Export:
return
  function(Image)
    local width = Image:GetWidth()
    local height = Image:GetHeight()

    local area = width * height

    local Mins = { huge, huge }
    do
      local update_mins =
        function(Coords)
          for i, coord in ipairs(Coords) do
            Mins[i] = min(Mins[i], coord)
          end
        end
      local Iterator = SpiralIterator.create()

      update_mins(Mins, Iterator:Get())
      for i = 2, area do
        Iterator:Advance()
        update_mins(Mins, Iterator:Get())
      end
    end

    local Chars = { }
    do
      local add_char_from_coords =
        function(Coords)
          local x = Coords[1] - Mins[1] + 1
          local y = Coords[2] - Mins[2] + 1
          local Color = Image:GetColor(x, y)
          denormalize(Color)
          add_to_list(Chars, str_char(Color[1]))
        end
      local Iterator = SpiralIterator.create()

      add_char_from_coords(Iterator:Get())
      for i = 2, area do
        Iterator:Advance()
        add_char_from_coords(Iterator:Get())
      end
    end

    return tbl_concat(Chars)
  end
