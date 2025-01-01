local LCA = LibCombatAlerts


--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

local POLLING_INTERVAL = 100
local GUIDE_THICKNESS = 2
local GUIDE_COLOR_NORMAL = 0xFFFFFF44
local GUIDE_COLOR_HILITE = 0xFFFFFFFF
local CENTER_SENSITIVITY = 12
local CENTER_THRESHOLD = 1000 -- 1s

local DEFAULT_OPTIONS = {
	color = 0xFFFFFFFF,
	size = 4,
}

local ANCHOR_POINTS = {
	L = {
		T = TOPLEFT,
		M = LEFT,
		B = BOTTOMLEFT,
	},
	C = {
		T = TOP,
		M = CENTER,
		B = BOTTOM,
	},
	R = {
		T = TOPRIGHT,
		M = RIGHT,
		B = BOTTOMRIGHT,
	},
}

local POSITION_NAMES = {
	left = { "X", "L" },
	center = { "X", "C" },
	right = { "X", "R" },
	top = { "Y", "T" },
	mid = { "Y", "M" },
	bottom = { "Y", "B" },
}

local EVENT_START = 1
local EVENT_STOP = 2


--------------------------------------------------------------------------------
-- LCA_MoveableControl
--------------------------------------------------------------------------------

LCA_MoveableControl = ZO_Object:Subclass()
local LCA_MoveableControl = LCA_MoveableControl

local nextInstanceId = 1

local function Identifier( x )
	return "LCA_MoveableControl_" .. x
end

-- Preserve GuiRoot to guard against redefinition
local GuiRoot = GuiRoot


--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local function InitializeLine( parent, name, color, size, x, dashed )
	local control = parent:GetNamedChild(name)
	control:SetEdgeColor(0, 0, 0, 0)
	control:SetCenterColor(LCA.UnpackRGBA(color))
	if (x) then
		control:SetWidth(size)
	else
		control:SetHeight(size)
	end
	if (dashed) then
		control:SetCenterTexture(LCA.GetTexture("misc-checkered16"), 16, TEX_MODE_WRAP)
	end
	return control
end

local ScreenGuide
local function GetScreenGuide( )
	if (not ScreenGuide) then
		ScreenGuide = WINDOW_MANAGER:CreateControlFromVirtual(Identifier("ScreenGuide"), GuiRoot, "LCA_PositioningGuide")
		ScreenGuide:SetAnchorFill()
		local x = InitializeLine(ScreenGuide, "GuideX", GUIDE_COLOR_NORMAL, GUIDE_THICKNESS, true, true)
		local y = InitializeLine(ScreenGuide, "GuideY", GUIDE_COLOR_NORMAL, GUIDE_THICKNESS, false, true)
		x:SetHidden(false)
		y:SetHidden(false)
	end
	return ScreenGuide
end


--------------------------------------------------------------------------------
-- Public interface
--------------------------------------------------------------------------------

LCA.EVENT_CONTROL_MOVE_START = EVENT_START
LCA.EVENT_CONTROL_MOVE_STOP = EVENT_STOP

function LCA_MoveableControl:New( control, options )
	local obj = ZO_Object.New(self)

	obj.name = Identifier(nextInstanceId)
	nextInstanceId = nextInstanceId + 1

	obj.control = control
	control.lcamc = obj

	-- Fallback defaults
	obj.X = "L"
	obj.Y = "T"

	-- Initialize anchor markers and guide lines
	local opt = LCA.PopulateOptions(options, DEFAULT_OPTIONS)
	obj.anchorX = InitializeLine(control, "AnchorX", opt.color, opt.size, true)
	obj.anchorY = InitializeLine(control, "AnchorY", opt.color, opt.size, false)
	obj.guideX = InitializeLine(control, "GuideX", GUIDE_COLOR_NORMAL, GUIDE_THICKNESS, true, true)
	obj.guideY = InitializeLine(control, "GuideY", GUIDE_COLOR_NORMAL, GUIDE_THICKNESS, false, true)

	-- Initialize callbacks
	obj.callbacks = {
		[EVENT_START] = { },
		[EVENT_STOP] = { },
	}

	return obj
end

function LCA_MoveableControl:UpdatePosition( pos )
	local offsets = { }

	for name, data in pairs(POSITION_NAMES) do
		if (type(pos[name]) == "number") then
			self[data[1]] = data[2]
			offsets[data[1]] = pos[name]
		end
	end

	local anchorPoint = ANCHOR_POINTS[self.X][self.Y]
	self.control:ClearAnchors()
	self.control:SetAnchor(anchorPoint, GuiRoot, anchorPoint, offsets.X or 0, offsets.Y or 0)
end

function LCA_MoveableControl:GetPosition( bypassCache )
	if (bypassCache or not self.pos) then
		local control = self.control
		local pos = { }

		if (self.X == "C") then
			pos.center = control:GetCenter() - GuiRoot:GetCenter()
		elseif (self.X == "R") then
			pos.right = control:GetRight() - GuiRoot:GetWidth()
		else
			pos.left = control:GetLeft()
		end

		if (self.Y == "M") then
			pos.mid = select(2, control:GetCenter()) - select(2, GuiRoot:GetCenter())
		elseif (self.Y == "B") then
			pos.bottom = control:GetBottom() - GuiRoot:GetHeight()
		else
			pos.top = control:GetTop()
		end

		self.pos = pos
	end

	return self.pos
end

function LCA_MoveableControl:RegisterCallback( name, eventCode, callback )
	-- Passing nil for callback will unregister
	if (name and eventCode and self.callbacks[eventCode]) then
		self.callbacks[eventCode][name] = callback
	end
end


--------------------------------------------------------------------------------
-- Private functions; do not call these externally
--------------------------------------------------------------------------------

function LCA_MoveableControl:FireCallback( eventCode, ... )
	for _, callback in pairs(self.callbacks[eventCode]) do
		callback(...)
	end
end

function LCA_MoveableControl:UpdateAnchorMarkers( )
	self.anchorX:ClearAnchors()
	self.anchorX:SetAnchor(ANCHOR_POINTS[self.X]["T"])
	self.anchorX:SetAnchor(BOTTOM, nil, nil, nil, nil, ANCHOR_CONSTRAINS_Y)

	self.anchorY:ClearAnchors()
	self.anchorY:SetAnchor(ANCHOR_POINTS["L"][self.Y])
	self.anchorY:SetAnchor(RIGHT, nil, nil, nil, nil, ANCHOR_CONSTRAINS_X)
end

function LCA_MoveableControl:ToggleMovement( enable )
	if (enable) then
		EVENT_MANAGER:RegisterForUpdate(self.name, POLLING_INTERVAL, function() self:MovementPoll() end)
		self:MovementPoll()
		self:UpdateAnchorMarkers()
		self.anchorX:SetHidden(false)
		self.anchorY:SetHidden(false)
		self.guideX:SetHidden(false)
		self.guideY:SetHidden(false)
		GetScreenGuide():SetHidden(false)
		WINDOW_MANAGER:SetMouseCursor(MOUSE_CURSOR_PAN)
	else
		EVENT_MANAGER:UnregisterForUpdate(self.name)
		self:MovementPoll()
		self:ToggleCenterHighlight("X")
		self:ToggleCenterHighlight("Y")
		self.anchorX:SetHidden(true)
		self.anchorY:SetHidden(true)
		self.guideX:SetHidden(true)
		self.guideY:SetHidden(true)
		GetScreenGuide():SetHidden(true)
		WINDOW_MANAGER:SetMouseCursor(MOUSE_CURSOR_DO_NOT_CARE)
	end
end

function LCA_MoveableControl:ToggleCenterHighlight( direction, time )
	local key = "time" .. direction
	if (not self[key] and time) then
		self[key] = time
		self["guide" .. direction]:SetCenterColor(LCA.UnpackRGBA(GUIDE_COLOR_HILITE))
	elseif (self[key] and not time) then
		self[key] = nil
		self["guide" .. direction]:SetCenterColor(LCA.UnpackRGBA(GUIDE_COLOR_NORMAL))
	end
end

function LCA_MoveableControl:MovementPoll( )
	local currentTime = GetGameTimeMilliseconds()

	if (self.X ~= "C" and zo_abs(self.control:GetCenter() - GuiRoot:GetCenter()) < CENTER_SENSITIVITY) then
		self:ToggleCenterHighlight("X", currentTime)
		if (currentTime - self.timeX > CENTER_THRESHOLD) then
			self.X = "C"
			self:ToggleCenterHighlight("X")
			self:UpdateAnchorMarkers()
		end
	else
		self:ToggleCenterHighlight("X")
		if (self.X ~= "L" and self.control:GetLeft() <= 0) then
			self.X = "L"
			self:UpdateAnchorMarkers()
		elseif (self.X ~= "R" and self.control:GetRight() >= GuiRoot:GetWidth()) then
			self.X = "R"
			self:UpdateAnchorMarkers()
		end
	end

	if (self.Y ~= "M" and zo_abs(select(2, self.control:GetCenter()) - select(2, GuiRoot:GetCenter())) < CENTER_SENSITIVITY) then
		self:ToggleCenterHighlight("Y", currentTime)
		if (currentTime - self.timeY > CENTER_THRESHOLD) then
			self.Y = "M"
			self:ToggleCenterHighlight("Y")
			self:UpdateAnchorMarkers()
		end
	else
		self:ToggleCenterHighlight("Y")
		if (self.Y ~= "T" and self.control:GetTop() <= 0) then
			self.Y = "T"
			self:UpdateAnchorMarkers()
		elseif (self.Y ~= "B" and self.control:GetBottom() >= GuiRoot:GetHeight()) then
			self.Y = "B"
			self:UpdateAnchorMarkers()
		end
	end
end

function LCA_MoveableControl:OnMoveStart( )
	self:ToggleMovement(true)
	self:FireCallback(EVENT_START)
end

function LCA_MoveableControl:OnMoveStop( )
	self:ToggleMovement(false)
	local pos = self:GetPosition(true)
	self:UpdatePosition(pos)
	self:FireCallback(EVENT_STOP, pos)
end


--------------------------------------------------------------------------------
-- XML Handlers
--------------------------------------------------------------------------------

function LCA_MoveableControl_OnMoveStart( control )
	if (control.lcamc) then
		control.lcamc:OnMoveStart()
	end
end

function LCA_MoveableControl_OnMoveStop( control )
	if (control.lcamc) then
		control.lcamc:OnMoveStop()
	end
end
