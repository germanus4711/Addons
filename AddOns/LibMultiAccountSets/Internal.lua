local LCCC = LibCodesCommonCode

if (LibMultiAccountSets) then return end
local Public = { }
LibMultiAccountSets = Public


--------------------------------------------------------------------------------
-- Internal Components
--------------------------------------------------------------------------------

local Internal = {
	name = "LibMultiAccountSets",

	-- Default settings
	defaults = {
		chatUpdates = true,
		noSave = { },
		exportSelection = { },
	},

	scanThrottle = 1500, -- 1.5s, for the initial scan
	scanThrottleInitialized = 200, -- 0.2s, for subsequent update scans

	server = LCCC.GetServerName(),
	account = GetDisplayName(),
	currentSlots = { },
	previousFound = 0,
	initialized = false,
}
LibMultiAccountSetsInternal = Internal


--------------------------------------------------------------------------------
-- Initialization
--------------------------------------------------------------------------------

local function OnAddOnLoaded( eventCode, addonName )
	if (addonName ~= Internal.name) then return end

	EVENT_MANAGER:UnregisterForEvent(Internal.name, EVENT_ADD_ON_LOADED)

	Internal.vars = ZO_SavedVars:NewAccountWide("LibMultiAccountSetsSavedVariables", 1, nil, Internal.defaults, nil, "$InstallationWide")

	-- Initialize data store
	if (not LibMultiAccountSetsData) then LibMultiAccountSetsData = { } end
	Internal.data = LibMultiAccountSetsData
	if (not Internal.data[Internal.server]) then Internal.data[Internal.server] = { } end
	local currentServerData = Internal.data[Internal.server]

	-- Remove accounts that should not be saved
	for account in pairs(currentServerData) do
		if (not Internal.CanSave(account)) then
			currentServerData[account] = nil
		end
	end

	-- Prepare the data store for the current account
	if (Internal.CanSave()) then
		if (not currentServerData[Internal.account]) then
			currentServerData[Internal.account] = { }
		end
		Internal.currentSlots = currentServerData[Internal.account]
	end

	LCCC.RunAfterInitialLoadscreen(function( )
		Internal.RegisterSettingsPanel()
		EVENT_MANAGER:RegisterForEvent(Internal.name, EVENT_ITEM_SET_COLLECTIONS_UPDATED, Internal.RefreshCollections)
		EVENT_MANAGER:RegisterForEvent(Internal.name, EVENT_ITEM_SET_COLLECTION_UPDATED, Internal.RefreshCollections)
		Internal.RefreshCollections()
	end)
end

EVENT_MANAGER:RegisterForEvent(Internal.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)


--------------------------------------------------------------------------------
-- Scanning
--------------------------------------------------------------------------------

function Internal.RefreshCollections( )
	EVENT_MANAGER:UnregisterForUpdate(Internal.name)
	EVENT_MANAGER:RegisterForUpdate(
		Internal.name,
		Internal.scanThrottle,
		function( )
			EVENT_MANAGER:UnregisterForUpdate(Internal.name)
			Internal.ScanSets()
		end
	)
end

function Internal.ScanSets( )
	local found = 0
	local total = 0

	local setId = GetNextItemSetCollectionId()
	while (setId) do
		local setSize = GetNumItemSetCollectionPieces(setId)

		if (setSize > 0) then
			Internal.currentSlots[setId] = 0

			for i = 1, setSize do
				local pieceId, slot = GetItemSetCollectionPieceInfo(setId, i)
				local slotId = Id64ToString(slot) + 0

				if (IsItemSetCollectionSlotUnlocked(setId, slot)) then
					Internal.currentSlots[setId] = Internal.currentSlots[setId] + slotId
					found = found + 1
				end
			end

			total = total + setSize
		end

		setId = GetNextItemSetCollectionId(setId)
	end

	Internal.currentSlots.timestamp = GetTimeStamp()

	if (not Internal.initialized) then
		Internal.initialized = true
		Internal.scanThrottle = Internal.scanThrottleInitialized
		Internal.FireCallbacks(Public.EVENT_INITIALIZED)
	else
		Internal.FireCallbacks(Public.EVENT_COLLECTION_UPDATED, false)
		if (Internal.vars.chatUpdates) then
			Internal.MsgTag(string.format(GetString(SI_LMAS_SCAN_STATUS), found, total, found - Internal.previousFound))
		end
	end

	Internal.previousFound = found
end


--------------------------------------------------------------------------------
-- Other Utilities
--------------------------------------------------------------------------------

function Internal.Msg( text )
	CHAT_ROUTER:AddSystemMessage(text)
end

function Internal.MsgTag( text )
	CHAT_ROUTER:AddSystemMessage(string.format("[%s] %s", Internal.name, text))
end

function Internal.CanSave( account )
	if (Internal.vars.noSave and Internal.vars.noSave[zo_strlower(account or Internal.account)]) then
		return false
	else
		return true
	end
end

function Internal.CheckSlot( slots, slot )
	-- Unfortunately, ZOS's BitAnd doesn't work for large numbers
	if (slots and slot > 0 and zo_floor(slots / slot) % 2 == 1) then
		return true
	else
		return false
	end
end

function Internal.GetTradeEligibility( itemLink, itemSource, accounts )
	-- Returns:
	-- false: not eligible
	-- true: eligible
	-- 0: unknown eligibility

	local results = { }

	local FillResults = function( value )
		for _, account in ipairs(accounts) do
			results[account] = value
		end
	end

	if (IsItemLinkBound(itemLink)) then
		FillResults(false)
	elseif (GetItemLinkBindType(itemLink) == BIND_TYPE_ON_PICKUP) then
		if (itemSource.bagId and itemSource.slotIndex) then
			-- Inventory and banks
			for _, account in ipairs(accounts) do
				results[account] = IsDisplayNameInItemBoPAccountTable(itemSource.bagId, itemSource.slotIndex, UndecorateDisplayName(account))
			end
		elseif (itemSource.slotIndex) then
			-- Vendor windows
			for _, account in ipairs(accounts) do
				results[account] = account == Internal.account
			end
		elseif (itemSource.who and itemSource.tradeIndex) then
			-- Trade slots
			local names = GetTradeItemBoPTradeableDisplayNamesString(itemSource.who, itemSource.tradeIndex) .. " "
			for _, account in ipairs(accounts) do
				results[account] = string.find(names, account .. "[%s,]") ~= nil
			end
		elseif (itemSource.lootId) then
			-- Loot windows
			local eligible = { [Internal.account] = true }
			if (GetCurrentZoneDungeonDifficulty() ~= DUNGEON_DIFFICULTY_NONE and select(2, GetLootTargetInfo()) ~= INTERACT_TARGET_TYPE_ITEM) then
				-- Inside a group instance looting something that's not an inventory container
				for i = 1, GetGroupSize() do
					local unitTag = GetGroupUnitTagByIndex(i)
					local account = GetUnitDisplayName(unitTag)
					if (account) then
						eligible[account] = IsUnitOnline(unitTag) and IsGroupMemberInSameInstanceAsPlayer(unitTag)
					end
				end
			end

			for _, account in ipairs(accounts) do
				results[account] = eligible[account] == true
			end
		else
			-- All other scenarios
			FillResults(0)
		end
	else
		FillResults(true)
	end

	return results
end
