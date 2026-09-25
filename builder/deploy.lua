-- Load modules, get list of all required Lua files, copy them

--[[
  Author: Martin Eden
  Last mod.: 2026-09-26
]]

--[[
  How to use

  * Include root modules in <ModulesList>

  * Do one of

    * Copy this file to root Lua source directory

    * Call this file from Lua source directory:

        $ lua ../builder/deploy.lua

  Make sure that main Lua file executes without errors when
  loaded as module. If needed, make changes to it to behave so.
]]

--
local Modules = { 'file_to_img' }
--
package.path = package.path .. ';../../../../?.lua'
--
local ModulePaths
do
  local observe_modules = require('workshop.system.observe_modules')

  arg[1] = 'png'
  arg[2] = './file_to_img.lua'
  arg[3] = '/dev/null'
  ModulePaths = observe_modules(Modules)
end
--
require('workshop.base')

local FilesList
do
  local add_to = request('!.concepts.list.add_item')
  FilesList = { }
  for _, ModuleLoc in ipairs(ModulePaths) do
    add_to(FilesList, ModuleLoc[2])
  end
end

local deploy = request('!.mechs.deploy')

deploy(FilesList)
--

--[[
  202?
  2026 # # # #
  2026-09-24
]]
