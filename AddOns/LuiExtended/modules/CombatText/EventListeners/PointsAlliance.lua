--[[
    LuiExtended
    License: The MIT License (MIT)
--]]

---@class (partial) LuiExtended
local LUIE = LUIE
LUIE.CombatTextPointsAllianceEventListener = LUIE.CombatTextEventListener:Subclass()
local CombatTextPointsAllianceEventListener = LUIE.CombatTextPointsAllianceEventListener

local eventType = LUIE.Data.CombatTextConstants.eventType
local pointType = LUIE.Data.CombatTextConstants.pointType
---@diagnostic disable-next-line: duplicate-set-field
function CombatTextPointsAllianceEventListener:New()
    local obj = LUIE.CombatTextEventListener:New()
    obj:RegisterForEvent(EVENT_ALLIANCE_POINT_UPDATE, function (...)
        self:OnEvent(...)
    end)
    return obj
end

function CombatTextPointsAllianceEventListener:OnEvent(alliancePoints, playSound, difference)
    if LUIE.CombatText.SV.toggles.showPointsAlliance then
        self:TriggerEvent(eventType.POINT, pointType.ALLIANCE_POINTS, difference)
    end
end
