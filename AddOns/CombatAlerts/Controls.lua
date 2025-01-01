local LCA = LibCombatAlerts
local CA2 = CombatAlerts2


--------------------------------------------------------------------------------
-- Status panel
--------------------------------------------------------------------------------

do
	local Status
	local function GetStatus( )
		if (not Status) then
			Status = LCA_StatusPanel:New()
			Status:SetRepositionCallback(function(pos) CA2.sv.statusPanel = pos end)
		end
		return Status
	end

	function CA2.StatusEnable( options )
		options = options or { }
		options.pos = CA2.sv.statusPanel
		return GetStatus():Enable(options)
	end

	function CA2.StatusDisable( )
		if (Status) then
			Status:Disable()
		end
	end

	function CA2.StatusGetOwnerId( )
		if (Status) then
			return Status:GetOwnerId()
		else
			return nil
		end
	end

	function CA2.StatusSetPosition( ... )
		if (CA2.StatusGetOwnerId()) then
			Status:SetPosition(...)
		end
	end

	function CA2.StatusSetRowColor( ... )
		if (CA2.StatusGetOwnerId()) then
			Status:SetRowColor(...)
		end
	end

	function CA2.StatusSetRowAlpha( ... )
		if (CA2.StatusGetOwnerId()) then
			Status:SetRowAlpha(...)
		end
	end

	function CA2.StatusSetRowHidden( ... )
		if (CA2.StatusGetOwnerId()) then
			Status:SetRowHidden(...)
		end
	end

	function CA2.StatusModifyCell( ... )
		if (CA2.StatusGetOwnerId()) then
			Status:ModifyCell(...)
		end
	end

	function CA2.StatusSetCellText( r, c, text )
		if (CA2.StatusGetOwnerId()) then
			Status:ModifyCell(r, c, { text = text })
		end
	end
end


--------------------------------------------------------------------------------
-- Group status panel
--------------------------------------------------------------------------------

do
	local GroupPanel
	local function GetGroupPanel( )
		if (not GroupPanel) then
			GroupPanel = LCA_GroupPanel:New()
			GroupPanel:SetRepositionCallback(function(pos) CA2.sv.groupPanel = pos end)
		end
		return GroupPanel
	end

	function CA2.GroupPanelEnable( options )
		options = options or { }
		options.pos = CA2.sv.groupPanel
		GetGroupPanel():Enable(options)
	end

	function CA2.GroupPanelDisable( )
		if (GroupPanel) then
			GroupPanel:Disable()
		end
	end

	function CA2.GroupPanelIsEnabled( )
		if (GroupPanel) then
			return GroupPanel:IsEnabled()
		else
			return false
		end
	end

	function CA2.GroupPanelSetPosition( ... )
		if (CA2.GroupPanelIsEnabled()) then
			GroupPanel:SetPosition(...)
		end
	end

	function CA2.GroupPanelUpdate( ... )
		if (CA2.GroupPanelIsEnabled()) then
			GroupPanel:UpdateUnitData(...)
		end
	end
end


--------------------------------------------------------------------------------
-- Screen border alerts
--------------------------------------------------------------------------------

do
	local Border
	local function GetBorder( )
		if (not Border) then
			Border = LCA_ScreenBorder:New()
		end
		return Border
	end

	function CA2.ScreenBorderEnable( ... )
		return GetBorder():Enable(...)
	end

	function CA2.ScreenBorderDisable( ... )
		if (Border) then
			Border:Disable(...)
		end
	end
end


--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

function CA2.CleanupControls( )
	CA2.StatusDisable()
	CA2.GroupPanelDisable()
	CA2.ScreenBorderDisable()
end
