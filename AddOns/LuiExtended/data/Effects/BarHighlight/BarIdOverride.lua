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
-- EFFECTS TABLE FOR BAR HIGHLIGHT RELATED OVERRIDES
--------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------
-- When a bar ability proc with a matching id appears, change the icon.
--------------------------------------------------------------------------------------------------------------------------------
--- @class (partial) BarIdOverride
local BarIdOverride =
{
    -- Dragonknight
    [20824] = "LuiExtended/media/icons/abilities/ability_dragonknight_power_lash.dds", -- Power Lash (Flame Lash)

    -- Nightblade
    [35445] = "LuiExtended/media/icons/abilities/ability_nightblade_shadow_image_teleport.dds", -- Shadow Image Teleport (Shadow Image)

    -- Dual Wield
    [126659] = "LuiExtended/media/icons/abilities/ability_weapon_flying_blade_jump.dds", -- Flying Blade (Flying Blade)

    -- Sorcerer
    [108840] = "/esoui/art/icons/ability_sorcerer_unstable_fimiliar_summoned.dds", -- Summon Unstable Familiar (Summon Unstable Familiar)
    [108845] = "/esoui/art/icons/ability_sorcerer_lightning_prey_summoned.dds",    -- Winged Twilight Restore (Summon Winged Twilight)

    -- Support
    [78338] = "/esoui/art/icons/ability_warrior_001.dds", -- Guard (Guard)
    [81415] = "/esoui/art/icons/ability_warrior_001.dds", -- Mystic Guard (Mystic Guard)
    [81420] = "/esoui/art/icons/ability_warrior_001.dds", -- Stalwart Guard (Stalwart Guard)
}

--- @class (partial) BarIdOverride
LUIE.Data.Effects.BarIdOverride = BarIdOverride
