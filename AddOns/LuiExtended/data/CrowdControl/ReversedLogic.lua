--[[
    LuiExtended
    License: The MIT License (MIT)
--]]

--- @class (partial) LuiExtended
local LUIE = LUIE

-- Not implemented - list of abilities that ACTION_RESULT_GAINED_DURATION fires in the opposite order of normal
--- @class (partial) ReversedLogic
local ReversedLogic =
{
    -- Quests
    [21876] = true, -- Q4260 West Barrier Teleport
    [21878] = true, -- Q4260 East Barrier Teleport
    [39260] = true, -- Q4917 Push Player Back (Grahtwood - The Blacksap's Hold)

    -- World Bosses
    [83124] = true, -- Ferocious Bellow (Greenshade - World Boss - Thodundor's View)

    -- Dungeons
    [26716] = true, -- Skyward Slam (Stormfist) -- Tempest Island
    [34848] = true, -- Primal Sweep -- Wayrest Sewers
}

--- @class (partial) ReversedLogic
LUIE.Data.CrowdControl.ReversedLogic = ReversedLogic
