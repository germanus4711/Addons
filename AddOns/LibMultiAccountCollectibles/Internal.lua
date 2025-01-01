local LCCC = LibCodesCommonCode

if (LibMultiAccountCollectibles) then return end
local Public = { }
LibMultiAccountCollectibles = Public


--------------------------------------------------------------------------------
-- Internal Components
--------------------------------------------------------------------------------

local Internal = {
	name = "LibMultiAccountCollectibles",

	-- Data format parameters
	FORMAT_VERSION = 1,

	scanThrottle = 200, -- 0.2s

	server = LCCC.GetServerName(),
	account = GetDisplayName(),

	currentData = "",
	initialized = false,
}
LibMultiAccountCollectiblesInternal = Internal


--------------------------------------------------------------------------------
-- Initialization
--------------------------------------------------------------------------------

local function OnAddOnLoaded( eventCode, addonName )
	if (addonName ~= Internal.name) then return end

	EVENT_MANAGER:UnregisterForEvent(Internal.name, EVENT_ADD_ON_LOADED)

	-- Initialize data store
	if (not LibMultiAccountCollectiblesData or LibMultiAccountCollectiblesData.formatVersion ~= Internal.FORMAT_VERSION) then
		LibMultiAccountCollectiblesData = {
			formatVersion = Internal.FORMAT_VERSION,
		}
	end
	Internal.vars = LibMultiAccountCollectiblesData
	Internal.data = Internal.GetVarsTable("data")
	if (not Internal.data[Internal.server]) then Internal.data[Internal.server] = { } end

	-- Remove accounts that should not be saved
	for account in pairs(Internal.data[Internal.server]) do
		if (not Internal.CanSave(account)) then
			Internal.data[Internal.server][account] = nil
		end
	end

	LCCC.RunAfterInitialLoadscreen(function( )
		Internal.RegisterSettingsPanel()
		EVENT_MANAGER:RegisterForEvent(Internal.name, EVENT_COLLECTIBLES_UNLOCK_STATE_CHANGED, Internal.Refresh)
		Internal.Refresh()
	end)
end

EVENT_MANAGER:RegisterForEvent(Internal.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)


--------------------------------------------------------------------------------
-- Scanning and Encoding
--------------------------------------------------------------------------------

function Internal.Refresh( )
	EVENT_MANAGER:UnregisterForUpdate(Internal.name)
	EVENT_MANAGER:RegisterForUpdate(
		Internal.name,
		Internal.scanThrottle,
		function( )
			EVENT_MANAGER:UnregisterForUpdate(Internal.name)
			Internal.ScanCollection()
		end
	)
end

local MAX_CONSECUTIVE_INVALID_IDS = 1000 -- Max observed gap: 631
local BITS = 6
local TIMESTAMP_BYTES = 6

local function BitPosition( i )
	-- We want 1-6 instead of 0-5
	return (i - 1) % BITS + 1
end

function Internal.IsCollectibleOwned( collectibleId )
	if (IsCollectibleOwnedByDefId(collectibleId)) then
		return true
	elseif (GetCollectibleCategoryType(collectibleId) == COLLECTIBLE_CATEGORY_TYPE_COMBINATION_FRAGMENT and not CanCombinationFragmentBeUnlocked(collectibleId)) then
		return true
	else
		return false
	end
end

function Internal.ScanCollection( )
	local result = LCCC.Encode(GetTimeStamp(), TIMESTAMP_BYTES) .. ","

	-- Determine the range of valid IDs
	if (Internal.vars.api ~= GetAPIVersion() or type(Internal.vars.maxId) ~= "number") then
		local currentId = 1
		local invalidCount = 0
		local lastValidId = 0

		repeat
			if (GetCollectibleName(currentId) == "") then
				invalidCount = invalidCount + 1
			else
				invalidCount = 0
				lastValidId = currentId
			end
			currentId = currentId + 1
		until invalidCount >= MAX_CONSECUTIVE_INVALID_IDS

		Internal.vars.api = GetAPIVersion()
		Internal.vars.maxId = lastValidId
	end

	-- Pad the scan sequence as needed
	local maxId = Internal.vars.maxId
	maxId = maxId + BITS - BitPosition(maxId)

	-- Scan and encode
	local field = 0
	for currentId = 1, maxId do
		field = field * 2
		if (Internal.IsCollectibleOwned(currentId)) then
			field = field + 1
		end
		if (currentId % BITS == 0) then
			result = result .. LCCC.Encode(field, 1)
			field = 0
		end
	end

	-- Save the results
	Internal.currentData = result
	if (Internal.CanSave()) then
		Internal.data[Internal.server][Internal.account] = LCCC.Chunk(result)
	end

	-- EVENT_COLLECTION_UPDATED should not fire for the initial scan
	if (not Internal.initialized) then
		Internal.initialized = true
	else
		Internal.FireCallbacks(Public.EVENT_COLLECTION_UPDATED)
	end
end

function Internal.ReadTimeStamp( data )
	return LCCC.Decode(zo_strsub(data, 1, TIMESTAMP_BYTES))
end

function Internal.ReadId( data, id )
	-- Note that the byte position is little-endian (lower ID is in the lower-
	-- order byte), but within each byte, it is big-endian (lower ID is in the
	-- higher-order bit).
	if (type(id) == "number" and id > 0) then
		local pos = TIMESTAMP_BYTES + 1 + zo_ceil(id / BITS)
		local bit = BitLShift(1, BITS - BitPosition(id))
		return BitAnd(LCCC.Decode(zo_strsub(data, pos, pos)), bit) == bit
	else
		return false
	end
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

function Internal.GetVarsTable( name )
	if (type(Internal.vars[name]) ~= "table") then
		Internal.vars[name] = { }
	end
	return Internal.vars[name]
end

function Internal.CanSave( account )
	if (Internal.GetVarsTable("noSave")[zo_strlower(account or Internal.account)]) then
		return false
	else
		return true
	end
end
