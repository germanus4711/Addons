-- Initialize file
PITHKA         = PITHKA or {}
PITHKA.UI      = PITHKA.UI or {}
PITHKA.UI.Misc = {}

-- spacer (hidden empty label)
function PITHKA.UI.Misc.spacer(data)
	data.w = data.w or PITHKA.UI.Constants.spacer
	local control = WINDOW_MANAGER:CreateControl("$(parent)"..PITHKA.Utils.uid(), PITHKA_GUI, CT_LABEL)
	control:SetDimensions(data.w, PITHKA.UI.Constants.cellHeight)
	control:SetHidden(true)
	return control
end

-- checkBox
function PITHKA.UI.Misc.checkBox(data)
	assert(data.stateVar, 'stateVar required')
	local tOn  = PITHKA.UI.Constants.texture.CHECKON
	local tOff = PITHKA.UI.Constants.texture.CHECKOFF
	data.iconSize = data.iconSize or PITHKA.UI.Constants.iconSize

	local control = WINDOW_MANAGER:CreateControl("$(parent)_Button" .. PITHKA.Utils.uid(), PITHKA_GUI, CT_BUTTON)
	control:SetDimensions(data.iconSize, data.iconSize)
	control:SetState(BSTATE_NORMAL)  
	control:SetMouseOverBlendMode(0)    
	control:SetHidden(false)
	control:SetEnabled(true) 
	control:SetNormalTexture(PITHKA.SV.state[data.stateVar] and tOn or tOff) 
	control:SetMouseOverTexture("esoui/art/buttons/generic_highlight.dds") 
	control:SetHandler("OnClicked", function()
		PITHKA.SV.state[data.stateVar] = not PITHKA.SV.state[data.stateVar] -- flip state
		control:SetNormalTexture(PITHKA.SV.state[data.stateVar] and tOn or tOff) -- update texture
		PITHKA.UI.Layout.refresh() -- refresh on new state
		end)

	if data.v then
		PITHKA.UI.Layout.registerRefreshFn(function()
			control:SetHidden(not data.v())
			end)
	end

	return control
end


-- basic Button
function PITHKA.UI.Misc.button(data)
	assert(data.texture)
	assert(data.clickFn)
	data.is = data.is or PITHKA.UI.Constants.iconSize

	local control = WINDOW_MANAGER:CreateControl("$(parent)_Button" .. PITHKA.Utils.uid(), PITHKA_GUI, CT_BUTTON)
	control:SetDimensions(data.is,data.is) 
	control:SetState(BSTATE_NORMAL)  
	control:SetMouseOverBlendMode(0)    
	control:SetHidden(false)
	control:SetEnabled(true) 
	control:SetNormalTexture(data.texture) 
	control:SetMouseOverTexture("esoui/art/buttons/generic_highlight.dds") 
	control:SetHandler("OnClicked", data.clickFn)
	
	if data.v then
		PITHKA.UI.Layout.registerRefreshFn(function()
			control:SetHidden(not data.v())
			end)
	end
	
	return control
end
  
-- menuButton
function PITHKA.UI.Misc.menuButton(data)
	assert(data.options)
	assert(data.stateVar)
	data.texture = data.texture or "esoui/art/buttons/dropbox_arrow_normal.dds"

	data.clickFn = function(control, button)
		-- d(data.options) -- for debugging
		if button == 2 then
			ClearMenu()
		elseif button == 1 then -- 1=leftclick, 2=rightclick
			ClearMenu()
			for _, option in pairs(data.options) do
				AddMenuItem(option, function() 
					PITHKA.SV.state[data.stateVar] = option 
					PITHKA.UI.Layout.refresh() 
					end)
			end
			ShowMenu(control)
		end
	end
	return PITHKA.UI.Misc.button(data)
end

 