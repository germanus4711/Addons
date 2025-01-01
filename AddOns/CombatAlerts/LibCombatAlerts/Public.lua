local LCCC = LibCodesCommonCode
local Internal = LibCombatAlertsInternal
local Public = LibCombatAlerts


--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

-- Format styles for Public.FormatTime
Public.TIME_FORMAT_LONG      = 1 -- 0:16
Public.TIME_FORMAT_SHORT     = 2 -- 16s (default)
Public.TIME_FORMAT_COUNTDOWN = 3 -- 1.6s
Public.TIME_FORMAT_COMPACT   = 4 -- 2h or 2m or 16s

-- Degree of certainty of interrupt; e.g., there are cases where a stun will not interrupt
Public.INTERRUPT_EVENTS = {
	[ACTION_RESULT_CHARMED] = 1,
	[ACTION_RESULT_FEARED] = 1,
	[ACTION_RESULT_STUNNED] = 2,
	[ACTION_RESULT_DIED] = 3,
	[ACTION_RESULT_DIED_XP] = 3,
	[ACTION_RESULT_INTERRUPT] = 4,
}

Public.DAMAGE_EVENTS = {
	[ACTION_RESULT_DAMAGE] = true,
	[ACTION_RESULT_CRITICAL_DAMAGE] = true,
	[ACTION_RESULT_BLOCKED_DAMAGE] = true,
	[ACTION_RESULT_DOT_TICK] = true,
	[ACTION_RESULT_DOT_TICK_CRITICAL] = true,
}

Public.IDS = {
	TAUNT = 38254,
	MAJ_VULN = 106754,
}


--------------------------------------------------------------------------------
-- Imports from LibCodesCommonCode
--------------------------------------------------------------------------------

Public.UnpackRGBA = LCCC.Int32ToRGBA
Public.UnpackRGB = LCCC.Int24ToRGB
Public.PackRGBA = LCCC.RGBAToInt32
Public.PackRGB = LCCC.RGBToInt24
Public.AddAlpha = LCCC.Int24ToInt32
Public.RemoveAlpha = LCCC.Int32ToInt24
Public.HSLToRGB = LCCC.HSLToRGB
Public.RunAfterInitialLoadscreen = LCCC.RunAfterInitialLoadscreen
Public.MonitorZoneChanges = LCCC.MonitorZoneChanges
Public.GetZoneId = LCCC.GetZoneId
Public.GetZoneName = LCCC.GetZoneName
Public.GetSortedKeys = LCCC.GetSortedKeys
Public.CountTable = LCCC.CountTable
Public.Clamp = LCCC.Clamp
Public.MatchStrings = LCCC.MatchStrings
Public.RegisterString = LCCC.RegisterString
Public.GetLocalizedData = LCCC.GetLocalizedData
Public.GetSortedGroupMembers = LCCC.GetSortedGroupMembers
Public.GetAddOnVersion = LCCC.GetAddOnVersion
Public.FormatVersion = LCCC.FormatVersion


--------------------------------------------------------------------------------
-- Miscellaneous functions
--------------------------------------------------------------------------------

do
	local cache = { }
	function Public.GetAbilityName( abilityId )
		local name = cache[abilityId]
		if (not name) then
			name = GetAbilityName(abilityId)
			name = (name ~= "") and zo_strformat(SI_ABILITY_TOOLTIP_NAME, name) or string.format("[#%d]", abilityId)
			cache[abilityId] = name
		end
		return name
	end
end

function Public.PlaySounds( soundId, amplification, delayForNext, ... )
	local sound = soundId and SOUNDS[soundId]
	if (sound) then
		for i = 1, amplification or 1 do
			PlaySound(sound)
		end
	end
	if (type(delayForNext) == "number") then
		local args = { ... }
		if (#args > 0) then
			zo_callLater(function() Public.PlaySounds(unpack(args)) end, delayForNext)
		end
	end
end

function Public.GetTexture( id )
	local path = type(id) == "string" and Internal.Textures[id]
	return string.format("%sart/%s", Internal.GetRootPath(), path or "blank.dds")
end

function Public.CheckUnitForEffect( unitTag, effectAbilityId )
	local count = GetNumBuffs(unitTag)
	for i = 1, count do
		local _, timeStarted, timeEnding, _, stackCount, _, _, _, _, _, abilityId = GetUnitBuffInfo(unitTag, i)
		if (abilityId == effectAbilityId) then
			return timeStarted, timeEnding, stackCount
		end
	end
	return nil
end

function Public.FormatTime( ms, format )
	if (ms < 0) then ms = 0 end

	if (format ~= Public.TIME_FORMAT_COUNTDOWN) then
		ms = ms + 500 -- So that floor() rounds to nearest
	end

	if (format == Public.TIME_FORMAT_COUNTDOWN and ms < 3000) then
		return(string.format("%.1fs", ms / 1000))
	elseif (format ~= Public.TIME_FORMAT_LONG) then
		if (ms > 5400000 and format == Public.TIME_FORMAT_COMPACT) then
			return(string.format("%dh", zo_round(ms / 3600000)))
		elseif (ms > 90000 and format == Public.TIME_FORMAT_COMPACT) then
			return(string.format("%dm", zo_round(ms / 60000)))
		else
			return(string.format("%ds", zo_floor(ms / 1000)))
		end
	else
		return(string.format(
			"%d:%02d",
			zo_floor(ms / 60000),
			zo_floor(ms / 1000) % 60
		))
	end
end

function Public.GetUnitHealthPercent( unitTag, invalidReturnsNil )
	local current, _, effectiveMax = GetUnitPower(unitTag, COMBAT_MECHANIC_FLAGS_HEALTH)
	if (effectiveMax > 0) then
		return 100 * current / effectiveMax
	elseif (invalidReturnsNil) then
		return nil
	else
		return 0
	end
end

function Public.ToggleUIFragment( fragment, enable )
	if (enable) then
		SCENE_MANAGER:GetScene("hud"):AddFragment(fragment)
		SCENE_MANAGER:GetScene("hudui"):AddFragment(fragment)
		SCENE_MANAGER:GetScene("siegeBar"):AddFragment(fragment)
		SCENE_MANAGER:GetScene("siegeBarUI"):AddFragment(fragment)
	else
		SCENE_MANAGER:GetScene("hud"):RemoveFragment(fragment)
		SCENE_MANAGER:GetScene("hudui"):RemoveFragment(fragment)
		SCENE_MANAGER:GetScene("siegeBar"):RemoveFragment(fragment)
		SCENE_MANAGER:GetScene("siegeBarUI"):RemoveFragment(fragment)
	end
end


--------------------------------------------------------------------------------
-- Get the distance between two units or a unit and a supplied point
--------------------------------------------------------------------------------

function Public.GetDistance( unitTag1, unitTag2, useHeight, validate )
	local zone1, x1, y1, z1 = GetUnitWorldPosition(unitTag1)
	local zone2, x2, y2, z2

	if (type(unitTag2) == "table") then
		x2, y2, z2 = unpack(unitTag2)
	else
		zone2, x2, y2, z2 = GetUnitWorldPosition(unitTag2)
	end

	if (validate and (zone1 == 0 or zone1 ~= zone2)) then
		return(-1)
	elseif (useHeight) then
		return(zo_sqrt((x1 - x2)^2 + (y1 - y2)^2 + (z1 - z2)^2) / 100)
	else
		return(zo_sqrt((x1 - x2)^2 + (z1 - z2)^2) / 100)
	end
end


--------------------------------------------------------------------------------
-- Fill in missing options with defaults
--------------------------------------------------------------------------------

function Public.PopulateOptions( options, defaults )
	options = options or { }
	for k, v in pairs(defaults) do
		if (options[k] == nil) then
			if (type(v) == "table") then
				options[k] = ZO_ShallowTableCopy(v)
			else
				options[k] = v
			end
		end
	end
	return options
end


--------------------------------------------------------------------------------
-- Check for slotted abilities
--------------------------------------------------------------------------------

do
	local HOTBARS = {
		[HOTBAR_CATEGORY_PRIMARY] = EQUIP_SLOT_MAIN_HAND,
		[HOTBAR_CATEGORY_BACKUP] = EQUIP_SLOT_BACKUP_MAIN,
	}

	-- Taunt
	local TAUNT_ABILITIES = {
		[ 28306] = 0, -- Puncture
		[ 38250] = 0, -- Pierce Armor
		[ 38256] = 0, -- Ransack
		[ 38984] = 1, -- Destructive Clench
		[ 38985] = 1, -- Flame Clench
		[ 38989] = 1, -- Frost Clench
		[ 38993] = 1, -- Shock Clench
		[ 39114] = 0, -- Deafening Roar
		[ 39475] = 0, -- Inner Fire
		[ 42056] = 0, -- Inner Rage
		[ 42060] = 0, -- Inner Beast
		[183165] = 0, -- Runic Jolt
		[183430] = 0, -- Runic Sunder
		[186531] = 0, -- Runic Embrace
	}
	local TAUNT_SCRIPT_ID = 12

	-- Pull
	local PULL_ABILITIES = {
		[20492] = true, -- Fiery Grip
		[20496] = true, -- Unrelenting Grip
		[40336] = true, -- Silver Leash
	}
	local PULL_GRIMOIRES = {
		[2] = true, -- Wield Soul
		[3] = true, -- Shield Throw
	}
	local PULL_SCRIPT_ID = 14

	-- Purge
	local AOE_PURGE_ABILITIES = {
		[38571] = true, -- Purge
		[40232] = true, -- Efficient Purge
		[40234] = true, -- Cleanse
	}
	local AOE_PURGE_GRIMOIRES = {
		[ 8] = true, -- Soul Burst
		[10] = true, -- Torchbearer
	}
	local PURGE_SCRIPT_ID = 36

	function Public.DoesPlayerHaveTauntSlotted( )
		for hotbarCategory, equipSlot in pairs(HOTBARS) do
			for i = 3, 7 do
				local actionType = GetSlotType(i, hotbarCategory)
				if (actionType == ACTION_TYPE_ABILITY) then
					local weaponCheck = TAUNT_ABILITIES[GetSlotBoundId(i, hotbarCategory)]
					if (weaponCheck == 0 or (weaponCheck == 1 and GetItemWeaponType(BAG_WORN, equipSlot) == WEAPONTYPE_FROST_STAFF)) then
						return true
					end
				elseif (actionType == ACTION_TYPE_CRAFTED_ABILITY) then
					if (GetCraftedAbilityActiveScriptIds(GetSlotBoundId(i, hotbarCategory)) == TAUNT_SCRIPT_ID) then
						return true
					end
				end
			end
		end
		return false
	end

	function Public.DoesPlayerHaveSingleTargetPullSlotted( )
		for hotbarCategory, equipSlot in pairs(HOTBARS) do
			for i = 3, 7 do
				local actionType = GetSlotType(i, hotbarCategory)
				if (actionType == ACTION_TYPE_ABILITY) then
					if (PULL_ABILITIES[GetSlotBoundId(i, hotbarCategory)]) then
						return true
					end
				elseif (actionType == ACTION_TYPE_CRAFTED_ABILITY) then
					local craftedAbilityId = GetSlotBoundId(i, hotbarCategory)
					if (PULL_GRIMOIRES[craftedAbilityId] and GetCraftedAbilityActiveScriptIds(craftedAbilityId) == PULL_SCRIPT_ID) then
						return true
					end
				end
			end
		end
		return false
	end

	function Public.DoesPlayerHaveTauntOrPullSlotted( )
		return Public.DoesPlayerHaveTauntSlotted() or Public.DoesPlayerHaveSingleTargetPullSlotted()
	end

	function Public.DoesPlayerHaveAoePurgeSlotted( )
		for hotbarCategory, equipSlot in pairs(HOTBARS) do
			for i = 3, 7 do
				local actionType = GetSlotType(i, hotbarCategory)
				if (actionType == ACTION_TYPE_ABILITY) then
					if (AOE_PURGE_ABILITIES[GetSlotBoundId(i, hotbarCategory)]) then
						return true
					end
				elseif (actionType == ACTION_TYPE_CRAFTED_ABILITY) then
					local craftedAbilityId = GetSlotBoundId(i, hotbarCategory)
					if (AOE_PURGE_GRIMOIRES[craftedAbilityId] and select(2, GetCraftedAbilityActiveScriptIds(craftedAbilityId)) == PURGE_SCRIPT_ID) then
						return true
					end
				end
			end
		end
		return false
	end
end


--------------------------------------------------------------------------------
-- Cached status: isDamage, isHealer, isTank, isVet
--------------------------------------------------------------------------------

do
	local function updateRole( )
		local role = GetSelectedLFGRole()
		Public.isDamage = role == LFG_ROLE_DPS
		Public.isHealer = role == LFG_ROLE_HEAL
		Public.isTank = role == LFG_ROLE_TANK
	end

	Public.RunAfterInitialLoadscreen(function( )
		local name = "LCA_RoleMonitor"
		EVENT_MANAGER:RegisterForEvent(name, EVENT_GROUP_MEMBER_ROLE_CHANGED, updateRole)
		EVENT_MANAGER:RegisterForEvent(name, EVENT_PLAYER_COMBAT_STATE, updateRole)
		updateRole()
	end)

	Public.MonitorZoneChanges("LCA_DifficultyMonitor", function( )
		Public.isVet = GetCurrentZoneDungeonDifficulty() == DUNGEON_DIFFICULTY_VETERAN
	end)
end


--------------------------------------------------------------------------------
-- Unit ID identification functions
--------------------------------------------------------------------------------

do
	local registrants = { }
	local registered = false
	local groupTags = { }
	local groupIds = { }
	local bossIds = { }

	local unitPrefixes = {
		group = { "LCA_UnitId_G", 1 },
		boss = { "LCA_UnitId_B", 2 },
	}

	local function identify( type, unitTag, unitName, unitId )
		if (type == 1) then
			if (groupTags[unitTag] ~= unitId) then
				if (groupTags[unitTag]) then
					groupIds[groupTags[unitTag]] = nil
				end
				groupTags[unitTag] = unitId
			end
			if (not groupIds[unitId]) then
				local name = GetUnitDisplayName(unitTag)
				groupIds[unitId] = {
					tag = unitTag,
					name = name ~= "" and name or unitName,
				}
			end
		elseif (type == 2 and not bossIds[unitId]) then
			bossIds[unitId] = {
				tag = unitTag,
				name = unitName,
			}
		end
	end

	local function toggle( unitPrefix, enable )
		local data = unitPrefixes[unitPrefix]
		if (enable) then
			EVENT_MANAGER:RegisterForEvent(data[1], EVENT_EFFECT_CHANGED, function( _, _, _, _, unitTag, _, _, _, _, _, _, _, _, unitName, unitId )
				identify(data[2], unitTag, unitName, unitId)
			end)
			EVENT_MANAGER:AddFilterForEvent(data[1], EVENT_EFFECT_CHANGED, REGISTER_FILTER_UNIT_TAG_PREFIX, unitPrefix)
		else
			EVENT_MANAGER:UnregisterForEvent(data[1], EVENT_EFFECT_CHANGED)
		end
	end

	function Public.ToggleUnitIdTracking( name, enable )
		if (enable) then
			registrants[name] = true
		else
			registrants[name] = nil
		end

		if (not registered and next(registrants)) then
			registered = true
			Public.ResetUnitIdTracking()
			toggle("group", true)
			toggle("boss", true)
		elseif (registered and not next(registrants)) then
			registered = false
			toggle("group", false)
			toggle("boss", false)
		end
	end

	function Public.ResetUnitIdTracking( )
		groupTags = { }
		groupIds = { }
		bossIds = { }
	end

	function Public.IdentifyGroupUnitTag( unitTag )
		return groupTags[unitTag]
	end

	function Public.IdentifyGroupUnitId( unitId, useFallback )
		if (groupIds[unitId]) then
			return groupIds[unitId].tag, groupIds[unitId].name
		elseif (useFallback) then
			return "", string.format("unit%d", unitId)
		else
			return nil
		end
	end

	function Public.IdentifyBossUnitId( unitId, useFallback )
		if (bossIds[unitId]) then
			return bossIds[unitId].tag, bossIds[unitId].name
		elseif (useFallback) then
			return "", string.format("unit%d", unitId)
		else
			return nil
		end
	end
end


--------------------------------------------------------------------------------
-- Interaction blocking
--------------------------------------------------------------------------------

do
	local isHooked = false
	local rules = { }

	local function shouldBlock( )
		local action, name = GetGameCameraInteractableActionInfo()
		if (action and action ~= "" and name and name ~= "") then
			for _, rule in pairs(rules) do
				if ((not rule.action or Public.MatchStrings(rule.action, action)) and Public.MatchStrings(rule.name, name)) then
					if (rule.callback()) then
						return true
					end
				end
			end
		end
		return false
	end

	local function enableHook( )
		if (isHooked) then return end
		isHooked = true

		-- Hooking RETICLE:TryHandlingInteraction produces a cosmetic result: the prompt is hidden, but player input is still accepted
		ZO_PreHook(RETICLE, "TryHandlingInteraction", function( _, interactionPossible )
			if (interactionPossible and shouldBlock()) then
				return true
			else
				return false
			end
		end)

		-- Hooking INTERACTIVE_WHEEL_MANAGER:StartInteraction produces a behavioral result: player input is discarded, but the prompt is still shown
		local obj = INTERACTIVE_WHEEL_MANAGER
		local fnName = "StartInteraction"
		local origFn = obj[fnName]
		obj[fnName] = function( ... )
			if (shouldBlock()) then
				return true
			else
				return origFn(...)
			end
		end
	end

	function Public.RegisterInteractionBlock( id, action, name, callback )
		-- id is required
		-- action is optional and may be nil
		-- name and callback are required for registration; omit them to unregister instead

		if (name and callback) then
			rules[id] = { action = action, name = name, callback = callback }
			enableHook()
		else
			rules[id] = nil
		end
	end

	function Public.UnregisterAllInteractionBlocks( )
		rules = { }
	end
end
