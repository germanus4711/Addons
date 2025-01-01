local LCCC = LibCodesCommonCode

if (LibCombatAlerts) then return end
local Public = { }
LibCombatAlerts = Public


--------------------------------------------------------------------------------
-- Internal Components
--------------------------------------------------------------------------------

local Internal = {
	name = "LibCombatAlerts",
}
LibCombatAlertsInternal = Internal

do
	local cachedPath = nil

	local function GetRootPath( )
		local am = GetAddOnManager()
		for i = 1, am:GetNumAddOns() do
			if (am:GetAddOnInfo(i) == Internal.name) then
				return zo_strsub(am:GetAddOnRootDirectoryPath(i), 13, -1)
			end
		end
		return string.format("/%s/", Internal.name)
	end

	function Internal.GetRootPath( )
		if (not cachedPath) then
			cachedPath = GetRootPath()
		end
		return cachedPath
	end
end
