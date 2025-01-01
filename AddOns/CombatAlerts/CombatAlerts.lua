local LCA = LibCombatAlerts

CombatAlerts2 = {
	ID = "CombatAlerts2",
	NAME = "CombatAlerts",
	EXPECTED_VERSION = 200150,
	URL = "https://www.esoui.com/downloads/info1855.html",

	currentModules = { },
	registeredModules = { },
	registeredZones = { },
	devModule = nil,

	loaded = false,
	isLegacyActive = false,
}
local CA1 = CombatAlerts
local CA2 = CombatAlerts2


--------------------------------------------------------------------------------
-- Bootstrap, modules, and legacy mode
--------------------------------------------------------------------------------

EVENT_MANAGER:RegisterForEvent(CA2.ID, EVENT_ADD_ON_LOADED, function( eventCode, addonName )
	if (addonName ~= CA2.NAME) then return end

	EVENT_MANAGER:UnregisterForEvent(CA2.ID, EVENT_ADD_ON_LOADED)

	-- Make sure Minion didn't mess up the manifest
	if (LCA.GetAddOnVersion(CA2.NAME) ~= CA2.EXPECTED_VERSION) then
		LCA.RunAfterInitialLoadscreen(function()
			if (SI_CA_CORRUPTED) then
				CA2.ChatMessage(GetString(SI_CA_CORRUPTED), true)
			else
				-- Fallback message if the localization file is unavailable
				CHAT_ROUTER:AddSystemMessage("ERROR: Corrupted installation of Combat Alerts detected; please reinstall.")
			end
		end)
		return
	end

	-- Legacy stuff
	CA2.HandleLegacyAddOns()
	CA1.OnAddOnLoaded()

	-- Initialize settings
	CA2.LoadSettings()
	LCA.RunAfterInitialLoadscreen(CA2.RegisterSettingsPanel)

	LCA.MonitorZoneChanges(CA2.ID, CA2.OnZoneChange)

	CA2.loaded = true
end)

function CA2.OnZoneChange( zoneId )
	-- Legacy bootstrap
	CA1.Initialize()

	if (CA2.currentModules[1]) then
		for _, module in ipairs(CA2.currentModules) do
			module:Unload()
		end
		CA2.CleanupControls()
		CA2.DisablePurgeTracker()
	end

	local modules = CA2.registeredZones[zoneId]
	if (modules) then
		CA2.ToggleLegacy(false)
		CA2.currentModules = modules
		CA2.LoadModulesForCurrentZone()
	else
		CA2.currentModules = { }
		CA2.ToggleLegacy(true)
	end
end

function CA2.LoadModulesForCurrentZone( )
	for _, module in ipairs(CA2.currentModules) do
		if (not CA2.sv.disabledModules[module.ID]) then
			module:Load()
		end
	end
end

function CA2.RegisterModule( template, minVersion )
	if (type(minVersion) == "number" and minVersion > GetAPIVersion()) then return end

	local module = template:New()
	if (module.ID == "CA_M_DEV") then
		CA2.devModule = module
	elseif (not CA2.registeredModules[module.ID]) then
		CA2.registeredModules[module.ID] = module
		for _, zoneId in ipairs(module.ZONES) do
			if (CA2.registeredZones[zoneId]) then
				table.insert(CA2.registeredZones[zoneId], module)
			else
				CA2.registeredZones[zoneId] = { module }
			end
		end
	end
end

function CA2.FriendlyModuleName( update, zoneId, achievementId )
	local friendlyName = zoneId and LCA.GetZoneName(zoneId) or GetAchievementCategoryInfo(GetCategoryInfoFromAchievementId(achievementId))
	if (update) then
		return string.format("U%d: %s", update, friendlyName)
	else
		return friendlyName
	end
end

function CA2.ToggleLegacy( enable )
	if (enable and not CA2.isLegacyActive) then
		CA2.isLegacyActive = true
		EVENT_MANAGER:RegisterForEvent(CA1.name, EVENT_PLAYER_ACTIVATED, CA1.PlayerActivated)
		EVENT_MANAGER:RegisterForEvent(CA1.name, EVENT_PLAYER_COMBAT_STATE, CA1.PlayerCombatState)
		CA1.PlayerActivated()
	elseif (not enable and CA2.isLegacyActive) then
		CA2.isLegacyActive = false
		EVENT_MANAGER:UnregisterForEvent(CA1.name, EVENT_PLAYER_ACTIVATED)
		EVENT_MANAGER:UnregisterForEvent(CA1.name, EVENT_PLAYER_COMBAT_STATE)
	end
end


--------------------------------------------------------------------------------
-- Chat messages
--------------------------------------------------------------------------------

function CA2.ChatMessage( message, useTag )
	CHAT_ROUTER:AddSystemMessage(string.format("[%s] %s", useTag and GetString(SI_CA_TITLE) or os.date("%H:%M:%S", GetTimeStamp()), message))
end


--------------------------------------------------------------------------------
-- Utilities
--------------------------------------------------------------------------------

function CA2.FindClosestGroupMember( )
	local resultDistance = -1
	local resultUnitTag = ""

	for i = 1, GetGroupSize() do
		local unitTag = GetGroupUnitTagByIndex(i)
		if (not AreUnitsEqual(unitTag, "player")) then
			local distance = LCA.GetDistance("player", unitTag, false, true)
			if (distance >= 0 and (distance < resultDistance or resultDistance == -1)) then
				resultDistance = distance
				resultUnitTag = unitTag
			end
		end
	end

	return resultDistance, resultUnitTag
end


--------------------------------------------------------------------------------
-- Handle conflicts with legacy addons
--------------------------------------------------------------------------------

function CA2.HandleLegacyAddOns( )
	-- Purge Tracker
	if (type(PurgeTrackerData) == "table" and PurgeTrackerData.zones) then
		PurgeTrackerData.zones[725] = nil
		PurgeTrackerData.zones[975] = nil
	end

	-- Halls of Fabrication Status Panel
	if (type(HoFNotifier) == "table") then
		LCA.RunAfterInitialLoadscreen(function( )
			EVENT_MANAGER:UnregisterForEvent("HoFNotifier", EVENT_BOSSES_CHANGED)
			EVENT_MANAGER:UnregisterForEvent("HoFNotifier", EVENT_PLAYER_ACTIVATED)
			CA2.ChatMessage(GetString(SI_CA_LEGACY_HOF), true)
		end)
	end

	-- Block Useless Combat Messages
	EVENT_MANAGER:UnregisterForEvent("BlockUselessCombatMessages", EVENT_PLAYER_ACTIVATED)
end


--------------------------------------------------------------------------------
-- Developer functions
--------------------------------------------------------------------------------

function CA2.DevModule( enable )
	if (CA2.devModule) then
		if (enable) then
			CA2.devModule:Load()
		else
			CA2.devModule:Unload()
		end
	end
end

function CA2.DevGetDebug( )
	local module = CA2.currentModules[1]
	if (module) then
		return module, module:GetDebugData()
	end
end
