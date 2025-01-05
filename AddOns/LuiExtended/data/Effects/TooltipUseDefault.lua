--[[
    LuiExtended
    License: The MIT License (MIT)
--]]

--- @class (partial) LuiExtended
local LUIE = LUIE

local Tooltips = LUIE.Data.Tooltips
local Unitnames = LUIE.Data.UnitNames
local Zonenames = LUIE.Data.ZoneNames
local Abilities = LUIE.Data.Abilities

local zo_strformat = zo_strformat

--------------------------------------------------------------------------------------------------------------------------------
-- LUIE for the most part overwrites default ability tooltips due to the fact they are only exposed for buffs/debuffs that are on the player. In some cases there is no description with scaling or we need to still use the default where possible.
-- The most noteworthy case of this is Mundus Boons, where there is a tooltip but no description. We want to display a generic tooltip describing the effect if mousing over another player - but display the default value with accurate number for self.
--------------------------------------------------------------------------------------------------------------------------------
--- @class (partial) TooltipUseDefault
local TooltipUseDefault =
{
    [13940] = true, -- Boon: The Warrior
    [13943] = true, -- Boon: The Mage
    [13974] = true, -- Boon: The Serpent
    [13975] = true, -- Boon: The Thief
    [13976] = true, -- Boon: The Lady
    [13977] = true, -- Boon: The Steed
    [13978] = true, -- Boon: The Lord
    [13979] = true, -- Boon: The Apprentice
    [13980] = true, -- Boon: The Ritual
    [13981] = true, -- Boon: The Lover
    [13982] = true, -- Boon: The Atronach
    [13984] = true, -- Boon: The Shadow
    [13985] = true, -- Boon: The Tower
}

--- @class (partial) TooltipUseDefault
LUIE.Data.Effects.TooltipUseDefault = TooltipUseDefault
