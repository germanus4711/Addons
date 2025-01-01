-- EVTUserInterface.lua
-- 1.13 New user interface, modified from PlunderSkullTimer. Thank you, @code65536!
-- 1.49 Finally fixed UI to vanish for menus, maps, etc! Thanks AGAIN, @code65536! (This time for DungeonTimer)

-- EVT.OnPlayerCombatState (eventCode, inCombat)	Turns the UI off during combat and back on after
-- EVT.OnMoveStop()				Allows the player to move the UI and saves the new location
-- EVT.HideUI(WhatToDo)
-- EVT.ToggleUI()
-- EVT.InitializeUI()
-- EVT.UpdateUI()

function EVT.OnPlayerCombatState(eventCode, inCombat)
	if inCombat then
		EVT.HideUI("Hide")
	else
		EVT.HideUI("Show")
	end
end


function EVT.OnMoveStop()
	EVT.vars.left = EVTFrame:GetLeft()
	EVT.vars.top = EVTFrame:GetTop()
end


-- 1.34 Changed this from StopandHideTimer() to HideUI(WhatToDo)
--      and changed all hide and show occurrences to call functions instead
--      (except initial, where this might not be loaded yet)
--      Also changed hide call from double-click in EventTracker.xml
function EVT.HideUI(WhatToDo)
	if WhatToDo == "Hide" then
-- 1.49 Replaced next line with the two below it.
--		EVTFrame:SetHidden(true)
		SCENE_MANAGER:GetScene("hud"):RemoveFragment(EVT.fragment)
		SCENE_MANAGER:GetScene("hudui"):RemoveFragment(EVT.fragment)
	elseif WhatToDo == "Show" then
-- 1.49 Replaced next line with the two below it.
--		EVTFrame:SetHidden(false)
		SCENE_MANAGER:GetScene("hud"):AddFragment(EVT.fragment)
		SCENE_MANAGER:GetScene("hudui"):AddFragment(EVT.fragment)
	end
end


function EVT.ToggleUI()
	EVT_HIDE_UI = not EVT_HIDE_UI
-- If there's an event going on, or either one's about to start, and it's not an unknown start date, then save the new choice. Otherwise it's temporary.
	if EVT.vars.Current_Event ~= "None" or (EVT_EVENT_START-EVT.FindCurrentTime() < EVT_ONE_DAY*5 and EVT_EVENT_START >= EVT.FindCurrentTime() and EVT_EVENT_START~=EVT_DATE_UNKNOWN) then
		EVT.vars.HideUI = not EVT.vars.HideUI
	end
--	local status = GetString("SI_ADDONLOADSTATE", EVT.vars.HideUI and ADDON_STATE_ENABLED or ADDON_STATE_DISABLED)
--	d("[EVT] Hide User Interface: " .. status)
	if EVT_HIDE_UI then
		EVT.HideUI("Hide")
		EVENT_MANAGER:UnregisterForEvent(EVT.name, EVENT_PLAYER_COMBAT_STATE)
	else
-- 1.28 Refresh UI before re-activating it
		EVT.ShowVars("UI")
		EVT.HideUI("Show")
		EVENT_MANAGER:RegisterForEvent(EVT.name, EVENT_PLAYER_COMBAT_STATE, EVT.OnPlayerCombatState)
	end
end


function EVT.InitializeUI()
	EVTFrame:ClearAnchors()
	EVTFrame:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, EVT.vars.left, EVT.vars.top)

-- 1.33 Make UI hide during windows and dialogues (3 lines)
-- 1.33 Had to be removed because SetHidden didn't work anymore, and I don't know how to make it work with this yet.
--	local fragment = ZO_HUDFadeSceneFragment:New(EVTFrame)
--	HUD_SCENE:AddFragment(fragment)
--	HUD_UI_SCENE:AddFragment(fragment)

	if EVT.vars.T_ToDo[1] < 0 then
		MinTicketsAvail = 0
		MaxTicketsAvail = EVT.vars.T_Tickets[1]
	else
		MinTicketsAvail = EVT.vars.T_Tickets[1] * EVT.vars.T_ToDo[1]
		MaxTicketsAvail = EVT.vars.T_Tickets[1] * EVT.vars.T_ToDo[1]
	end
	if EVT.vars.T_ToDo[2] < 0 then
		MinTicketsAvail = MinTicketsAvail
		MaxTicketsAvail = MaxTicketsAvail + EVT.vars.T_Tickets[2]
	else
		MinTicketsAvail = MinTicketsAvail + EVT.vars.T_Tickets[2] * EVT.vars.T_ToDo[2]
		MaxTicketsAvail = MaxTicketsAvail + EVT.vars.T_Tickets[2] * EVT.vars.T_ToDo[2]
	end

	if EVT.vars.T_ToDo[3] < 0 then
		MinTicketsAvail = MinTicketsAvail
		MaxTicketsAvail = MaxTicketsAvail + EVT.vars.T_Tickets[3]
	else
		MinTicketsAvail = MinTicketsAvail + EVT.vars.T_Tickets[3] * EVT.vars.T_ToDo[3]
		MaxTicketsAvail = MaxTicketsAvail + EVT.vars.T_Tickets[3] * EVT.vars.T_ToDo[3]
	end

-- 1.49 Added two lines
	EVTFrame:GetNamedChild("Icon"):SetTexture("/esoui/art/Currency/currency_eventticket.dds")
	EVT.fragment = ZO_HUDFadeSceneFragment:New(EVTFrame)

	EVT.label = EVTFrame:GetNamedChild("Label")

-- 1.15 Hide UI if nothing known about tickets yet
	if EVT.vars.Total_Tickets < 0 then
		EVT.vars.HideUI = true
		EVT_HIDE_UI = true
	elseif MinTicketsAvail == MaxTicketsAvail and MaxTicketsAvail == 0 then
-- 2.000		EVT.label:SetText(string.format("%s: %s\n\n","Tickets",EVT.vars.Total_Tickets))
		EVT.label:SetText(string.format("%s: %s\n\n",EVT.lang["Tickets"],EVT.vars.Total_Tickets))
	elseif MinTicketsAvail == MaxTicketsAvail then
-- 2.000		EVT.label:SetText(string.format("%s: %s\n%s: %s\n","Tickets",EVT.vars.Total_Tickets,"Available",MaxTicketsAvail))
		EVT.label:SetText(string.format("%s: %s\n%s: %s\n",EVT.lang["Tickets"],EVT.vars.Total_Tickets,EVT.lang["Available"],MaxTicketsAvail))
	else
-- 2.000		EVT.label:SetText(string.format("%s: %s\n%s: %s-%s\n","Tickets",EVT.vars.Total_Tickets,"Available",MinTicketsAvail,MaxTicketsAvail))
		EVT.label:SetText(string.format("%s: %s\n%s: %s-%s\n",EVT.lang["Tickets"],EVT.vars.Total_Tickets,EVT.lang["Available"],MinTicketsAvail,MaxTicketsAvail))
	end

--[[	if EVT.vars.HideUI then
		EVT.PrintDebug("InitializeUI |c00CCFFHide UI: TRUE|r")
	else
		EVT.PrintDebug("InitializeUI |c00CCFFHide UI: FALSE|r")
	end
]]

	if EVT_HIDE_UI then
		EVT.PrintDebug("InitializeUI |c00CCFFHide UI (temp): TRUE|r")
		EVT.HideUI("Hide")
	else
		EVT.HideUI("Show")
--		EVENT_MANAGER:RegisterForEvent(EVT.name, EVENT_PLAYER_COMBAT_STATE, EVT.OnPlayerCombatState)
		EVT.PrintDebug("InitializeUI |c00CCFFHide UI (temp): FALSE|r")
	end
end


-- 1.19 New function
function EVT.UpdateUI()
	local PrevReset, Hrs, Mins, EvtDays, EvtHrs = EVT.DailyReset()
	local Available1 = EVT.vars.T_ToDo[1]*EVT.vars.T_Tickets[1]
	local Available2 = EVT.vars.T_ToDo[2]*EVT.vars.T_Tickets[2]
	local Available3 = EVT.vars.T_ToDo[3]*EVT.vars.T_Tickets[3]

-- 1.30 Had missed setting flag
	if Polling_Active ~= "None" then
		EVENT_MANAGER:UnregisterForUpdate(EVT.name)
		Polling_Active = "None"
	end

--	EVT.PrintDebug("Update UI")
	EVT.ShowNextInfo("Update UI",PrevReset,EvtDays,EvtHrs,Mins,Available1,Available2,Available3)

-- 1.25 Changed to use function
	EVT.SetUpPoll(PrevReset, Hrs, Mins, EvtDays, EvtHrs)
end


function EVT.Notification(title, content, sound)
        local messageParams = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_LARGE_TEXT, sound)
        messageParams:SetCSAType(CENTER_SCREEN_ANNOUNCE_TYPE_DISPLAY_ANNOUNCEMENT)
        messageParams:SetText(string.format("%s: %s", title, content))
        CENTER_SCREEN_ANNOUNCE:AddMessageWithParams(messageParams)
end

