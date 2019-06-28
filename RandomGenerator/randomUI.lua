--[[
  Random -- (c) 2019 moorea@ymail.com (MooreaTv)
  Covered by the GNU General Public License version 3 (GPLv3)
  NO WARRANTY
  (contact the author if you need a different license)
]] --
-- our name, our empty default (and unused) anonymous ns
local addon, ns = ...

-- Created by MoLib
local DB = _G[addon]

DB.fontPath = "Interface\\AddOns\\DynamicBoxer\\fixed-font.otf"

function DB:SetupFont(height)
  if DB.fixedFont then
    return DB.fixedFont
  end
  DB.fixedFont = CreateFont("DynBoxerFixedFont")
  DB:Debug("Set font custom height %, path %: %", height, DB.fontPath, DB.fixedFont:SetFont(DB.fontPath, height))
  -- DB:Debug("Set font system: %", DB.fixedFont:SetFont(CombatTextFont:GetFont(), 10))
  return DB.fixedFont
end

-- local x = 0

DB.frame = CreateFrame("Frame")
DB.fontString = DB.frame:CreateFontString()

function DB.OnRandomUIShow(widget, _data)
  DB.debug = randomSaved.debug
  DB:Debug("Randomize UI Show/Regen")
  local e = widget.editBox
  DB.randomEditBox = e
  local newText = DB:RandomId(DB.randomIdLen)
  --[[ width test, alternate narrow and wide
  if x % 2 == 0 then
    newText = "12345678"
    -- newText = "iiiiiiii"
  else
    newText = "WWWWWWWW"
  end
  x = x + 1
  ]]
  e:SetText(newText)
  DB:Debug("Checking size on %", e)
  local height = e.Instructions:GetHeight()
  DB:Debug("Height from edit box is %", height)
  e:HighlightText()
  e:SetJustifyH("CENTER")
  local font = DB:SetupFont(height / 2)
  e:SetFontObject(font)
  DB.fontString:SetFontObject(font)
  DB.fontString:SetText(newText)
  local width = DB.fontString:GetStringWidth()
  DB:Debug("Width with new font is %", width)
  e:SetWidth(width + 4) -- + some or highlights hides most of it/it doesn't fit
  e:SetMaxLetters(DB.randomIdLen)
  e:SetScript("OnTabPressed", function()
    DB:Debug("Tab pressed on random, switching!")
    if DB.currentMainEditBox then
      DB.currentMainEditBox:SetFocus()
    end
  end)
  e:SetScript("OnMouseUp", function(w)
    DB:Debug("Clicked on random, re-highlighting")
    w:HighlightText()
    w:SetCursorPosition(DB.randomIdLen)
  end)
  return true -- stay shown
end

StaticPopupDialogs["DYNBOXER_RANDOM"] = {
  text = "Random token for you to copy and paste",
  button1 = "Randomize",
  button2 = "Close",
  timeout = 0,
  whileDead = true,
  hideOnEscape = 1, -- doesn't help when there is an edit box, real stuff is:
  EditBoxOnEscapePressed = function(self)
    self:GetParent():Hide()
    self:GetParent().editBox:SetMaxLetters(0)
  end,
  OnShow = DB.OnRandomUIShow,
  OnAccept = DB.OnRandomUIShow,
  EditBoxOnEnterPressed = function(self, data)
    DB.OnRandomUIShow(self:GetParent(), data)
  end,
  EditBoxOnTextChanged = function(self, _data)
    -- ignore input and regen instead
    -- but avoid infinite loop
    if #self:GetText() ~= DB.randomIdLen then
      DB.OnRandomUIShow(self:GetParent())
    end
  end,
  hasEditBox = true
}

function DB:RandomGeneratorUI()
  -- TODO: cleanup/move to its own addon (DynamicBoxer Issue #11)
  StaticPopup_Show("DYNBOXER_RANDOM")
end

DB:Print("RandomGenerator " .. DB.manifestVersion .. " by MooreaTv: type /rand help for command list/help.")
