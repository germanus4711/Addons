-- Initialize File
PITHKA           = PITHKA or {}
PITHKA.UI        = PITHKA.UI or {}
PITHKA.UI.Icons = {}




------------------------------------------------------------------------------------------------------------------
-- Basic Icon  
------------------------------------------------------------------------------------------------------------------

function PITHKA.UI.Icons.basic(data)
	data.s   = data.s or PITHKA.UI.Constants.iconSize
    data.c   = data.c or  PITHKA.UI.Constants.rgbWhite
    data.tta = data.tta or BOTTOM -- tooltip anchor
	data.ttf = data.ttf or PITHKA.UI.Constants.tooltipFont
	data.ttc = data.ttc or PITHKA.UI.Constants.hexGold

	-- static settings
	local control = WINDOW_MANAGER:CreateControl("$(parent)_Icon" .. PITHKA.Utils.uid(), PITHKA_GUI, CT_TEXTURE)
	control:SetDimensions(data.s, data.s)      
	control:SetTexture(data.t) 
    control:SetColor(unpack(data.c))
	control:SetDrawTier(DT_HIGH)
	
    -- optionally add tooltip
	if data.tt then
		control:SetMouseEnabled(true)
		control:SetHandler("OnMouseEnter", function(control) 
			ZO_Tooltips_ShowTextTooltip(control, data.tta)
			InformationTooltip:AddLine(string.format('|%s%s|r', data.ttc, data.tt), data.ttf)
			end)
		control:SetHandler("OnMouseExit", function (control) 
			ClearTooltip(InformationTooltip)
			end)  
	end		

    -- optionally setup conditional visibility
	if data.v then
		PITHKA.UI.Layout.registerRefreshFn(function()
			control:SetHidden(not data.v())
			end)
	end
	
	return control
end


------------------------------------------------------------------------------------------------------------------
-- Achievement Icon  
------------------------------------------------------------------------------------------------------------------

function PITHKA.UI.Icons.achievement(data)
	-- if aid is nil, use static icon
	if data.a==nil then 
        -- can also use this for future AIDS, defined but doesn't exist check add following to if statement
        -- PITHKA.utils.aidExists(data.aid)
        data.t  = PITHKA.UI.Constants.texture.X
		data.c  = PITHKA.UI.Constants.rgbGray
		data.tt = 'does not exist'
		return PITHKA.UI.Icons.basic(data)
	end
		

	-- create control
	local control = PITHKA.UI.Icons.basic(data)
	control:SetMouseEnabled(true)
	control:SetHandler("OnMouseExit",  function (control) 
		ClearTooltip(InformationTooltip)
		ClearTooltip(ItemTooltip)
		end)
		
	-- if ESOAPI returns link, use achievement tt, else use "coming soon" tt
	local released = GetAchievementIdFromLink(GetAchievementLink(data.a,1)) ~= 0 -- kinda hacky existance check
	if released then

		-- set hover
		control:SetHandler("OnMouseEnter", function(control) 
			InitializeTooltip(ItemTooltip, control, TOP, 0, 0, BOTTOM)
			ItemTooltip:SetLink(GetAchievementLink(data.a,1))
		end)


		-- set click: show journal 
		control:SetHandler("OnMouseUp", function (control, mButton) -- control and mButoon passed in context
			if mButton == 1	then
				-- open achievement window
				if not SCENE_MANAGER:IsShowing("achievements") then
					MAIN_MENU_KEYBOARD:ShowScene("achievements")
				end			
				-- set global aid for callback
				PITHKA.ACHIEVEMENTAID = data.a			
				-- update search box
				ACHIEVEMENTS.contentSearchEditBox:SetText(GetAchievementName(data.a))
			end
		end)

	else
		-- set hover
		control:SetHandler("OnMouseEnter", function(control) 
			ZO_Tooltips_ShowTextTooltip(control, BOTTOM)
			InformationTooltip:AddLine(string.format('|%s%s|r', PITHKA.UI.Constants.hexGold, "Coming Soon"), PITHKA.UI.Constants.tooltipFont)
		end)
	end
        	        
	-- set dynamic settings
	PITHKA.UI.Layout.registerRefreshFn(function()
		-- texture is check or box
		control:SetTexture(IsAchievementComplete(data.a) and PITHKA.UI.Constants.texture.CHECK or PITHKA.UI.Constants.texture.BOX)
		-- color is green or gray
		control:SetColor(unpack(IsAchievementComplete(data.a) and PITHKA.UI.Constants.rgbGreen or PITHKA.UI.Constants.rgbGray))
		end)

	return control
end


------------------------------------------------------------------------------------------------------------------
-- Navigation Buttons
------------------------------------------------------------------------------------------------------------------
function PITHKA.UI.Icons.nav(data)
	local control = PITHKA.UI.Icons.basic(data)

	-- on click change state and refresh
	control:SetHandler("OnMouseUp", function (control, mButton)
		PITHKA.SV.state.currentScreen = data.state
		PITHKA.SV.state.title = data.tt
		PITHKA.UI.Layout.refresh()
		end)

    -- color based on state
	PITHKA.UI.Layout.registerRefreshFn(function()
		local _c = PITHKA.UI.Constants.rgbWhite -- (PITHKA.SV.state.currentScreen == d.state) and PITHKA.UI.Constants.rgbWhite or PITHKA.UI.Constants.rgbGray
		control:SetColor(unpack(_c))
		end)
	
	return control
end