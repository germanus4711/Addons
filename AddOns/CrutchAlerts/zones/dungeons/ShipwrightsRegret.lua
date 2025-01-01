CrutchAlerts = CrutchAlerts or {}
local Crutch = CrutchAlerts

---------------------------------------------------------------------
-- Foreman Bradiggan
---------------------------------------------------------------------
--[[
Who should stack on who?
Tank, Heal, DPS1, DPS2
It would be simplest and most accurate to go by alphabetical order.
I don't want to use player positions because they can differ between
clients.
]]

local firstBombTarget

local function OnSecondSoulBomb(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, targetUnitId)
    local secondBombTarget = Crutch.groupIdToTag[targetUnitId]
    Crutch.dbgOther(string.format("Bomb 2 %d %s %s", targetUnitId, secondBombTarget, GetUnitDisplayName(secondBombTarget)))
    if (not firstBombTarget) then
        -- Crutch.dbgOther("|cFF0000No first bomb target??")
        firstBombTarget = secondBombTarget
        zo_callLater(function() firstBombTarget = nil end, 2000)
        return
    end

    -- First, put the targets in alphabetical order
    local first = GetUnitDisplayName(firstBombTarget)
    local second = GetUnitDisplayName(secondBombTarget)
    if (first > second) then
        local temp = first
        first = second
        second = temp
    end

    -- Then, get the remaining group members
    local third, fourth
    for i = 1, GetGroupSize() do
        local tag = "group" .. tostring(i)
        local name = GetUnitDisplayName(tag)
        if (name ~= first and name ~= second) then
            if (not third) then
                third = name
            else
                fourth = name
            end
        end
    end

    -- Last, put the other two people in alphabetical order
    if (third > fourth) then
        local temp = third
        third = fourth
        fourth = temp
    end

    -- Third will stack on First, and Fourth will stack on Second
    Crutch.dbgOther(string.format("|c00FF00Suggested stacks: %s -> %s ; %s -> %s", third, first, fourth, second))
    local stacks = {
        [first] = third,
        [second] = fourth,
        [third] = first,
        [fourth] = second,
    }
    local toStack = stacks[GetUnitDisplayName("player")]

    -- Put icon on the person we should stack with
    if (OSI) then
        Crutch.SetMechanicIconForUnit(toStack, "odysupporticons/icons/emoji-poop.dds")
        zo_callLater(function() Crutch.RemoveMechanicIconForUnit(toStack) end, 5000)
    end
    Crutch.DisplayNotification(168314, string.format("|cAAAAAASuggested stack: |cff00ff%s|r", toStack), 5000, 0, 0, 0, 0, false)
end

---------------------------------------------------------------------
-- Register/Unregister
---------------------------------------------------------------------
function Crutch.RegisterShipwrightsRegret()
    Crutch.dbgOther("|c88FFFF[CT]|r Registered Shipwright's Regret")

    if (Crutch.savedOptions.shipwrightsRegret.showBombStacks) then
        EVENT_MANAGER:RegisterForEvent(Crutch.name .. "SoulBomb2", EVENT_COMBAT_EVENT, OnSecondSoulBomb)
        EVENT_MANAGER:AddFilterForEvent(Crutch.name .. "SoulBomb2", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_EFFECT_GAINED)
        EVENT_MANAGER:AddFilterForEvent(Crutch.name .. "SoulBomb2", EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, 168314)
    end
end

function Crutch.UnregisterShipwrightsRegret()
    EVENT_MANAGER:UnregisterForEvent(Crutch.name .. "SoulBomb2", EVENT_COMBAT_EVENT)

    Crutch.dbgOther("|c88FFFF[CT]|r Unregistered Shipwright's Regret")
end