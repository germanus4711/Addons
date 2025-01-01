local LCA = LibCombatAlerts


--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

-- Also publicly exposed in the Public Interface section below; see comment there regarding usage
local SHOW_TANK   = 0x01
local SHOW_HEALER = 0x02
local SHOW_DAMAGE = 0x04
local SHOW_OTHER  = 0x08
local SHOW_ALL    = 0x0F -- SHOW_TANK | SHOW_HEALER | SHOW_DAMAGE | SHOW_OTHER

local OTHER_WIDTH = 28 -- 20 for role icon, 2x2 padding around role icon, 4 padding at end
local REFRESH_DELAY = 500

local DEFAULT_POSITION = {
	right = 0,
	mid = 0,
}

local DEFAULT_OPTIONS = {
	-- Appearance
	headerText = -1,
	colorHeader = 0xFFFFFFFF,
	colorBG = 0x00000077,
	colorName = 0xFFFFFFFF,
	colorStat = 0xFFFF00FF,
	columns = 2,
	paneWidth = 160,
	statWidth = 26,
	showRoles = SHOW_ALL,

	-- Options
	useUnitId = true,
	useRange = true,
	highlightSelf = true,
}

local ROLE_ICONS = {
	[LFG_ROLE_DPS] = "/esoui/art/lfg/lfg_icon_dps.dds",
	[LFG_ROLE_TANK] = "/esoui/art/lfg/lfg_icon_tank.dds",
	[LFG_ROLE_HEAL] = "/esoui/art/lfg/lfg_icon_healer.dds",
	[LFG_ROLE_INVALID] = "/esoui/art/crafting/gamepad/crafting_alchemy_trait_unknown.dds",
}


--------------------------------------------------------------------------------
-- LCA_GroupPanel
--------------------------------------------------------------------------------

LCA_GroupPanel = ZO_Object:Subclass()
local LCA_GroupPanel = LCA_GroupPanel

local nextInstanceId = 1

local function Identifier( x )
	return "LCA_GroupPanel_" .. x
end

-- Preserve GuiRoot to guard against redefinition
local GuiRoot = GuiRoot


--------------------------------------------------------------------------------
-- Public interface
--------------------------------------------------------------------------------

-- Flags for the showRoles field for role filtering; combine using bitwise or
LCA.GROUP_PANEL_SHOW_TANK = SHOW_TANK
LCA.GROUP_PANEL_SHOW_HEALER = SHOW_HEALER
LCA.GROUP_PANEL_SHOW_DAMAGE = SHOW_DAMAGE
LCA.GROUP_PANEL_SHOW_OTHER = SHOW_OTHER
LCA.GROUP_PANEL_SHOW_ALL = SHOW_ALL

function LCA_GroupPanel:New( )
	local obj = ZO_Object.New(self)

	obj.name = Identifier(nextInstanceId)
	nextInstanceId = nextInstanceId + 1

	obj.enabled = false
	obj.listening = false

	-- Initialize top-level control
	obj.control = WINDOW_MANAGER:CreateControlFromVirtual(obj.name, GuiRoot, "LCA_GroupPanel")
	obj.fragment = ZO_HUDFadeSceneFragment:New(obj.control)

	-- Initialize child elements
	obj.header = obj.control:GetNamedChild("Header")
	obj.panes = { }
	for i = 1, GROUP_SIZE_MAX do
		local control = WINDOW_MANAGER:CreateControlFromVirtual(string.format("%s_Pane%d", obj.name, i), obj.control, "LCA_GroupPanel_Pane")
		obj.panes[i] = {
			control = control,
			bg = control:GetNamedChild("Backdrop"),
			name = control:GetNamedChild("Name"),
			role = control:GetNamedChild("Role"),
			stat = control:GetNamedChild("Stat"),
		}
		obj.panes[i].bg:SetEdgeColor(0, 0, 0, 0)
	end

	-- Positioning
	obj.positioner = LCA_MoveableControl:New(obj.control)

	return obj
end

function LCA_GroupPanel:SetRepositionCallback( fn )
	self.positioner:RegisterCallback(self.name, LCA.EVENT_CONTROL_MOVE_STOP, fn)
end

function LCA_GroupPanel:SetPosition( pos )
	self.positioner:UpdatePosition(pos or DEFAULT_POSITION)
end

function LCA_GroupPanel:GetDefaultPosition( )
	return ZO_ShallowTableCopy(DEFAULT_POSITION)
end

function LCA_GroupPanel:Enable( options )
	self.enabled = true
	self.options = LCA.PopulateOptions(options, DEFAULT_OPTIONS)
	self.data = { }

	-- Start listeners
	if (not self.listening) then
		self.listening = true
		local DelayedRefreshGroup = function( )
			EVENT_MANAGER:UnregisterForUpdate(self.name)
			EVENT_MANAGER:RegisterForUpdate(
				self.name,
				REFRESH_DELAY,
				function( )
					EVENT_MANAGER:UnregisterForUpdate(self.name)
					self:RefreshGroup()
				end
			)
		end
		EVENT_MANAGER:RegisterForEvent(self.name, EVENT_GROUP_MEMBER_JOINED, DelayedRefreshGroup)
		EVENT_MANAGER:RegisterForEvent(self.name, EVENT_GROUP_MEMBER_LEFT, DelayedRefreshGroup)
		EVENT_MANAGER:RegisterForEvent(self.name, EVENT_GROUP_MEMBER_ROLE_CHANGED, DelayedRefreshGroup)
		EVENT_MANAGER:RegisterForEvent(self.name, EVENT_GROUP_UPDATE, DelayedRefreshGroup)
		EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_ACTIVATED, DelayedRefreshGroup)
	end

	if (self.options.useRange) then
		EVENT_MANAGER:RegisterForEvent(self.name, EVENT_GROUP_SUPPORT_RANGE_UPDATE, function(_, ...) self:OnGroupSupportRangeUpdate(...) end)
	end
	if (self.options.useUnitId) then
		LCA.ToggleUnitIdTracking(self.name, true)
	end

	-- Initialize appearance and show
	self.header:SetWidth(self.options.paneWidth * self.options.columns)
	self.header:SetColor(LCA.UnpackRGBA(self.options.colorHeader))
	self.header:SetText((self.options.headerText == -1) and LCA.GetZoneName(LCA.GetZoneId()) or self.options.headerText)
	self:RefreshGroup()
	self:SetPosition(self.options.pos)
	LCA.ToggleUIFragment(self.fragment, true)
end

function LCA_GroupPanel:Disable( )
	if (self.enabled) then
		self.enabled = false

		-- Stop listeners
		self.listening = false
		EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_GROUP_MEMBER_JOINED)
		EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_GROUP_MEMBER_LEFT)
		EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_GROUP_MEMBER_ROLE_CHANGED)
		EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_GROUP_UPDATE)
		EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_PLAYER_ACTIVATED)
		EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_GROUP_SUPPORT_RANGE_UPDATE)
		LCA.ToggleUnitIdTracking(self.name, false)

		-- Hide
		LCA.ToggleUIFragment(self.fragment, false)
	end
end

function LCA_GroupPanel:IsEnabled( )
	return self.enabled
end

function LCA_GroupPanel:UpdateUnitData( unitTag, unitId, color, statText )
	if (not self.enabled) then return end

	local unitTagOrId
	if (self.options.useUnitId) then
		if (type(unitId) ~= "number" and type(unitTag) == "string") then
			unitId = LCA.IdentifyGroupUnitTag(unitTag)
		end
		if (type(unitId) == "number") then
			unitTagOrId = unitId
		end
	elseif (type(unitTag) == "string") then
		unitTagOrId = unitTag
	end

	if (unitTagOrId) then
		self.data[unitTagOrId] = {
			color = color,
			statText = statText,
		}
		self:UpdatePaneDisplayForUnit(unitTag, unitId)
	end
end


--------------------------------------------------------------------------------
-- Private functions; do not call these externally
--------------------------------------------------------------------------------

function LCA_GroupPanel:OnGroupSupportRangeUpdate( unitTag, status )
	if (self.units[unitTag]) then
		self:UpdatePaneDisplay(self.units[unitTag].paneId, nil, nil, (status or not self.options.useRange) and 1 or 0.5)
	end
end

function LCA_GroupPanel:UpdatePaneDisplay( paneId, color, statText, alpha )
	local pane = self.panes[paneId]

	if (color and color ~= pane.lcaCurrentColor) then
		pane.lcaCurrentColor = color
		pane.bg:SetCenterColor(LCA.UnpackRGBA(color))
	end

	if (statText and statText ~= pane.lcaCurrentStat) then
		pane.lcaCurrentStat = statText
		pane.stat:SetText(statText)
	end

	if (alpha and alpha ~= pane.lcaCurrentAlpha) then
		pane.lcaCurrentAlpha = alpha
		pane.control:SetAlpha(alpha)
	end
end

function LCA_GroupPanel:UpdatePaneDisplayForUnit( unitTag, unitId )
	if (type(unitTag) ~= "string" and type(unitId) == "number") then
		unitTag = LCA.IdentifyGroupUnitId(unitId)
	end

	if (type(unitTag) == "string" and self.units[unitTag]) then
		local data, color, statText

		if (self.options.useUnitId) then
			if (type(unitId) ~= "number") then
				unitId = LCA.IdentifyGroupUnitTag(unitTag)
			end
			if (unitId) then
				data = self.data[unitId]
			end
		else
			data = self.data[unitTag]
		end

		if (data) then
			color = data.color
			if (color and self.options.highlightSelf and self.units[unitTag].isSelf) then
				color = BitOr(color, 0xFF)
			end
			statText = data.statText
		end

		self:UpdatePaneDisplay(self.units[unitTag].paneId, color or self.options.colorBG, statText or "")
	end
end

local function FindNextValidMemberIndex( members, index, flags )
	if (index) then
		for i = index + 1, #members do
			local role = members[i].role

			if ( (role == LFG_ROLE_TANK and BitAnd(flags, SHOW_TANK) > 0) or
			     (role == LFG_ROLE_HEAL and BitAnd(flags, SHOW_HEALER) > 0) or
			     (role == LFG_ROLE_DPS and BitAnd(flags, SHOW_DAMAGE) > 0) or
			     (role == LFG_ROLE_INVALID and BitAnd(flags, SHOW_OTHER) > 0) ) then
				return i
			end
		end
	end

	return nil
end

function LCA_GroupPanel:RefreshGroup( )
	self.units = { }
	local members = LCA.GetSortedGroupMembers()
	local memberIndex = 0

	for i = 1, GROUP_SIZE_MAX do
		local pane = self.panes[i]

		memberIndex = FindNextValidMemberIndex(members, memberIndex, self.options.showRoles)

		if (memberIndex) then
			local member = members[memberIndex]
			local unitTag = member.unitTag
			self.units[unitTag] = {
				paneId = i,
				isSelf = AreUnitsEqual("player", unitTag),
			}

			pane.bg:SetWidth(self.options.paneWidth)
			pane.name:SetWidth(self.options.paneWidth - self.options.statWidth - OTHER_WIDTH)
			pane.stat:SetWidth(self.options.statWidth)

			pane.role:SetTexture(ROLE_ICONS[member.role])
			pane.name:SetText(UndecorateDisplayName(member.account))
			pane.name:SetColor(LCA.UnpackRGBA(self.options.colorName))
			pane.stat:SetColor(LCA.UnpackRGBA(self.options.colorStat))

			self:UpdatePaneDisplayForUnit(unitTag)
			self:OnGroupSupportRangeUpdate(unitTag, IsUnitInGroupSupportRange(unitTag))

			if (i == 1) then
				-- First pane
				pane.control:SetAnchor(TOPLEFT, self.header, BOTTOMLEFT)
			elseif (i <= self.options.columns) then
				-- Remainder of the first row
				pane.control:SetAnchor(TOPLEFT, self.panes[i - 1].control, TOPRIGHT)
			else
				-- All other panes
				pane.control:SetAnchor(TOPLEFT, self.panes[i - self.options.columns].control, BOTTOMLEFT)
			end
			pane.control:SetHidden(false)
		else
			pane.control:SetAnchor(TOPLEFT, self.control, TOPLEFT)
			pane.control:SetHidden(true)
		end
	end
end
