-- Path tracing ant's wrapper

--[[
  Author: Martin Eden
  Last mod.: 2026-06-15
]]

-- Imports:
local add_to_list = request('!.concepts.list.add_item')
local merge_and_patch_table = request('!.table.merge_and_patch')

local Original_Step
local Original_Position

local InterfaceChanges =
  {
    -- State extension
    Trace = { Original_Position },

    -- Method override
    Step =
      function(Me)
        Original_Step(Me)

        add_to_list(Me.Trace, new(Me.Position))
      end,
  }

local Interface

do
  -- Imports:
  local BlindAnt = request('^.BlindAnt.Interface')

  Original_Position = BlindAnt.Position
  Original_Step = BlindAnt.Step

  Interface = new(BlindAnt)
  merge_and_patch_table(Interface, InterfaceChanges)
end

-- Export:
return Interface

--[[
  2026-06-15
]]
