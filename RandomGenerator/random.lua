--[[

   Random token generator by MooreaTV moorea@ymail.com
   (c) 2019 All rights reserved
   Licensed under LGPLv3 - No Warranty
   (contact the author if you need a different license)

   Initially was part of DynamicBoxer: Dynamic Team Multiboxing
   ]] --
--
-- our name, our empty default (and unused) anonymous ns
local addon, ns = ...

-- Created by MoLib
local DB = _G[addon]

DB.randomIdLen = 8 -- we generate 8 characters long random ids
randomSaved = {}

function DB:Help(msg)
  DB:Print("Random: " .. msg .. "\n" .. "/rand -- display random token dialog\n" ..
             "/rand debug on/off/level -- for debugging on at level or off.\n" .. "/rand version -- shows addon version")
end

function DB:SetSaved(name, value)
  self[name] = value
  randomSaved[name] = value
  DB:Debug("(Saved) Setting % set to % - randomSaved=%", name, value, randomSaved)
end

function DB.Slash(arg) -- can't be a : because used directly as slash command
  if #arg == 0 then
    -- random id generator (misc bonus util)
    DB:RandomGeneratorUI()
    return
  end
  DB:Debug("Got slash cmd: %", arg)
  local cmd = string.lower(string.sub(arg, 1, 1))
  local posRest = string.find(arg, " ")
  local rest = ""
  if not (posRest == nil) then
    rest = string.sub(arg, posRest + 1)
  end
  if cmd == "v" then
    -- version
    DB:Print("RandomGenerator " .. DB.manifestVersion .. " by MooreaTv")
  elseif DB:StartsWith(arg, "debug") then
    -- debug
    if rest == "on" then
      DB:SetSaved("debug", 1)
    elseif rest == "off" then
      DB:SetSaved("debug", nil)
    else
      DB:SetSaved("debug", tonumber(rest))
    end
    DB:Print(DB:format("DynBoxer debug now %", DB.debug))
  elseif cmd == "d" then
    -- dump
    DB:Print(DB:format("DynBoxer dump of % = " .. DB:Dump(_G[rest]), rest), .7, .7, .9)
  else
    DB:Help('unknown command "' .. arg .. '", usage:')
  end
end

SlashCmdList["Random_Slash_Command"] = DB.Slash

SLASH_Random_Slash_Command1 = "/rand"
SLASH_Random_Slash_Command2 = "/random"

-- DB.debug = 2
DB:Debug("random generator main file loaded")
