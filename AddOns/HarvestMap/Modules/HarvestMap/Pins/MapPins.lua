
local QuickPin = LibQuickPin2
local CallbackManager = Harvest.callbackManager
local Events = Harvest.events

local MapPins = {}
Harvest:RegisterModule("mapPins", MapPins)

-- called whenever a node is hidden by the respawn timer or when it becomes visible again.
function MapPins:OnChangedNodeHiddenState(map, nodeId, newState)
	if self:IsActiveMap(map) then
		local pinTypeId = self.mapCache.pinTypeId[nodeId]
		if not pinTypeId then return end
		
		if not self.filterProfile[pinTypeId] then
			return
		end
		-- remove the node, if it was hidden.
		-- otherwise create the pin because the node is visible again.
		if newState then
			self.queue:RemoveNode(nodeId, pinTypeId)
		else
			self.queue:AddNode(nodeId, pinTypeId)
		end
		self:RefreshUpdateHandler()
	end
end

-- called whenever a resource is harvested (which adds a node or updates an already existing node)
-- or when a node is deleted by the debug tool
function MapPins:OnNodeChangedCallback(event, mapCache, nodeId)
	local nodeAdded = (event == Events.NODE_ADDED)
	local nodeUpdated = (event == Events.NODE_UPDATED or event == Events.NODE_COMPASS_LINK_CHANGED)
	local nodeDeleted = (event == Events.NODE_DELETED)
	
	-- when the heatmap is active, the map pins aren't used
	if Harvest.IsHeatmapActive() then
		return
	end
	
	local validMapMode = Harvest.AreMapPinsVisible() and not Harvest.mapMode:IsInMinimapMode()
	local validMinimapMode = Harvest.AreMinimapPinsVisible() and Harvest.mapMode:IsInMinimapMode()
	if not (validMapMode or validMinimapMode) then return end
	
	-- the node isn't on the currently displayed map
	if not (self.mapCache == mapCache) then
		return
	end
	
	if mapCache.mapMetaData.isBlacklisted then return end
	
	local pinTypeId = mapCache.pinTypeId[nodeId]
	assert(pinTypeId)
	-- if the node's pin type is visible, then we do not have to manipulate any pins
	if not self.filterProfile[pinTypeId] then
		return
	end
	
	-- queue the pin change
	-- refresh a single pin by removing and recreating it
	if not nodeAdded then
		--self:Info("remove single map pin")
		self.queue:RemoveNode(nodeId, pinTypeId)
	end
	-- the (re-)creation of the pin is performed, if the pin isn't hidden by the respawn timer
	if not nodeDeleted and not mapCache:IsHidden(nodeId) then
		--self:Info("add single map pin")
		self.queue:AddNode(nodeId, pinTypeId)
	end
	self:RefreshUpdateHandler()
end

function MapPins:RefreshUpdateHandler()
	local shouldDelay = false
	-- for some settings we want to delay pin creation
	if ZO_WorldMap:IsHidden() and not Harvest.mapMode:IsInMinimapMode() then
		self:Debug("disable pin creation: No map visible")
		shouldDelay = true
	end
	-- check if there are pins to create
	if not shouldDelay and self.queue:IsEmpty() then
		self:Debug("disable pin creation: Empty pin queue")
		shouldDelay = true
	end
	
	if shouldDelay then
		self:DisableUpdateHandler()
		return
	end
	self:Debug("enable pin creation: No map visible")
	self:EnableUpdateHandler()
end

local updateHandler
function MapPins:EnableUpdateHandler()
	EVENT_MANAGER:UnregisterForUpdate("HarvestMap-Pins")
	updateHandler = updateHandler or function() self.queue:PerformActions() end
	EVENT_MANAGER:RegisterForUpdate("HarvestMap-Pins", 50, updateHandler)
end

function MapPins:DisableUpdateHandler()
	EVENT_MANAGER:UnregisterForUpdate("HarvestMap-Pins")
end

function MapPins:RefreshVisibleDistance(newVisibleDistance)
	if not newVisibleDistance then
		newVisibleDistance = 0
		if Harvest.mapMode:IsInMinimapMode() or (Harvest.HasPinVisibleDistance() and Harvest.AreMapPinsVisible()) then
			-- check for AreMapPinsVisible, because when map pins are disabled, we have to refresh the pins
			-- when switching from mini to world map
			newVisibleDistance = Harvest.GetPinVisibleDistance()
		end
	end
	--newVisibleDistance = 0 -- debug
	--d(self.visibleDistance , "vs", newVisibleDistance)
	if newVisibleDistance ~= self.visibleDistance then
		self.visibleDistance = newVisibleDistance
		self:RedrawPins()
		if newVisibleDistance > 0 then
			EVENT_MANAGER:RegisterForUpdate("HarvestMap-VisibleRange", 2500, MapPins.UpdateVisibleMapPins)
		else
			EVENT_MANAGER:UnregisterForUpdate("HarvestMap-VisibleRange")
		end
	end
end


function MapPins:RegisterCallbacks()
	-- register callbacks for events, that affect map pins:
	-- respawn timer:
	CallbackManager:RegisterForEvent(Events.CHANGED_NODE_HIDDEN_STATE, function(event, map, nodeId, newState)
		self:OnChangedNodeHiddenState(map, nodeId, newState)
	end)
	-- creating/updating a node (after harvesting something) or deletion of a node (via debug tools)
	local callback = function(...) self:OnNodeChangedCallback(...) end
	CallbackManager:RegisterForEvent(Events.NODE_DELETED, callback)
	CallbackManager:RegisterForEvent(Events.NODE_UPDATED, callback)
	CallbackManager:RegisterForEvent(Events.NODE_ADDED, callback)
	CallbackManager:RegisterForEvent(Events.NODE_COMPASS_LINK_CHANGED, callback)
	-- when a map related setting is changed
	CallbackManager:RegisterForEvent(Events.SETTING_CHANGED, function(...) self:OnSettingsChanged(...) end)
	CallbackManager:RegisterForEvent(Events.PIN_QUEUE_EMPTY, function() self:RefreshUpdateHandler() end)
	
	CallbackManager:RegisterForEvent(Events.MAP_MODE_CHANGED, function(event, newMode)
		self:RefreshUpdateHandler()
		self:RefreshVisibleDistance()
	end)
	
	CallbackManager:RegisterForEvent(Events.FILTER_PROFILE_CHANGED, 
		function(event, profile, pinTypeId, visible)
			if profile == self.filterProfile then
				local checkbox = self.checkboxes[pinTypeId]
				if checkbox then
					ZO_CheckButton_SetCheckState(checkbox, self.filterProfile[pinTypeId])
				end
				self:RedrawPins()
			end
		end)
	
end

function MapPins:EnableScrollableFilters()
	-- The following code is from LibMapPins
	
	-------------------------------------------------------------------------------
	-- LibMapPins-1.0
	-------------------------------------------------------------------------------
	--
	-- Copyright (c) 2014, 2015 Ales Machat (Garkin)
	--
	-- Permission is hereby granted, free of charge, to any person
	-- obtaining a copy of this software and associated documentation
	-- files (the "Software"), to deal in the Software without
	-- restriction, including without limitation the rights to use,
	-- copy, modify, merge, publish, distribute, sublicense, and/or sell
	-- copies of the Software, and to permit persons to whom the
	-- Software is furnished to do so, subject to the following
	-- conditions:
	--
	-- The above copyright notice and this permission notice shall be
	-- included in all copies or substantial portions of the Software.
	--
	-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	-- OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
	-- HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
	-- WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
	-- OTHER DEALINGS IN THE SOFTWARE.
	--
	-------------------------------------------------------------------------------
	if WORLD_MAP_FILTERS.pvePanel.checkBoxPool then
        WORLD_MAP_FILTERS.pvePanel.checkBoxPool.parent = ZO_WorldMapFiltersPvEContainerScrollChild or WINDOW_MANAGER:CreateControlFromVirtual("ZO_WorldMapFiltersPvEContainer", ZO_WorldMapFiltersPvE, "ZO_ScrollContainer"):GetNamedChild("ScrollChild")
        for i, control in pairs(WORLD_MAP_FILTERS.pvePanel.checkBoxPool.m_Active) do
            control:SetParent(WORLD_MAP_FILTERS.pvePanel.checkBoxPool.parent)
        end
        if ZO_WorldMapFiltersPvECheckBox1 then
            local valid, point, control, relPoint, x, y = ZO_WorldMapFiltersPvECheckBox1:GetAnchor(0)
            if control == WORLD_MAP_FILTERS.pvePanel.control then
                ZO_WorldMapFiltersPvECheckBox1:SetAnchor(point, ZO_WorldMapFiltersPvEContainerScrollChild, relPoint, x, y)
            end
        end
    end
    if WORLD_MAP_FILTERS.pvePanel.comboBoxPool then
        WORLD_MAP_FILTERS.pvePanel.comboBoxPool.parent = ZO_WorldMapFiltersPvEContainerScrollChild or WINDOW_MANAGER:CreateControlFromVirtual("ZO_WorldMapFiltersPvEContainer", ZO_WorldMapFiltersPvE, "ZO_ScrollContainer"):GetNamedChild("ScrollChild")
        for i, control in pairs(WORLD_MAP_FILTERS.pvePanel.comboBoxPool.m_Active) do
            control:SetParent(WORLD_MAP_FILTERS.pvePanel.comboBoxPool.parent)
        end
        if ZO_WorldMapFiltersPvEComboBox1 then
            local valid, point, control, relPoint, x, y = ZO_WorldMapFiltersPvEComboBox1:GetAnchor(0)
            if control == WORLD_MAP_FILTERS.pvePanel.control then
                ZO_WorldMapFiltersPvEComboBox1:SetAnchor(point, ZO_WorldMapFiltersPvEContainerScrollChild, relPoint, x, y)
            end
        end
    end
    if ZO_WorldMapFiltersPvEContainer then
        ZO_WorldMapFiltersPvEContainer:SetAnchorFill()
    end

    if WORLD_MAP_FILTERS.pvpPanel.checkBoxPool then
        WORLD_MAP_FILTERS.pvpPanel.checkBoxPool.parent = ZO_WorldMapFiltersPvPContainerScrollChild or WINDOW_MANAGER:CreateControlFromVirtual("ZO_WorldMapFiltersPvPContainer", ZO_WorldMapFiltersPvP, "ZO_ScrollContainer"):GetNamedChild("ScrollChild")
        for i, control in pairs(WORLD_MAP_FILTERS.pvpPanel.checkBoxPool.m_Active) do
            control:SetParent(WORLD_MAP_FILTERS.pvpPanel.checkBoxPool.parent)
        end
        if ZO_WorldMapFiltersPvPCheckBox1 then
            local valid, point, control, relPoint, x, y = ZO_WorldMapFiltersPvPCheckBox1:GetAnchor(0)
            if control == WORLD_MAP_FILTERS.pvpPanel.control then
                ZO_WorldMapFiltersPvPCheckBox1:SetAnchor(point, ZO_WorldMapFiltersPvPContainerScrollChild, relPoint, x, y)
            end
        end
    end
    if WORLD_MAP_FILTERS.pvpPanel.comboBoxPool then
        WORLD_MAP_FILTERS.pvpPanel.comboBoxPool.parent = ZO_WorldMapFiltersPvPContainerScrollChild or WINDOW_MANAGER:CreateControlFromVirtual("ZO_WorldMapFiltersPvPContainer", ZO_WorldMapFiltersPvP, "ZO_ScrollContainer"):GetNamedChild("ScrollChild")
        for i, control in pairs(WORLD_MAP_FILTERS.pvpPanel.comboBoxPool.m_Active) do
            control:SetParent(WORLD_MAP_FILTERS.pvpPanel.comboBoxPool.parent)
        end
        if ZO_WorldMapFiltersPvPComboBox1 then
            local valid, point, control, relPoint, x, y = ZO_WorldMapFiltersPvPComboBox1:GetAnchor(0)
            if control == WORLD_MAP_FILTERS.pvpPanel.control then
                ZO_WorldMapFiltersPvPComboBox1:SetAnchor(point, ZO_WorldMapFiltersPvPContainerScrollChild, relPoint, x, y)
            end
        end
    end
    if ZO_WorldMapFiltersPvPContainer then
        ZO_WorldMapFiltersPvPContainer:SetAnchorFill()
    end

    if WORLD_MAP_FILTERS.imperialPvPPanel.checkBoxPool then
        WORLD_MAP_FILTERS.imperialPvPPanel.checkBoxPool.parent = ZO_WorldMapFiltersImperialPvPContainerScrollChild or WINDOW_MANAGER:CreateControlFromVirtual("ZO_WorldMapFiltersImperialPvPContainer", ZO_WorldMapFiltersImperialPvP, "ZO_ScrollContainer"):GetNamedChild("ScrollChild")
        for i, control in pairs(WORLD_MAP_FILTERS.imperialPvPPanel.checkBoxPool.m_Active) do
            control:SetParent(WORLD_MAP_FILTERS.imperialPvPPanel.checkBoxPool.parent)
        end
        if ZO_WorldMapFiltersImperialPvPCheckBox1 then
            local valid, point, control, relPoint, x, y = ZO_WorldMapFiltersImperialPvPCheckBox1:GetAnchor(0)
            if control == WORLD_MAP_FILTERS.imperialPvPPanel.control then
                ZO_WorldMapFiltersImperialPvPCheckBox1:SetAnchor(point, ZO_WorldMapFiltersImperialPvPContainerScrollChild, relPoint, x, y)
            end
        end
    end
    if WORLD_MAP_FILTERS.imperialPvPPanel.comboBoxPool then
        WORLD_MAP_FILTERS.imperialPvPPanel.comboBoxPool.parent = ZO_WorldMapFiltersImperialPvPContainerScrollChild or WINDOW_MANAGER:CreateControlFromVirtual("ZO_WorldMapFiltersImperialPvPContainer", ZO_WorldMapFiltersImperialPvP, "ZO_ScrollContainer"):GetNamedChild("ScrollChild")
        for i, control in pairs(WORLD_MAP_FILTERS.imperialPvPPanel.comboBoxPool.m_Active) do
            control:SetParent(WORLD_MAP_FILTERS.imperialPvPPanel.comboBoxPool.parent)
        end
        if ZO_WorldMapFiltersImperialPvPComboBox1 then
            local valid, point, control, relPoint, x, y = ZO_WorldMapFiltersImperialPvPComboBox1:GetAnchor(0)
            if control == WORLD_MAP_FILTERS.imperialPvPPanel.control then
                ZO_WorldMapFiltersPvPComboBox1:SetAnchor(point, ZO_WorldMapFiltersImperialPvPContainerScrollChild, relPoint, x, y)
            end
        end
    end
    if ZO_WorldMapFiltersImperialPvPContainer then
        ZO_WorldMapFiltersImperialPvPContainer:SetAnchorFill()
    end
	
	--[[
	
	End of LibMapPins code
	
	]]--
end

local function OnButtonToggled(pinTypeId, button, visible)
	local filterProfile = Harvest.mapPins.filterProfile
	filterProfile[pinTypeId] = visible
	CallbackManager:FireCallbacks(Events.FILTER_PROFILE_CHANGED, filterProfile, pinTypeId, visible)
end
-- code based on LibMapPin, see Libs/LibMapPin-1.0/LibMapPins-1.0.lua for credits
function MapPins:AddCheckbox(panel, text)
	local checkbox = panel.checkBoxPool:AcquireObject()
	ZO_CheckButton_SetLabelText(checkbox, text)
	panel:AnchorControl(checkbox)
	return checkbox
end

local function colorizeText(text, r,g,b,a)
	return string.format("|c%.2x%.2x%.2x%s|r", zo_round(r * 255), zo_round(g * 255), zo_round(b * 255), text)
end

local function NewSetColor(self, r, g, b, a, ...)
	local layout = Harvest.GetMapPinLayout(self.pinTypeId)
	local newText = layout.tint:Colorize(zo_iconFormatInheritColor(layout.texture, 20, 20))
	newText = newText .. colorizeText(self.text, r,g,b,a)
	self:SetText(newText)
end

function MapPins:AddResourceCheckbox(panel, pinTypeId)
	local text = Harvest.GetLocalization( "pintype" .. pinTypeId )
	local checkbox = self:AddCheckbox(panel, text)
	self.checkboxes[pinTypeId] = checkbox
	--self.checkboxForPinType[pinTypeId] = checkbox
	-- on mouse over the color is switched to "highlight"
	-- this removed the color of the texture, so we have to change the setColor behaviour
	local label = checkbox.label
	label.text = text
	label.SetColor = NewSetColor
	label.pinTypeId = pinTypeId
	
	ZO_CheckButton_SetLabelText(checkbox, text)
	ZO_CheckButton_SetCheckState(checkbox, self.filterProfile[pinTypeId])
	ZO_CheckButton_SetToggleFunction(checkbox, function(...) OnButtonToggled(pinTypeId, ...) end)
	ZO_CheckButtonLabel_ColorText(label, false)
	
	return checkbox
end

function MapPins:RegisterResourcePinTypes()
	local emptyFunction = function() end
	for _, pinTypeId in ipairs(Harvest.PINTYPES) do
		-- only register the resource pins, not hidden resources like psijic portals
		if not Harvest.HIDDEN_PINTYPES[pinTypeId] then
			local layout = Harvest.GetMapPinLayout( pinTypeId )
			-- some extra layout fields exclusive for QuickPins
			--layout.expectedPinCount = Harvest.expectedPinCount[pinTypeId]
			layout.OnClickHandler = MapPins.clickHandler
			
			-- create the pin type for this resource
			QuickPin:RegisterPinType(
				pinTypeId,
				emptyFunction, -- no callback is used,
				-- because all pins are created together in the pinType 0 callback
				layout
			)
			table.insert(self.resourcePinTypeIds, pinTypeId)
			
			self:AddResourceCheckbox(WORLD_MAP_FILTERS.pvePanel, pinTypeId )
			self:AddResourceCheckbox(WORLD_MAP_FILTERS.pvpPanel, pinTypeId )
			self:AddResourceCheckbox(WORLD_MAP_FILTERS.imperialPvPPanel, pinTypeId )
			
		end
	end
	-- this callback will receive the pin refresh request
	local pinTypeId = 0
	QuickPin:RegisterPinType(
		pinTypeId,
		function() self:PinTypeRefreshCallback() end
	)
end

function MapPins:AddHeatMapCheckbox()
	local pve = self:AddCheckbox(WORLD_MAP_FILTERS.pvePanel, Harvest.GetLocalization( "filterheatmap" ))
	local pvp = self:AddCheckbox(WORLD_MAP_FILTERS.pvpPanel, Harvest.GetLocalization( "filterheatmap" ))
	local imperialPvP = self:AddCheckbox(WORLD_MAP_FILTERS.imperialPvPPanel, Harvest.GetLocalization( "filterheatmap" ))
	local fun = function(button, state)
		Harvest.SetHeatmapActive(state)
	end
	ZO_CheckButton_SetToggleFunction(pve, fun)
	ZO_CheckButton_SetToggleFunction(pvp, fun)
	ZO_CheckButton_SetToggleFunction(imperialPvP, fun)

	ZO_CheckButton_SetCheckState(pve, Harvest.IsHeatmapActive())
	ZO_CheckButton_SetCheckState(pvp, Harvest.IsHeatmapActive())
	ZO_CheckButton_SetCheckState(imperialPvP, Harvest.IsHeatmapActive())
end

function MapPins:AddDeletePinCheckbox()
	local pve = self:AddCheckbox(WORLD_MAP_FILTERS.pvePanel, Harvest.GetLocalization( "deletepinfilter" ))
	local pvp = self:AddCheckbox(WORLD_MAP_FILTERS.pvpPanel, Harvest.GetLocalization( "deletepinfilter" ))
	local imperialPvP = self:AddCheckbox(WORLD_MAP_FILTERS.imperialPvPPanel, Harvest.GetLocalization( "deletepinfilter" ))
	local fun = function(button, state)
		Harvest.SetPinDeletionEnabled(state)
	end
	ZO_CheckButton_SetToggleFunction(pve, fun)
	ZO_CheckButton_SetToggleFunction(pvp, fun)
	ZO_CheckButton_SetToggleFunction(imperialPvP, fun)

	ZO_CheckButton_SetCheckState(pve, Harvest.IsPinDeletionEnabled())
	ZO_CheckButton_SetCheckState(pvp, Harvest.IsPinDeletionEnabled())
	ZO_CheckButton_SetCheckState(imperialPvP, Harvest.IsPinDeletionEnabled())
end

function MapPins:Initialize()
	-- coords of the last pin update for the "display only nearby pins" option
	self.lastViewedX = -10
	self.lastViewedY = -10
	self.checkboxes = {}
	self.filterProfile = Harvest.filterProfiles:GetMapProfile()
	
	self:RegisterCallbacks()
	
	self.resourcePinTypeIds = {}
	self:RegisterResourcePinTypes()
	
	-- additional filter checkboxes
	self:AddHeatMapCheckbox()
	self:AddDeletePinCheckbox()
	self:EnableScrollableFilters()
	
	self:RefreshVisibleDistance()
end

-- refreshes all resource pins
function MapPins:RefreshPinsBaseFunction( pinTypeId, quickPinFunction )
	for _, pinTypeId in ipairs(self.resourcePinTypeIds) do
		quickPinFunction(QuickPin, pinTypeId)
	end
	quickPinFunction(QuickPin, 0)
end

function MapPins:RedrawPins( pinTypeId )
	self.queue:Clear()
	self:RefreshPinsBaseFunction( pinTypeId, QuickPin.RedrawPinsOfPinType )
end

function MapPins:RefreshPins( pinTypeId )
	self.queue:Clear()
	self:RefreshPinsBaseFunction( pinTypeId, QuickPin.RefreshPinsOfPinType )
end

-- called every few seconds to update the pins in the visible range
function MapPins.UpdateVisibleMapPins()
	if Harvest.IsHeatmapActive() then return end
	
	local validMapMode = Harvest.AreMapPinsVisible() and not Harvest.mapMode:IsInMinimapMode()
	local validMinimapMode = Harvest.AreMinimapPinsVisible() and Harvest.mapMode:IsInMinimapMode()
	if not (validMapMode or validMinimapMode) then return end
	
	local map = Harvest.mapTools:GetMap()
	local x, y = Harvest.GetPlayer3DPosition()

	MapPins:AddAndRemoveVisblePins(map, x, y)
end

-- If the player moved, some pins enter the visible radius while others leave it.
-- This function updates the queue with new creation/removal commands according to the movement.
function MapPins:AddAndRemoveVisblePins(map, x, y)
	-- if there is no pin data available, or the data doesn't match the current map, abort.
	if not self.mapCache then return end
	if self.mapCache.map ~= map then return end
	-- no pins are displayed when the heatmap mode is used.
	if Harvest.IsHeatmapActive() then return end
	
	local validMapMode = Harvest.AreMapPinsVisible() and not Harvest.mapMode:IsInMinimapMode()
	local validMinimapMode = Harvest.AreMinimapPinsVisible() and Harvest.mapMode:IsInMinimapMode()
	if not (validMapMode or validMinimapMode) then return end
	
	-- add creation and removal commands to the pin queue.
	local shouldSaveCoords
	shouldSaveCoords = self.mapCache:SetPrevAndCurVisibleNodesToTable(self.lastViewedX, self.lastViewedY, x, y, self.visibleDistance, self.filterProfile, self.queue)
	-- the queue is only updated if the distance of the player's current position and the position of the last update is large enough.
	-- if the distance was large enough, we have to save the current position
	if shouldSaveCoords then
		self.lastViewedX = x
		self.lastViewedY = y
		self:RefreshUpdateHandler()
	end
end

-- saves the current map and position
-- and loads the resource data for the current map
function MapPins:SetToMapAndPosition(mapMetaData, worldX, worldY)
	local newMap = self.currentMap ~= mapMetaData.map
	-- save current map
	self.currentMap = mapMetaData.map
	-- remove old cache and load the new one
	if self.mapCache then
		self.mapCache.accessed = self.mapCache.accessed - 1
	end
	self.mapCache = Harvest.Data:GetMapCache(mapMetaData)
	self.queue:Clear()
	-- if no data is available for this map, abort.
	if not self.mapCache then
		return
	end
	self.mapCache.accessed = self.mapCache.accessed + 1
	
	-- set the last position of the player when the map pins were refreshed, for the "display only in range pins" option
	self.lastViewedX = worldX
	self.lastViewedY = worldY
	
	for _, pinTypeId in ipairs(Harvest.PINTYPES) do
		if self.filterProfile[pinTypeId] then
			Harvest.Data:CheckPinTypeInCache(pinTypeId, self.mapCache)
			self.mapCache:GetVisibleNodes(self.lastViewedX, self.lastViewedY, pinTypeId, self.visibleDistance, self.queue)
		end
	end
	
	if newMap then
		CallbackManager:FireCallbacks(Events.MAP_CHANGE)
	end
end

function MapPins:IsActiveMap(map)
	if not self.mapCache then return false end
	return (self.mapCache.map == map)
end

function MapPins:PinTypeRefreshCallback()
	self:Debug("Refresh of pins requested.")
	
	-- clear the queue of remaining pin creation/removal commands
	self.queue:Clear()
	
	if Harvest.IsHeatmapActive() then
		self:Debug("pins could not be refreshed, heatmap is active" )
		return
	end
	local validMapMode = Harvest.AreMapPinsVisible() and not Harvest.mapMode:IsInMinimapMode()
	local validMinimapMode = Harvest.AreMinimapPinsVisible() and Harvest.mapMode:IsInMinimapMode()
	if not (validMapMode or validMinimapMode) then return end
	
	local mapMetaData = Harvest.mapTools:GetViewedMapMetaData()
	local worldX, worldY = Harvest.GetPlayer3DPosition()
	self:SetToMapAndPosition(mapMetaData, worldX, worldY)
	self:RefreshUpdateHandler()
end

-- when the debug mode is enabled, this is the description of what happens if the player clicks on a pin.
-- if a pin is clicked, the node is deleted.
MapPins.clickHandler = {-- debugHandler = {
	{
		callback = function(...) return Harvest.farm.helper:OnPinClicked(...) end,
		show = function(pin)
			if not Harvest.farm.path then return false end
			
			local nodeId = pin.m_PinTag
			local index = Harvest.farm.path:GetIndex(nodeId)
			if not index then return false end
			
			return true
		end,
	},
	{
		name = MapPins.nameFunction,
		callback = function(pin)
			-- remove this callback if the debug mode is disabled
			if not Harvest.IsPinDeletionEnabled() or IsInGamepadPreferredMode() then
				return
			end
			-- otherwise request the node to be deleted
			local nodeId = pin.m_PinTag
			local mapCache = MapPins.mapCache
			local worldX = mapCache.worldX[nodeId]
			local worldY = mapCache.worldY[nodeId]
			local worldZ = mapCache.worldZ[nodeId]
			local pinTypeId = mapCache.pinTypeId[nodeId]
			local mapMetaData = mapCache.mapMetaData
				
			CallbackManager:FireCallbacks(Events.NODE_DELETION_REQUEST, 
				mapMetaData, worldX, worldY, worldZ, pinTypeId)
			
		end,
		show = function() return Harvest.IsPinDeletionEnabled() and not IsInGamepadPreferredMode() end,
	}
}


-- these settings are handled by simply refreshing the map pins.
local redrawOnSetting = {
	--hasVisibleDistance = true,
	--visibleDistance = true,
	heatmapActive = true,
	mapPinsVisible = true,
	minimapPinsVisible = true,
	mapPinTypeVisible = true,
	mapSpawnFilter = true,
	minimapSpawnFilter = true,
}
local refreshOnSetting = {
	pinTypeSize = true,
	mapPinTexture = true,
	pinTypeColor = true,
	pinAbovePoi = true,
}
function MapPins:OnSettingsChanged(event, setting, ...)
	if redrawOnSetting[setting] then
		self:RedrawPins()
	elseif refreshOnSetting[setting] then
		self:RefreshPins()
	elseif setting == "hasVisibleDistance" or setting == "visibleDistance" then
		self:RefreshVisibleDistance()
	elseif setting == "mapFilterProfile" then
		self.filterProfile = Harvest.filterProfiles:GetMapProfile()
		for pinTypeId, checkbox in pairs(self.checkboxes) do
			ZO_CheckButton_SetCheckState(checkbox, self.filterProfile[pinTypeId])
		end
		self:RedrawPins()
		if Harvest.IsHeatmapActive() then
			HarvestHeat.RefreshHeatmap()
		end
	elseif setting == "cacheCleared" then
		local map = ...
		if map == self.currentMap or not map then
			self:RedrawPins()
		end
	end
end
