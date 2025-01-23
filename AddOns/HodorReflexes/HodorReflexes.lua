--[[
================================================================================
HodorReflexes Addon for Elder Scrolls Online (ESO)
================================================================================
Author: @andy.s, @m00nyONE, @seadotarley
Website: https://www.esoui.com/downloads/info2311-HodorReflexes-DPSampUltimateShare.html
Version: "dev"

Description:
This addon enhances group coordination and performance tracking in ESO by
providing features such as DPS sharing, ultimate sharing, mock messages,
combat state notifications, and more. It utilizes the ESO API to manage
group-related data, customize UI elements, and enable communication
between players.

This file contains the core functionality and initialization logic for the addon.

Dependencies:
- LibAddonMenu-2.0 > 32
- LibDataShare
- LibCombat
- LibStub (optional, checks for outdated versions)
================================================================================
--]]


-- Core Addon Table
HodorReflexes = {
	name = "HodorReflexes",
	version = "2025.01.23",

	-- Default settings for saved variables
	default = {
		confirmExitInstance = true,                -- Show confirmation dialog before exiting instances
		toxicMode = true,                          -- Enable "toxic" mock messages in specific zones
		disableIncompatibleDependencyWarning = false -- Disable outdated library warning
	},

	-- Saved variables configuration
	sv = nil,                  -- Saved variables instance
	svVersion = 1,             -- Version of the saved variables structure
	svName = "HodorReflexesSV", -- Saved variables table name

	modules = {},              -- Contains public modules like "share", "vote", etc.
}

-- This array is used by the "share" module to display short names rather than full user ids.
-- Format: [@userId] = {"name", "pretty_name", "custom_icon.dds"}
HodorReflexes.users = {}

-- Addon events (to be used with RegisterCallback)
-- Use HodorReflexes.RegisterCallback(event, callback) to register a callback.
HR_EVENT_PLAYER_ACTIVATED = "PlayerActivated"
HR_EVENT_COMBAT_START = "CombatStart"
HR_EVENT_COMBAT_END = "CombatEnd"
HR_EVENT_RETICLE_TARGET_CHANGED = "ReticleTargetChanged"
HR_EVENT_UNIT_DIED = "UnitDied"
HR_EVENT_INTERRUPT = "Interrupt"
HR_EVENT_STUNNED = "Stunned"
HR_EVENT_GROUP_CHANGED = "GroupChanged"

-- Import global variables and libraries
local HR = HodorReflexes
local EM = EVENT_MANAGER
local LAM = LibAddonMenu2

local optionControls = {} -- additional addon settings provided by modules

-- Style definitions for keyboard and gamepad UI elements
local KEYBOARD_STYLES = {
	titleTemplate = "HodorReflexes_Updated_Title_Keyboard_Template",
	dismissTemplate = "HodorReflexes_Updated_Dismiss_Keyboard_Template",
}
local GAMEPAD_STYLES = {
	titleTemplate = "HodorReflexes_Updated_Title_Gamepad_Template",
	dismissTemplate = "HodorReflexes_Updated_Dismiss_Gamepad_Template",
}

-- Incompatible dependency warning flag
local incompatibleDependencyWarningTriggered = false

-- Toxic mock messages configuration
local text = {}  -- Stores the currently displayed mock message
local mockText = {} -- Array of possible mock messages
local mockZones = {
	[636] = true,  -- HRC
	[638] = true,  -- AA
	[639] = true,  -- SO
	[725] = true,  -- MoL
	[975] = true,  -- HoF
	[1000] = true, -- AS
	[1051] = true, -- CR
	[1121] = true, -- SS
	[1196] = true, -- KA
	[1263] = true, -- RG
	[1344] = true, -- DSR
	[1427] = true, -- SE
	[1478] = true, -- LC
}


-- Function to handle changes in the Death Recap screen
-- Displays mock messages when "toxicMode" is enabled.
local function DeathRecapChanged(status)
	if HR.sv.toxicMode and status and ZO_DeathRecapScrollContainerScrollChildHintsContainerHints1Text then
		text = mockText[math.random(#mockText)]
		ZO_DeathRecapScrollContainerScrollChildHintsContainerHints1Text:SetText(GetString(text))
	end
end

-- Function to generate mock messages based on zone, language, and dungeon difficulty.
local function GenerateMock()
	-- Unregister the Death Recap callback to reset mock messages
	DEATH_RECAP:UnregisterCallback("OnDeathRecapAvailableChanged", DeathRecapChanged)

	-- Reset the mockText table
	mockText = {}

	-- Retrieve the player's current zone ID and language setting
	local zoneId = GetZoneId(GetUnitZoneIndex('player'))
	local lang = GetCVar("language.2")

	-- Check if the language and zone are supported for mock messages
	if (lang == "en" or lang == "ru" or lang == "fr" or lang == "it") and mockZones[zoneId] then
		-- Populate the mockText table with predefined mock messages
		mockText = {
			HR_MOCK1, HR_MOCK2, HR_MOCK3, HR_MOCK4, HR_MOCK5, HR_MOCK6,
			HR_MOCK7, HR_MOCK8, HR_MOCK9, HR_MOCK10, HR_MOCK11, HR_MOCK12,
			HR_MOCK13, HR_MOCK14, HR_MOCK15, HR_MOCK16, HR_MOCK17, HR_MOCK18,
			HR_MOCK19, HR_MOCK20
		}

		-- Add zone-specific mock messages for zones with ID < 700
		if zoneId < 700 then
			text = table.insert(mockText, HR_MOCK_AA1)
		end

		-- Add region-specific mock messages for the EU Megaserver
		if GetWorldName() == "EU Megaserver" then
			table.insert(mockText, HR_MOCK_EU1)
		end

		-- Add mock messages based on dungeon difficulty
		if GetCurrentZoneDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL then
			table.insert(mockText, HR_MOCK_NORMAL1)
		else
			table.insert(mockText, HR_MOCK_VET1)
		end

		-- Re-register the Death Recap callback to display new mock messages
		DEATH_RECAP:RegisterCallback("OnDeathRecapAvailableChanged", DeathRecapChanged)
	end
end

local function UpdatePlatformStyles(styleTable)

    ApplyTemplateToControl(HodorReflexes_Updated_Title, styleTable.titleTemplate)
    ApplyTemplateToControl(HodorReflexes_Updated_Dismiss, styleTable.dismissTemplate)
    --ApplyTemplateToControl(HodorReflexes_Updated_Dismiss_With_Integrity, styleTable.dismissWithIntegrityTemplate)

end

-- Function to check for outdated versions of LibAddonMenu
-- Displays a warning if an incompatible version is detected.
-- Some people complain about this message... there is now an option to disable it.
-- Do what you want, but then don't tell me that you have a problem. You have been warned
local function CheckForOutdatedLibAddonMenu()
	if LibStub == nil then return end

	local _, minor = LibStub:GetLibrary("LibAddonMenu-2.0", true)
	if minor == nil then return end

	if minor <= 32 then
		incompatibleDependencyWarningTriggered = true
		if HR.sv.disableIncompatibleDependencyWarning == true then return end

		zo_callLater(function()
			d("**************************************************")
			d("**                IMPORTANT NOTICE              **")
			d("**************************************************")
			d("Hodor Reflexes has detected an outdated version of LibAddonMenu-2.0 installed!")
			d("")
			d("This issue occurs because another addon includes an old version of LibAddonMenu-2.0,")
			d("which overwrites the version required for Hodor Reflexes to function properly.")
			d("")
			d("To fix this issue, you must identify the addon causing the problem and remove the")
			d("embedded LibAddonMenu-2.0 folder from that addon. Unfortunately, Hodor Reflexes")
			d("cannot identify the exact addon for you.")
			d("")
			d("What you can do:")
			d("1. Look for addons that have a 'Lib' folder containing LibAddonMenu-2.0.")
			d("2. Delete the LibAddonMenu-2.0 folder from those addons.")
			d("3. Ensure that your game uses the latest version of LibAddonMenu-2.0.")
			d("")
			d("Note: This is not an issue with Hodor Reflexes itself but a conflict caused by")
			d("another addon with outdated dependencies.")
			d("")
			d("Until you resolve this, Hodor Reflexes may not function as intended.")
			d("**************************************************")
		end, 5000)
	end
end

-- Main initialization function for the addon
local function Initialize()
	-- Create callback manager
	HR.cm = HR.cm or ZO_CallbackObject:New()

	-- Retrieve saved variables
	HR.sv = ZO_SavedVars:NewAccountWide(HR.svName, HR.svVersion, nil, HR.default)

	-- check for incompatibilities
	CheckForOutdatedLibAddonMenu()


	-- Bindings
	ZO_CreateStringId('SI_BINDING_NAME_HR_EXIT_INSTANCE', GetString(HR_BINDING_EXIT_INSTANCE))

	-- Register events
	EM:RegisterForEvent(HR.name .. "PlayerActivated", EVENT_PLAYER_ACTIVATED, HR.PlayerActivated)

	-- public modules
	if HR.modules.share then HR.modules.share.Initialize() end
	if HR.modules.vote then HR.modules.vote.Initialize() end
	if HR.modules.events then HR.modules.events.Initialize() end

	-- Bindings
	ZO_CreateStringId('SI_BINDING_NAME_HR_EXIT_INSTANCE', GetString(HR_BINDING_EXIT_INSTANCE))
	ZO_CreateStringId('HR_UPDATED_TITLE', 'Hodor Reflexes ' .. HR.version)

	-- Apply platform styles
	ZO_PlatformStyle:New(UpdatePlatformStyles, KEYBOARD_STYLES, GAMEPAD_STYLES)

	HR.BuildMenu()

end

-- EVENT_PLAYER_ACTIVATED handler
-- Automatically fires PlayerCombatState and GroupChanged callbacks.
function HR.PlayerActivated()

	HR.player.Initialize()
	HR.units.Initialize()

	HR.cm:FireCallbacks(HR_EVENT_PLAYER_ACTIVATED)

	-- Player can be in combat after reloadui
	EM:RegisterForEvent(HR.name .. "Combat", EVENT_PLAYER_COMBAT_STATE, HR.PlayerCombatState)
	HR.PlayerCombatState(nil, IsUnitInCombat("player"))

	-- Group event handling (with delay to avoid spam)
	local function OnGroupChangeDelayed()
		EM:UnregisterForUpdate(HR.name .. "GroupChangeDelayed")
		EM:RegisterForUpdate(HR.name .. "GroupChangeDelayed", 1000, HR.GroupChanged)
	end
	EM:RegisterForEvent(HR.name, EVENT_GROUP_MEMBER_JOINED, OnGroupChangeDelayed)
	EM:RegisterForEvent(HR.name, EVENT_GROUP_MEMBER_LEFT, OnGroupChangeDelayed)
	EM:RegisterForEvent(HR.name, EVENT_GROUP_UPDATE, OnGroupChangeDelayed)
	EM:RegisterForEvent(HR.name, EVENT_GROUP_MEMBER_CONNECTED_STATUS, OnGroupChangeDelayed)
	OnGroupChangeDelayed()

	GenerateMock()

end

-- EVENT_PLAYER_COMBAT_STATE handler
local inCombat = false -- previous combat state
function HR.PlayerCombatState(_, c)
	if inCombat ~= c then
		if c then
			inCombat = true
			HR.cm:FireCallbacks(HR_EVENT_COMBAT_START)
		else
			-- When the 2nd parameter is false, then it's not confirmed that the combat has ended.
			HR.cm:FireCallbacks(HR_EVENT_COMBAT_END, false)
			-- A confirmed event is fired after 3 seconds.
			zo_callLater(function()
				if not IsUnitInCombat("player") then
					inCombat = false
					HR.cm:FireCallbacks(HR_EVENT_COMBAT_END, true)
				end
			end, 3000)
		end
	end
end

-- EVENT_RETICLE_TARGET_CHANGED handler
function HR.ReticleTargetChanged()
	HR.cm:FireCallbacks(HR_EVENT_RETICLE_TARGET_CHANGED)
end

-- EVENT_COMBAT_EVENT: ACTION_RESULT_DIED / ACTION_RESULT_DIED_XP
--function HR.UnitDied(eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId)
function HR.UnitDied(_, result, _, _, _, _, _, _, targetName, targetType, _, _, _, _, _, targetUnitId, _)
	HR.cm:FireCallbacks(HR_EVENT_UNIT_DIED, result, targetName, targetType, targetUnitId)
end

-- EVENT_COMBAT_EVENT: ACTION_RESULT_INTERRUPT
--function HR.Interrupt(eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId)
function HR.Interrupt(_, result, _, _, _, _, _, _, targetName, targetType, _, _, _, _, _, targetUnitId, _)
	HR.cm:FireCallbacks(HR_EVENT_INTERRUPT, result, targetName, targetType, targetUnitId)
end

-- EVENT_COMBAT_EVENT: ACTION_RESULT_STUNNED
--function HR.Stunned(eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId)
function HR.Stunned(_, result, _, _, _, _, _, _, targetName, targetType, _, _, _, _, _, targetUnitId, _)
	HR.cm:FireCallbacks(HR_EVENT_STUNNED, result, targetName, targetType, targetUnitId)
end

-- EVENT_GROUP_MEMBER_JOINED, EVENT_GROUP_MEMBER_LEFT, EVENT_GROUP_UPDATE handler
function HR.GroupChanged()
	EM:UnregisterForUpdate(HR.name .. "GroupChangeDelayed")
	HR.cm:FireCallbacks(HR_EVENT_GROUP_CHANGED)
end

function HR.RegisterCallback(eventName, callback)

	-- Only start listening to some events when there is at least one callback attached
	if eventName == HR_EVENT_RETICLE_TARGET_CHANGED then
		EM:UnregisterForEvent(HR.name, EVENT_RETICLE_TARGET_CHANGED)
		EM:RegisterForEvent(HR.name, EVENT_RETICLE_TARGET_CHANGED, HR.ReticleTargetChanged)
	elseif eventName == HR_EVENT_UNIT_DIED then
		EM:UnregisterForEvent(HR.name .. "UnitDied", EVENT_COMBAT_EVENT)
		EM:UnregisterForEvent(HR.name .. "UnitDiedXP", EVENT_COMBAT_EVENT)

		EM:RegisterForEvent(HR.name .. "UnitDied", EVENT_COMBAT_EVENT, HR.UnitDied)
		EM:AddFilterForEvent(HR.name .. "UnitDied", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_DIED)
		EM:RegisterForEvent(HR.name .. "UnitDiedXP", EVENT_COMBAT_EVENT, HR.UnitDied)
		EM:AddFilterForEvent(HR.name .. "UnitDiedXP", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_DIED_XP)
	elseif eventName == HR_EVENT_INTERRUPT then
		EM:UnregisterForEvent(HR.name .. "Interrupt", EVENT_COMBAT_EVENT)

		EM:RegisterForEvent(HR.name .. "Interrupt", EVENT_COMBAT_EVENT, HR.Interrupt)
		EM:AddFilterForEvent(HR.name .. "Interrupt", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_INTERRUPT)
	elseif eventName == HR_EVENT_STUNNED then
		EM:UnregisterForEvent(HR.name .. "Stunned", EVENT_COMBAT_EVENT)

		EM:RegisterForEvent(HR.name .. "Stunned", EVENT_COMBAT_EVENT, HR.Stunned)
		EM:AddFilterForEvent(HR.name .. "Stunned", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_STUNNED)
	end

    HR.cm:RegisterCallback(eventName, callback)
end

function HR:UnregisterCallback(eventName, callback)
    HR.cm:UnregisterCallback(eventName, callback)
end

function HR.RegisterOptionControls(options)
	for _, v in ipairs(options) do
		table.insert(optionControls, v)
	end
end

function HR.GetModulePanelConfig(listName, panelName)
	panelName = panelName or listName
	return {
		type = 'panel',
		name = listName and string.format('Hodor Reflexes - %s', listName) or 'Hodor Reflexes',
		displayName = panelName and string.format('Hodor Reflexes - |cFFFACD%s|r', panelName) or 'Hodor Reflexes',
		author = '|cFFFF00@andy.s|r, |c76c3f4@m00nyONE|r, |cef7682@seadotarley|r',
		version = string.format('|c00FF00%s|r', HR.version),
		website = 'https://www.esoui.com/downloads/info2311-HodorReflexes-DPSampUltimateShare.html#donate',
		donation = HR.Donation,
		registerForRefresh = true,
	}
end

function HR.Donation()
	SCENE_MANAGER:Show('mailSend')
	zo_callLater(function() 
		ZO_MailSendToField:SetText("@m00nyONE")
		ZO_MailSendSubjectField:SetText("Donation for Hodor Reflexes")
		ZO_MailSendBodyField:SetText("ticket-XXXX on Discord.")
		ZO_MailSendBodyField:TakeFocus()
	end, 250)
end

function HR.GetOptionControls()
	return optionControls
end

function HR.LockUI()

	-- public modules
	if HR.modules.share then HR.modules.share.LockUI() end
	if HR.modules.vote then HR.modules.vote.LockUI() end

	if HodorReflexesMenu_LockUI then LAM.util.RequestRefreshIfNeeded(HodorReflexesMenu_LockUI) end

end

-- Jump out of the current instance immediately. Show confirmation dialog if needed.
function HR.ExitInstance()
	if CanExitInstanceImmediately() then
		if HR.sv.confirmExitInstance then
			-- This one checks if there is ANY dialog showing. Rework it to check exit instance dialog.
			if not ZO_Dialogs_IsShowingDialog() then
				LAM.util.ShowConfirmationDialog(GetString(HR_EXIT_INSTANCE), GetString(HR_EXIT_INSTANCE_CONFIRM), function()
					ExitInstanceImmediately()
				end)
			end
		else
			ExitInstanceImmediately()		
		end
	end
end

SLASH_COMMANDS["/hodor"] = function(str)
	if str == "lock" then HR.LockUI() return end
	if str == "isIncompatibleDependencyWarningDisabled" then d(HR.sv.disableIncompatibleDependencyWarning) return end
	if str == "isIncompatibleDependencyWarningTriggered" then d(incompatibleDependencyWarningTriggered)	return end
	if str == "version" then d(HR.version) return end
	if str == "integrity" then HR.integrity.Check()	return end
end

EM:RegisterForEvent(HR.name, EVENT_ADD_ON_LOADED, function(_, name)
	if name == HR.name then
		Initialize()
		EM:UnregisterForEvent(HR.name, EVENT_ADD_ON_LOADED)
	end
end)