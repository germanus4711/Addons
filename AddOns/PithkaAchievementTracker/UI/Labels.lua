-- Initialize file
PITHKA           = PITHKA or {}
PITHKA.UI        = PITHKA.UI or {}
PITHKA.UI.Labels = {}


------------------------------------------------------------------------------------------------------------------
-- Basic Label  
------------------------------------------------------------------------------------------------------------------

function PITHKA.UI.Labels.basic(data)
	-- text values
	data.w     = data.w     or 150
	data.h     = data.h     or 23
	data.f     = data.f     or PITHKA.UI.Constants.defaultFont -- "$(MEDIUM_FONT)|$(KB_18)|soft-shadow-thin"
	data.c     = data.c     or PITHKA.UI.Constants.rgbWhite 
	data.align = data.align or TEXT_ALIGN_LEFT
	data.vAlign = data.vAlign or TEXT_ALIGN_CENTER

	-- tooltip values
	data.tta = data.tta or BOTTOM -- tooltip anchor
	data.ttf = data.ttf or PITHKA.UI.Constants.tooltipFont
	data.ttc = data.ttc or PITHKA.UI.Constants.hexGold

	-- create control
	local control = WINDOW_MANAGER:CreateControl("$(parent)"..PITHKA.Utils.uid(), PITHKA_GUI, CT_LABEL)
	control:SetDimensions(data.w, data.h)
	control:SetColor(unpack(data.c))
	control:SetHorizontalAlignment(data.align)
	control:SetVerticalAlignment(data.vAlign)
	control:SetText(data.t)
	control:SetFont(data.f)
	
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


-- ------------------------------------------------------------------------------------------------------------------
-- -- Teleport Label 
-- ------------------------------------------------------------------------------------------------------------------

function PITHKA.UI.Labels.teleport(data)
	local control = PITHKA.UI.Labels.basic(data)

	control:SetMouseEnabled(true)
	
	
	----- ORIGINAL
	control:SetHandler("OnMouseEnter", function(control) control:SetColor(unpack(PITHKA.UI.Constants.rgbWhite)) end )
	control:SetHandler("OnMouseExit",  function(control) control:SetColor(unpack(PITHKA.UI.Constants.rgbBlue)) end )
	control:SetHandler("OnMouseUp", function(control, button)
		if button == 2 then
			ClearMenu()
		elseif button == 1 then -- RMB==2, LMB==1
			ClearMenu()
			if data.vQueue then 
				AddMenuItem("Queue Vet", function() 
					ClearGroupFinderSearch()
					d("Queuing Vet "..data.t)
					AddActivityFinderSpecificSearchEntry(data.vQueue)
					StartGroupFinderSearch()
					end)
			end

			if data.nQueue then 
				AddMenuItem("Queue Normal", function()
					ClearGroupFinderSearch() 
					d("Queuing Normal "..data.t)
					AddActivityFinderSpecificSearchEntry(data.nQueue)
					StartGroupFinderSearch()
					end)
			end

			if data.portID then 
				AddMenuItem("Teleport In", function() 
					PITHKA.UI.Layout.toggleWindow()
					d("Porting to "..data.t)
					FastTravelToNode(data.portID)
					end)
			end
			ShowMenu(control)
		end
	end)


	return control
end

------------------------------------------------------------------------------------------------------------------
-- Achievement Label  
------------------------------------------------------------------------------------------------------------------

function PITHKA.UI.Labels.achievement(data)
	-- default color to gray
	data.c = PITHKA.UI.Constants.rgbGray
	local control = PITHKA.UI.Labels.basic(data)

	-- use aid to dynamically color
	if data.a then
		PITHKA.UI.Layout.registerRefreshFn(function()
			control:SetColor(unpack(IsAchievementComplete(data.a) and PITHKA.UI.Constants.rgbWhite or  PITHKA.UI.Constants.rgbGray))
			end)
	end

	return control
end



------------------------------------------------------------------------------------------------------------------
-- Score Label
------------------------------------------------------------------------------------------------------------------

function PITHKA.UI.Labels.score(data)
	assert(data.abbv, 'needs dungeon/trial abbv')
	local name = GetUnitName("player")

	data.t  = '' -- set in refresh func, using string to trigger initialization
	data.tt = '' -- set in refresh func, using string to trigger initialization
	data.ttf = PITHKA.UI.Constants.fixedWidthFont
	local control = PITHKA.UI.Labels.basic(data)

	PITHKA.UI.Layout.registerRefreshFn(function()
		control:SetText(PITHKA.Data.Scores.getBestScoreString(data.abbv))
		control:SetHandler("OnMouseEnter", function(control) 
			ZO_Tooltips_ShowTextTooltip(control, TEXT_ALIGN_LEFT)
			InformationTooltip:AddLine(string.format('|%s%s|r', PITHKA.UI.Constants.hexGold, PITHKA.Data.Scores.getAllScoresString(data.abbv)), data.ttf)
			end) 
		end)
	return control
end


------------------------------------------------------------------------------------------------------------------
-- Watermark Label  
------------------------------------------------------------------------------------------------------------------

-- wrapped label with watermark defaults, also embeds anchor
function PITHKA.UI.Labels.watermark(data)
	-- standard label values
	data.w   = data.w     or 1000
	data.f   = data.f      or 'ZoFontCenterScreenAnnounceLarge'
	data.c   = data.c     or {197/225, 194/225, 158/225, .15}
	data.align  = data.align or TEXT_ALIGN_CENTER

	-- watermark specific values
	data.scale = data.scale or 3
	data.vOffset = data.vOffset   or 0
	local control = PITHKA.UI.Labels.basic(data)
	control:SetScale(data.scale)
	control:SetAnchor(CENTER, PITHKA_GUI, CENTER, 0, data.vOffset)
	return control
end


------------------------------------------------------------------------------------------------------------------
-- State Based Label  
------------------------------------------------------------------------------------------------------------------
function PITHKA.UI.Labels.stateBased(data)
	assert(data.textFnLibrary) -- assumes text and tt are dynamic and expects functions
	assert(data.stateVar)
	
	data.f   = PITHKA.UI.Constants.boldFont -- change default font since this is only used for summary text
	data.tt  = '' -- use empty string to intialize (value set in refresh)
	data.tta = data.tta or LEFT
	data.ttc = data.ttc or PITHKA.UI.Constants.hexGold
	data.ttf = data.ttf or PITHKA.UI.Constants.fixedWidthFont

	local control = PITHKA.UI.Labels.basic(data)
	PITHKA.UI.Layout.registerRefreshFn(function()
		-- use stateVar to lookup in textLibrary
		local state = PITHKA.SV.state[data.stateVar]

		assert(data.textFnLibrary[state], 'stateVar value not in textFnLibrary')

		local tFn  = data.textFnLibrary[state].text
		local ttFn = data.textFnLibrary[state].tt
		control:SetText(tFn())
		control:SetHandler("OnMouseEnter", function(control) 

		-- create tooltip if one exists
		if ttFn() then 
			ZO_Tooltips_ShowTextTooltip(control, data.tta)
			InformationTooltip:AddLine(string.format('|%s%s|r', data.ttc, ttFn()), data.ttf)
		end
		end) 
		
		-- custom font for ESO Runs, check conditionally if font is defined in textFnLibrary
		local tFont = data.textFnLibrary[state].tFont or data.f
		control:SetFont(tFont)

		-- set clickable link if guild id exists
		local guildIdFn = data.textFnLibrary[state].guildId
		if guildIdFn then
			control:SetHandler("OnMouseUp", function(control, button)
				ZO_LinkHandler_OnLinkMouseUp("|H1:guild:" .. guildIdFn() .. "|hTEST LINK|h", MOUSE_BUTTON_INDEX_LEFT)
			end)
		else
			control:SetHandler("OnMouseUp", nil)
		end
	end)
	return control
end