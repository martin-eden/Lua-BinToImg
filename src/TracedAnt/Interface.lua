-- Path tracing ant's wrapper

--[[
  Author: Martin Eden
  Last mod.: 2026-09-28
]]

-- Imports:
local add_to_list = request('!.concepts.list.add_item')
local merge_and_patch_table = request('!.table.merge_and_patch')

local Original_Step

local InterfaceChanges =
  {
    -- State extension
    Trace = { },

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

  Original_Step = BlindAnt.Step

  Interface = new(BlindAnt)
  merge_and_patch_table(Interface, InterfaceChanges)
  Interface.Trace = { new(BlindAnt.Position) }
end

-- Export:
return Interface

--[[
  2026-06-15
  2026-09-26
]]
