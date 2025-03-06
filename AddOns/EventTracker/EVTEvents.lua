-- EVTEvents.lua
local EventIdentified = "Unknown"
local BoxType = "Unknown"
local EventType = "Unknown"
local MostRecentBox = 0
local TicketsReceived = 0
local QuestType = "Unknown"

--[[*****************************************************
*****
*****   MUST BE CERTAIN THAT CURRENT EVENT is NOT!! "None"
*****   when DailyReset is called
*****   from StartNewEvent or Recursion could result!!!
*****
*********************************************************]]

----------------------------------------
-- StartNewEvent
----------------------------------------
function EVT.StartNewEvent()
	local SavePoll = EVT_POLLING_ACTIVE
	EVT.PrintDebug("Start new event!")

	if EVT_POLLING_ACTIVE == "Start New Event" then
		EVENT_MANAGER:UnregisterForUpdate(EVT.name)
-- 1.31 Changed to use a local variable for polling flag so the real one can be reset immediately
		EVT_POLLING_ACTIVE = "None"
	end

	if EVT.FindCurrentTime() >= EVT_EVENT_START and EVT.FindCurrentTime() < EVT_EVENT_END and EVT.vars.Current_Event == "None" then
		if not EVT.vars.HideUI then
			EVT_HIDE_UI = false
		end

		if SavePoll == "Start New Event" then
			if EVT_NEXT_EVENT == "New Life" then
				CHAT_ROUTER:AddSystemMessage("[EVT]: |c00CCFFHAPPY NEW LIFE!!|r Event starts NOW!!")
-- Big center screen message doesn't work yet - I'd really love to figure out how to make it work!
--				CENTER_SCREEN_ANNOUNCE:DisplayMessage("|c00CCFFHAPPY NEW LIFE!!|r Event starts NOW!!")
			else
				CHAT_ROUTER:AddSystemMessage("[EVT]: |c00CCFF" .. EVT_NEXT_EVENT .. " EVENT STARTS NOW!!|r")
			end
		else
			CHAT_ROUTER:AddSystemMessage("[EVT]: Setting up Event Tracker for |c00CCFF" .. EVT_NEXT_EVENT .. ".|r")
		end

		EVT.ClearData()
		EVT.vars.T_Types[1] = EVT_EVENT_DETAILS["T_Types_1"]
		EVT.vars.T_Types[2] = EVT_EVENT_DETAILS["T_Types_2"]
		EVT.vars.T_Tickets = EVT_EVENT_DETAILS["T_Tickets"]
		EVT.vars.T_ToDo = EVT_EVENT_DETAILS["T_ToDo"]
		EVT.vars.T_Time   = {EVT.FindCurrentTime(),EVT.FindCurrentTime(),0,}

-- *************************************************************************************************
-- *****  RECURSION PREVENTION - This line prevents recursion when DailyReset is called below  *****
		EVT.vars.Current_Event = EVT_NEXT_EVENT
-- *************************************************************************************************


-- 1.19 Added this because UI needs to be completely reset, and a few extra chat messages shouldn't hurt.
-- 1.30 Only if it got here by poll. If not, it's in initialization, and ShowVars will be called there.
		if SavePoll == "Start New Event" then
			EVT.ShowVars("Signon")
		end

-- *************************************************************************************************
-- *****  RECURSION PREVENTION - Make sure CurrentEvent is not "None" when DailyReset is called!  *****
-- 1.30 DailyReset calls SetUpPoll at the end if EVT_POLLING_ACTIVE is "None", so no need to call SetUpPoll (which is the only reason I called DailyReset)
		local PrevReset, Hrs, Mins, EvtDays, EvtHrs = EVT.DailyReset()
-- *************************************************************************************************

-- If somehow timing is a little off, try again 10 seconds after it should start.
	elseif EVT.FindCurrentTime() < EVT_EVENT_START and EVT.vars.Current_Event == "None" and SavePoll == "Start New Event" then
		EVENT_MANAGER:RegisterForUpdate(EVT.name, (EVT_EVENT_START-EVT.FindCurrentTime())*1000+10000, EVT.StartNewEvent)
		EVT_POLLING_ACTIVE = "Start New Event"
		SavePoll = "Start New Event"

-- *************************************************************************************************
-- *****  RECURSION PREVENTION: CurrentEvent MUST NOT be "None" when DailyReset is called! Prevented by this "elseif"  *****
	elseif EVT.FindCurrentTime() > EVT_EVENT_START and EVT.vars.Current_Event == "Unknown" then
-- *************************************************************************************************

-- *************************************************************************************************
-- *****  RECURSION PREVENTION: CurrentEvent MUST NOT be "None" when DailyReset is called! Prevented by "elseif" above.  *****
		local PrevReset, Hrs, Mins, EvtDays, EvtHrs = EVT.DailyReset()
-- *************************************************************************************************


-- Find any valid data; tickets that have been picked up since last reset.
		local TempTime1 = 0
		local TempTodo1 = 1
		local TempTickets1 = 0
		local TempTime2 = 0
		local TempTodo2 = 0
		local TempTickets2 = 0

		if EVT.vars.T_Time[1] > PrevReset then
			TempTime1 = EVT.vars.T_Time[1]
			TempTodo1 = EVT.vars.T_ToDo[1]
			TempTickets1 = EVT.vars.T_Tickets[1]
		end
		if EVT.vars.T_Time[2] > PrevReset then
			if TempTime1 == 0 then
				TempTime1 = EVT.vars.T_Time[2]
				TempTodo1 = EVT.vars.T_ToDo[2]
				TempTickets1 = EVT.vars.T_Tickets[2]
			else
				TempTime2 = EVT.vars.T_Time[2]
				TempTodo2 = EVT.vars.T_ToDo[2]
				TempTickets2 = EVT.vars.T_Tickets[2]
			end
		end
		if EVT.vars.T_Time[3] > PrevReset then
			if TempTime1 == 0 then
				TempTime1 = EVT.vars.T_Time[3]
				TempTodo1 = EVT.vars.T_ToDo[3]
				TempTickets1 = EVT.vars.T_Tickets[3]
			else
				TempTime2 = EVT.vars.T_Time[3]
				TempTodo2 = EVT.vars.T_ToDo[3]
				TempTickets2 = EVT.vars.T_Tickets[3]
			end
		end

		EVT.ClearData()
		EVT.vars.DataCleared = nil
		EVT.vars.Current_Event = EVT_NEXT_EVENT

		EVT.vars.T_Types[1] = EVT_NEXT_EVENT
		EVT.vars.T_Time[1] = TempTime1
		EVT.vars.T_ToDo[1] = TempTodo1
		EVT.vars.T_Tickets[1] = TempTickets1

-- 1.30 Only if it got here by poll. If not, it's in initialization, and ShowVars will be called there.
		if SavePoll ~= "None" then
			EVT.ShowVars("Signon")
		end
	end
end


----------------------------------------
-- SetTicketTime
-- 1.07 Calls an event-specific function that
-- sets the time an event ticket was acquired to current time,
-- and updates ticket availability flag.
----------------------------------------
function EVT.SetTicketTime(NewTickets,OldTickets,TicketReason)

-- 1.65 TicketReason had never actually been used, but options for it were "Loot" or "Quest"
-- Now adding "Missed" so I can call this if a Dremora/plunder skull has been observed with no tickets
-- to register that tickets had been missed.

-- 1.47 Simplify code
	local which_ticket = 0
	local plural_message = "[EVT]: |cFF00CC%s %s tickets collected!|r"
	local single_message = "[EVT]: |cFF00CC%s %s ticket collected!|r"

	if TicketReason == "Missed" then
		plural_message = "[EVT]: |cFFFFFF%s %s tickets previously missed today. Corrected now.|r"
		single_message = "[EVT]: |cFFFFFF%s %s ticket previously missed today. Corrected now.|r"
	end

-- 1.94 Removed old "or Year One", fixed logic of statement below it to specify different event than Mayhem, which could be easily re-activated for another event that includes IC, like Year One.
	if EVT.vars.Current_Event == "Whitestrake's Mayhem" then
--		if QuestType == "Imperial City" or ( EVT.vars.Current_Event ~= "Whitestrake's Mayhem" and EVT.Ticket_Location() == "Imperial City") then
		if QuestType == "Imperial City" then
			which_ticket = 2
		else
			which_ticket = 1
		end

-- 1.65 Ticket processing & messages moved to end
--		EVT.Quest_Tickets(EVT.vars.Current_Event, NewTickets - OldTickets)

-- ******************************************
-- EVENTUPDATE SPECIAL EVENT PROCESSING GOES HERE
-- ******************************************
--[[ 1.81 Skyrim
	elseif EVT.vars.Current_Event == "Skyrim" then
		if EVT.Ticket_Location() == "Markarth" then
			which_ticket = 2
		else
			which_ticket = 1
		end
]]

-- None: Between events
-- 1.18 If tickets hit cap between events, can't guess how many were received, so can't set up new Unknown
	elseif EVT.vars.Current_Event == "None" and NewTickets < 12 then
		EVT.UnknownEvent(NewTickets,OldTickets)
-- Unknown
	elseif EVT.vars.Current_Event == "Unknown" then
		EVT.UnknownEvent(NewTickets,OldTickets)

-- 1.38 Changed elseif to just else, because this has been fairly standard for so many events lately.
-- and moved to end after "Unknown" and "none"
	else
-- 1.65 Ticket processing & messages moved to end
		which_ticket = 1
	end

-- 1.65 Moved ticket processing and message here, so the code isn't repeated so many times
	if which_ticket > 0 then
		if EVT.vars.T_Tickets[which_ticket]>1 then
			CHAT_ROUTER:AddSystemMessage(string.format("[EVT]: |cFF00CC%s %s tickets collected!|r",EVT.vars.T_Tickets[which_ticket],EVT.vars.T_Types[which_ticket]))
		else
			CHAT_ROUTER:AddSystemMessage(string.format("[EVT]: |cFF00CC%s %s ticket collected!|r",EVT.vars.T_Tickets[which_ticket],EVT.vars.T_Types[which_ticket]))
		end
		EVT.vars.T_Time[which_ticket] = EVT.FindCurrentTime()
		EVT.vars.T_ToDo[which_ticket] = 0
	end

-- Box identification test
	if MostRecentBox == EVT.FindCurrentTime() then
		EVT.PrintDebug("TICKETS RECEIVED! Loot box: " .. BoxType .. ". Event: " .. EventIdentified)
	end

-- 1.42 Force saving variables (this should force a save without reloading or signing off, within 5-10 minutes)
--[[	if NewTickets > OldTickets then
		RequestAddOnSavedVariablesPrioritySave("EventTracker")
	end
]]
end


function EVT.OnLootReceived( eventCode, receivedBy, itemName, quantity, itemSound, lootType, self, isPickpocketLoot, questItemIcon, itemID )
	local EventLootBoxes = {
-- 1.80 Info from RewardsTracker addon, ContainerDataProvider
--		[188134] = "Dreadsail Reef",	-- Taleria's Sundry Treasure
--		[188139] = "Dreadsail Reef",	-- Taleria's Glistening Treasure

-- 2021 http://esolog.uesp.net/viewlog.php?search=dremora+plunder&searchtype=minedItemSummary32pts
--		[178686] = "Plunder Skull",	-- purple plunder skull
--		[178687] = "Arena",		-- Dremora Plunder Skull, Arena
--		[178688] = "Insurgent",	-- Dremora Plunder Skull, Insurgent (dolmen/geyser/dragon/harrowstorm/deadlands)
--		[178689] = "Delve",		-- Dremora Plunder Skull, Delve
--		[178690] = "Dungeon",	-- Dremora Plunder Skull, Group Dungeon
--		[178691] = "Sweeper",	-- Dremora Plunder Skull, Public & Sweeper (inc. daedric incursions)
--		[178692] = "Trial",		-- Dremora Plunder Skull, Trial
--		[178693] = "World",		-- Dremora Plunder Skull, World Boss

-- 2022 http://esolog.uesp.net/viewlog.php?search=dremora+plunder&searchtype=minedItemSummary35pts
--		[190037] = "Plunder Skull",	-- purple plunder skull
--		[190013] = "Arena",		-- Dremora Plunder Skull, Arena
--		[190014] = "Insurgent",	-- Dremora Plunder Skull, Incursions (note name change)
-- (dolmen/geyser/dragon/harrowstorm/deadlands/volcanic vents)
--		[190015] = "Delve",		-- Dremora Plunder Skull, Delve
--		[190016] = "Dungeon",	-- Dremora Plunder Skull, Group Dungeon
--		[190017] = "Sweeper",	-- Dremora Plunder Skull, Public & Sweeper (inc. daedric incursions)
--		[190018] = "Trial",		-- Dremora Plunder Skull, Trial
--		[190019] = "World",		-- Dremora Plunder Skull, World Boss
--		[190038] = "Crowborne",	-- Dremora Plunder Skull, Crowborne Horror

-- 3 tickets for eating Cake (counts as monster body looting; no other drop)
--		[134797] = "Anniversary", -- Anniversary Jubilee Gift Box (Tickets were not given with Anniversary boxes; but with eating cake)

-- 3 tickets for a Jester's daily (with Stupendous box drop)
--		[147477] = "Jester's Festival", -- Jester's Festival Box (fine) (2)
--		[147637] = "Jester's Festival", -- Stupendous Jester's Festival Box (superior) (1)

-- 1.64 Changed to Whitestrake's
--		[121526] = "Whitestrake's Mayhem", -- Pelinal's Midyear Boon Box - There are quests that give boxes that don't give tickets.

--		[156779] = "New Life", -- New Life Festival Box (9)

--		[133559] = "Clockwork City Crows", -- Crow-Touched Clockwork Coffer (10, but one shows no tickets - A Matter of Leisure, Toys and Games)
--		[133560] = "Clockwork City Slag", -- Slag Town Coffer (10)

-- "Crime Pays"
--		[94085] = "Dark Brotherhood", -- Unidentified Sithis' Touch Equipment (superior) (1)
--		[94086] = "Dark Brotherhood", -- Unidentified Sithis' Touch Equipment (fine) (2)
--		[74651] = "Thieves Guild", -- Satchel of Laundered Goods (superior) (4)
--		[119561] = "Thieves Guild", -- Professional Thief's Satchel of Laundered Goods (epic) (4)

--		[126032] = "Morrowind world boss", -- Hall of Justice Bounty Dispensation (6)
--		[126033] = "Morrowind delve", -- Hall of Justice Explorer's Dispensation (6)

--		[126030] = "Morrowind Ashlander",	-- Huntsman's Recognition (Huntmaster Sorim-Nakar, Ald'ruhn)
--		[126031] = "Morrowind Ashlander",	-- Gift of Urshilaku Gratitude (Numani-Rasi, Ald'ruhn)

--		[156680] = "Murkmire", -- Murkmire Strongbox (1) (January 2020 event)

-- Summerset, first appeared PTS May 2020
--		[138800] = "Summerset", -- Summerset Daily Recompense (blue)
--		[165972] = "Summerset", -- Glorious Summerset Coffer (gold)

--		[156679] = "Undaunted", -- Undaunted Reward Box (1) (this is a mined item that doesn't show up as being received with tickets)
--		[156717] = "Undaunted", -- Hefty Undaunted Reward Box (1) (this is a mined item that doesn't show up as being received with tickets)

-- 1.57		[167235] = "Arena",		-- Dremora Plunder Skull, Arena
-- 1.57		[167236] = "Insurgent",	-- Dremora Plunder Skull, Insurgent (dolmen/geyser/dragon/harrowstorm)
-- 1.57		[167237] = "Delve",		-- Dremora Plunder Skull, Delve
-- 1.57		[167238] = "Dungeon",	-- Dremora Plunder Skull, Group Dungeon
-- 1.57		[167239] = "Sweeper",	-- Dremora Plunder Skull, Public & Sweeper (inc. daedric incursions)
-- 1.57		[167240] = "Trial",		-- Dremora Plunder Skull, Trial
-- 1.57		[167241] = "World",		-- Dremora Plunder Skull, World Boss

--		[74679] = "Wrothgar delve", -- Wrothgar Daily Contract Recompense (6)
--		[74680] = "Wrothgar world boss", -- Wrothgar Daily Contract Recompense (6)

--		[5389] = "Daily Crafting", -- (Daily Crafting - Clothing)
--		[5392] = "Daily Crafting", -- (Daily Crafting - Smithing)
--		[5407] = "Daily Crafting", -- Enchanter Writ
--		[5413] = "Daily Crafting", -- Provisioner Writ
--		[6105] = "Daily Crafting", -- Alchemist Writ
--		[6218] = "Daily Crafting", -- Jewelry Crafting Writ
	}
	local IdentifyEvent = {
--[[		["Plunder Skull"] = "Witches Festival",	-- purple plunder skull
		["Arena"] = "Witches Festival",
		["Insurgent"] = "Witches Festival",	-- (dolmen/geyser/dragon/harrowstorm)
		["Delve"] = "Witches Festival",
		["Dungeon"] = "Witches Festival",	-- Group Dungeon
		["Sweeper"] = "Witches Festival",	-- Public Dungeon/Daedric Incursion (sweeper)
		["Trial"] = "Witches Festival",
		["World"] = "Witches Festival",	-- World Boss
]]
--[[		["Anniversary"] = "Anniversary",

-- 1.64 Changed to Whitestrake's
		["Whitestrake's Mayhem"] = "Whitestrake's Mayhem",

		["Jester's Festival"] = "Jester's Festival",
		["Jester's Festival"] = "Jester's Festival",

		["New Life"] = "New Life",

		["Undaunted"] = "Undaunted",
		["Undaunted"] = "Undaunted",
]]

--[[		["Clockwork City Crows"] = "Clockwork City",
		["Clockwork City Slag"] = "Clockwork City",

		["Dark Brotherhood"] = "Crime Pays",
		["Thieves Guild"] = "Crime Pays",

		["Morrowind world boss"] = "Morrowind",
		["Morrowind delve"] = "Morrowind",
		["Morrowind Ashlander"] = "Morrowind",

		["Murkmire"] = "Murkmire",

		["Summerset"] = "Summerset",

		["Wrothgar delve"] = "Wrothgar",
		["Wrothgar world boss"] = "Wrothgar",
]]

	}
	local IdentifyEventType = {
--[[		["Plunder Skull"] = "Seasonal",	-- purple plunder skull
		["Arena"] = "Seasonal",
		["Insurgent"] = "Seasonal",	-- (dolmen/geyser/dragon/harrowstorm)
		["Delve"] = "Seasonal",
		["Dungeon"] = "Seasonal",	-- Group Dungeon
		["Sweeper"] = "Seasonal",	-- Public Dungeon/Daedric Incursion (sweeper)
		["Trial"] = "Seasonal",
		["World"] = "Seasonal",	-- World Boss
]]
--[[
		["Anniversary"] = "Seasonal",

		["Jester's Festival"] = "Seasonal",
		["Jester's Festival"] = "Seasonal",

-- 1.64 Changed to Whitestrake's
		["Whitestrake's Mayhem"] = "Daily Reward",

		["New Life"] = "Seasonal",
]]
--[[
		["Clockwork City Crows"] = "Daily Reward",
		["Clockwork City Slag"] = "Daily Reward",

-- "Crime Pays"
		["Dark Brotherhood"] = "Daily Reward",
		["Thieves Guild"] = "Daily Reward",

		["Morrowind world boss"] = "Daily Reward",
		["Morrowind delve"] = "Daily Reward",
		["Morrowind Ashlander"] = "Daily Reward",

		["Murkmire"] = "Seasonal",

		["Summerset"] = "Daily Reward",

		["Undaunted"] = "Seasonal",
		["Undaunted"] = "Seasonal",

		["Wrothgar delve"] = "Daily Reward",
		["Wrothgar world boss"] = "Daily Reward",
]]
	}

--[[ This would ignore loot from group members. But why? That can give clues too.
	if not self then
		return
	end
]]

-- 1.27 Moved this out of "if" to be able to see Murkmire box details,
--      then de-activated because I don't need it anymore. Added Murkmire to data.
--	EVT.PrintDebug(string.format("|c00ccffItem ID & name: %s %s|r",itemID,itemName))
	if EventLootBoxes[itemID] ~= nil then   -- No items we care about, but if not eliminated this way, might trigger an error
-- 1.42 Dremora skulls
		if EVT.vars.Current_Event == "Witches" and self then
			BoxType = EventLootBoxes[itemID]
			EVT.PrintDebug("|c00CCFFSKULL IDENTIFIED! " .. BoxType .. ". Received by " .. receivedBy)

-- 1.65 Added skulls for Witches
			if BoxType ~= "Plunder Skull" then
				EVT.vars.Skulls_Done[BoxType] = true
			end

		elseif EVT.vars.Current_Event == "Witches" then
			BoxType = EventLootBoxes[itemID]
			EVT.PrintDebug("|cFFFF00PARTY SKULL IDENTIFIED! " .. BoxType .. ". Received by " .. receivedBy)

		elseif EVT.vars.Current_Event == "None" then

			BoxType = EventLootBoxes[itemID]
			EventIdentified = IdentifyEvent[BoxType]
			EventType = IdentifyEventType[BoxType]
			MostRecentBox = EVT.FindCurrentTime()
			EVT_NEXT_EVENT = EventIdentified
			EVT.PrintDebug(EventType .. " loot box " .. BoxType .. ". Event: " .. EventIdentified .. ". Received by " .. receivedBy)

-- 1.34 Turn off loot box recognition trigger
			if EVT_NEXT_EVENT ~= "Witches" then
				EVENT_MANAGER:UnregisterForEvent(EVT.name, EVENT_LOOT_RECEIVED)
			end
-- 1.34 Set EVT_NEXT_EVENT (above), then start new event
			EVT.StartNewEvent()

		end

	else
		if itemID ~= nil then
			EVT.PrintDebug(string.format("|cff0000UNKNOWN|r BOX: |c00ccffItem ID: %s|r",itemID))
		end
		if itemName ~= nil then
			EVT.PrintDebug(string.format("|c00ccffItem Name: %s|r",itemName))
		end

		BoxType = "Unknown"
		EventIdentified = "Unknown"
		EventType = "Unknown"
		MostRecentBox = 0

	end
end


-- 1.13 Changed to use QuestID because I realized name might not work for other languages.
-- 2.240 Disabled the call for this from the end of Init, as it seems to only apply to Ache for Cake anyway.
-- Revisit this for Anniversary (if I remember)
function EVT.FindQuest(eventCode, isCompleted, journalIndex, questName, zoneIndex, poiIndex, questID)
	local TicketQuestTypes = {

-- ******************************************
-- EVENTUPDATE FINDQUEST TICKET QUEST TYPES
-- ******************************************

-- 2.291 This section of code was somehow MISSING, causing IC tickets to not be recognized. Restored from version 2.220
-- 1.93 Re-activated (2.050 - left this active, since this'll be needed again soon)
--(All alliances)
		[5491] = "Imperial City", -- #1698 "Speaking For The Dead"		(Memorial District, Legate Gallus)
		[5492] = "Imperial City", -- #2655 "The Lifeblood of an Empire"	(Arena District, Valga Atrius)
		[5495] = "Imperial City", -- #2622 "Priceless Treasures"		(Temple District, Sister J'Reeza)
		[5498] = "Imperial City", -- #2620 "Historical Accuracy"		(Arboretum, Loncano)
		[5500] = "Imperial City", -- #3051 "Dousing the Fires of Industry"	(Elven Gardens, Quintia Rullus)
		[5501] = "Imperial City", -- #2621 "Watch Your Step"		(Nobles District, Brihana)

-- 2.050 Re-activated New Life
		[5838] = "New Life", -- Mud Ball Merriment
		[5855] = "New Life", -- Fish Boon Feast
		[5856] = "New Life", -- Stonetooth Bash
		[5845] = "New Life", -- Castle Charm Challenge
		[5837] = "New Life", -- Lava Foot Stomp
		[5811] = "New Life", -- Snow Bear Plunge
		[5834] = "New Life", -- The Trial of Five-Clawed Guile
		[5839] = "New Life", -- Signal Fire Sprint
		[5852] = "New Life", -- War Orphan's Sojourn
		[6588] = "New Life", -- Old Life Observance

-- 2.060 Re-added Jester's Festival for PTS
		[5937] = "Jester's Festival", -- Royal Revelry (Emeric)
		[5921] = "Jester's Festival", -- Springtime Flair (Ayrenn)
		[5931] = "Jester's Festival", -- A Noble Guest (Jorunn)
		[6622] = "Jester's Festival", -- A Foe Most Porcine (to Hammerdeath)
		[6632] = "Jester's Festival", -- The King's Spoils (mudapple quest at Hammerdeath)
		[6640] = "Jester's Festival", -- Prankster's Carnival (Klumbert in Skywatch)


-- 1.97 Anniversary
		[6370] = "Anniversary", -- Ache for Cake (does not give tickets, but needed to trigger cake)

--[[		[5389] = "Daily Crafting", -- (Daily Crafting - Clothing)
		[5392] = "Daily Crafting", -- (Daily Crafting - Smithing)
		[5396] = "Daily Crafting", -- Woodworker Writ
		[5407] = "Daily Crafting", -- Enchanter Writ
		[5413] = "Daily Crafting", -- Provisioner Writ
		[6105] = "Daily Crafting", -- Alchemist Writ
		[6218] = "Daily Crafting", -- Jewelry Crafting Writ
]]

	}
	EVT.PrintDebug(string.format("|c00ccffQuest ID & name: %s %s|r",questID,questName))

-- ******************************************
-- GUILDS & GLORY SPECIAL 1
-- ******************************************
--[[ 2.060 Imperial City quests - setting this only for G&G because Mayhem will be the next event
	if EVT.vars.Current_Event == "Guilds & Glory" then
		TicketQuestTypes[5491] = "Guilds & Glory"
		TicketQuestTypes[5492] = "Guilds & Glory"
		TicketQuestTypes[5495] = "Guilds & Glory"
		TicketQuestTypes[5498] = "Guilds & Glory"
		TicketQuestTypes[5500] = "Guilds & Glory"
		TicketQuestTypes[5501] = "Guilds & Glory"
	end
]]
	if (isCompleted) then
		if TicketQuestTypes[questID] == nil then   -- A quest we don't care about, but if not eliminated this way, might trigger an error
			EVT.PrintDebug("Quest type unknown.")
			QuestType = "Unknown"
		else
			QuestType = TicketQuestTypes[questID]
--			MostRecentQuest = GetTimeStamp()
			EVT.PrintDebug("Quest type identified as " .. QuestType)

-- 1.97 Spawn the newly unlocked anniversary cake to get tickets, if it won't go over cap. This could destroy a Mayhem buff. I don't care enough.
			if EVT.vars.Current_Event == "Anniversary" and QuestType == "Anniversary" then
				local MaxToday, MaxTomorrow = EVT.MaxAvailable()
				if EVT.vars.Total_Tickets + MaxToday <= 12 then
					EVT.PlayMemento(mementoID)
				end
			end

--[[			if EVT.vars.T_Time[QuestType] ~= nil and EVT.vars.T_ToDo[QuestType] ~= nil then
				EVT.PrintDebug(QuestType .. " tickets done for the day because of quest.")
				EVT.vars.T_Time[QuestType] = GetTimeStamp()
				EVT.vars.T_ToDo[QuestType] = 0
			else
				if EVT.vars.T_Time[QuestType] == nil then
					EVT.PrintDebug("|cff0000" .. QuestType .. " identified, but tickets not reset because TIME is missing.|r")
				end
				if EVT.vars.T_ToDo[QuestType] == nil then
					EVT.PrintDebug("|cff0000" .. QuestType .. " identified, but tickets not reset because TO DO is missing.|r")
				end
			end
]]
		end
	end
end


-- 1.66 New function added for SAFETY NET, but not used yet.
-- 1.67 EVT_PENDING_QUEST_TICKETS = {0,0,0,0,}
-- 1.67 More functionality should be added to this, later: EVT_QUEST_TICKETS
--      Has a current completed event been found with no tickets, and tickets are still showing as available? (If so, tickets might have been missed.)
--      NOTE: It's is actually MUCH more complex that this, because of multiple tickets on some events.
--      Have tickets been found on a quest other than a current event? (If so, then an update is needed, or something's wrong.)
function EVT.QuestTickets()

	EVT_QUEST_TICKETS = {
-- ******************************************
-- EVENTUPDATE QUESTTICKETS QUEST TICKETS
-- ******************************************
-- 2.240 West Weald
		["Commandant Salerius"]  = 0,	-- 6 West Weald delve quests
		["Lieutenant Agrance"]  = 0,	-- 6 West Weald world boss quests
		["Lieutenant Jaida"]  = 0,	-- 2 West Weald Mirrormoor quests
		["Keshargo"]  = 0,	-- West Weald Lucent Citadel trial weekly quest
		["Gandrinar"]  = 0,	-- Special event daily questgiver

-- 2.240 Bretons - High Isle
		["Wayllod"]		= 0,	-- 6 High Isle delve quests
		["Parisse Plouff"]		= 0,	-- 6 High Isle world boss dailies
		["Druid Peeska"]		= 0,	-- 2 High Isle Volcanic Vent dailies
		["Admiral Galvendier"]	= 0,	-- Dreadsail Reef trial weekly quest
		["Kishka"]	= 0,	-- NPC Tribute daily quest
		["Marunji"]	= 0,	-- PvP Tribute daily quest

-- 2.240 Bretons - Galen
		["Juline Courcelles"]		= 0,	-- 6 Galen delve quests
		["Druid Gastoc"]		= 0,	-- 6 Galen world boss dailies
		["Druid Aishabeh"]		= 0,	-- 2 Galen Volcanic Vent dailies

-- 1.98 Zeal of Zenithar
		["Fasaria"]		= 0,

-- 2.050 For New Life, activators are "Breda", and "Petronius Galenus" for Old Life quest.
		["Breda"]			= 0,	-- New Life (9 "New Life" daily quests, plus starter quest that doesn't give tickets)
		["Petronius Galenus"]	= 0,	-- New Life (1 "Old Life" daily quest)

-- 1.80 seasonally de-activated
-- 1.71 Whitestrake's Mayhem
		["Legate Gallus"]		= 0,	-- "Speaking For The Dead", Memorial District, IC
		["Valga Atrius"]		= 0,	-- "The Lifeblood of an Empire", Arena
		["Loncano"]		= 0,	-- "Historical Accuracy", Arboretum (questgiver name not checked)
		["Brihana"]		= 0,	-- "Watch Your Step", Nobles
		["Quintia Rullus"]		= 0,	-- "Dousing the Fires of Industry", Elven Gardens
		["Sister J'Reeza"]		= 0,	-- "Priceless Treasures", Temple

		["Hjorik"]		= 0,	-- Bruma (5)
		["Grigerda"]		= 0,	-- Bruma (5)
		["Vyctoria Girien"]		= 0,	-- Cheydinhal (5)
		["Sylvian Herius"]		= 0,	-- Cheydinhal (5)
		["Lliae the Quick"]		= 0,	-- Chorrol (5)
		["Mael"]			= 0,	-- Weynan Priory (5)
		["Prefect Antias"]		= 0,	-- Cropsford (4)
		["Ufgra gra-Gum"]		= 0,	-- Cropsford (5)
		["Nelerien"]		= 0,	-- Vlastarus (5)
		["Jurana"]		= 0,	-- Vlastarus (4)

		["FIGHTER'S GUILD BOUNTY"]	= 0,	-- Fighter's Guild bounty quests (This is a special category - see code)
		["Sebazi"]		= 0,	-- AD bounty quests
		["Arkas"]			= 0,	-- DC bounty quests
		["Ikran"]			= 0,	-- EP bounty quests

		["Conquest Mission Board"]	= 0,	-- All alliances
		["Scouting Mission Board"]	= 0,	-- All alliances (non-sharable scouting quests, 500 AP)
		["Bounty Mission Board"]	= 0,	-- All alliances (kill 20 enemy players)
		["Battle Mission Board"]	= 0,	-- All alliances (capture a resource)
		["Warfront Mission Board"]	= 0,	-- All alliances (capture a keep, 3k AP)

		["SCROLL QUEST"]		= 0,	-- Scroll capture quests (This is a special category - see code)
		["Grand Warlord Sorcalin"]	= 0,	-- AD scroll capture quests
		["Grand Warlord Dortene"]	= 0,	-- DC scroll capture quests
		["Grand Warlord Zimmeron"]	= 0,	-- EP scroll capture quests


-- Jester's Festival
		["Jester King Emeric"]	= 0,	-- "Royal Revelry"
		["Jester Queen Ayrenn"]	= 0,	-- "Springtime Flair"
		["Jester King Jorunn"]	= 0,	-- "A Noble Guest"
		["Rozette the Rapscallion"]	= 0,	-- "A Foe Most Porcine"
		["Jad'zirri"]		= 0,	-- "The King's Spoils"
		["Soars-in-Laughter"]	= 0,	-- "Prankster's Carnival"
		["Samuel Gourone"]		= 0,	-- "Getting the Band Together"

	}

	local EventQuestGiver = "None"
	local EventQuestNames = {
-- ******************************************
-- EVENTUPDATE QUESTTICKETS QUEST NAMES
-- ******************************************
-- 2.240 West Weald
		["Venom Hunt"]	= "Commandant Salerius",	-- Delve
		["Loan Recall"]	= "Commandant Salerius",	-- Delve
		["Trinkets from the Reach"]	= "Commandant Salerius",	-- Delve
		["A Calamitous Error"]	= "Commandant Salerius",	-- Delve
		["A Study in Tharriker"]	= "Commandant Salerius",	-- Delve
		["Ruinous Evaluation"]	= "Commandant Salerius",	-- Delve

		["Spinning Out"]	= "Lieutenant Agrance",	-- World Boss
		["Fate-Eater"]	= "Lieutenant Agrance",	-- World Boss
		["Training Camp"]	= "Lieutenant Agrance",	-- World Boss
		["Baleful Bluffs"]	= "Lieutenant Agrance",	-- World Boss
		["Recollection Rendezvous"]	= "Lieutenant Agrance",	-- World Boss
		["Hazardous Waters"]	= "Lieutenant Agrance",	-- World Boss

		["Mirrormoor Incursion"]	= "Lieutenant Jaida",	-- Mirrormoor
		["The Knot Awaits"]	= "Keshargo",	-- Lucent Citadel weekly trial
		["Fallen Leaves of West Weald"]	= "Gandrinar",	-- Special event daily -- 2.241 Fixed name; removed "the"

-- 2.240 Bretons - High Isle
		["Arcane Research"]			= "Wayllod",	-- Delve
		["Druidic Research"]		= "Wayllod",	-- Delve
		["A Final Peace"]			= "Wayllod",	-- Delve
		["Pirate Problems"]			= "Wayllod",	-- Delve
		["Prison Problems"]			= "Wayllod",	-- Delve
		["Seek and Destroy"]		= "Wayllod",	-- Delve

		["Ascendant Shadows"]		= "Parisse Plouff",	-- World Boss
		["Avarice of the Eldertide"]		= "Parisse Plouff",	-- World Boss
		["The Sable Knight"]		= "Parisse Plouff",	-- World Boss
		["The Serpent Caller"]		= "Parisse Plouff",	-- World Boss
		["A Special Reagent"]		= "Parisse Plouff",	-- World Boss
		["Wildhorn's Wrath"]		= "Parisse Plouff",	-- World Boss

		["Venting the Threat"]		= "Druid Peeska",	-- High Isle Volcanic Vent daily
		["Reavers of the Reef"]		= "Admiral Galvendier", -- Dreadsail Reef weekly

		["Cards Across the Continent"]			= "Kishka",	-- Tribute NPC daily
		["Dueling Tributes"]			= "Marunji",	-- Tribute PvP daily

-- 2.240 Bretons - Galen
		["Critter Capture"]			= "Juline Courcelles",	-- Delve
		["Flower Fancier"]			= "Juline Courcelles",	-- Delve
		["Helpful Handbills"]			= "Juline Courcelles",	-- Delve
		["Marking the Path"]			= "Juline Courcelles",	-- Delve
		["Radiant Souvenirs"]			= "Juline Courcelles",	-- Delve
		["Volcanic Virtuoso"]			= "Juline Courcelles",	-- Delve

		["A Wailing Wood"]			= "Druid Gastoc",	-- World Boss
		["Recovered Relics"]			= "Druid Gastoc",	-- World Boss
		["Shrines on Shaky Ground"]			= "Druid Gastoc",	-- World Boss
		["Sunflower Stamina"]			= "Druid Gastoc",	-- World Boss
		["The Moth Study"]			= "Druid Gastoc",	-- World Boss
		["Three-Pronged Approach"]			= "Druid Gastoc",	-- World Boss

		["Imminent Hazard"]			= "Druid Aishabeh",	-- Galen Volcanic Vent daily


-- 1.98 Zeal of Zenithar
		["Honest Toil"]			= "Fasaria",

-- 2.050 New Life
		["Mud Ball Merriment"]		= "Breda",
		["Fish Boon Feast"]			= "Breda",
		["Stonetooth Bash"]			= "Breda",
		["Castle Charm Challenge"]		= "Breda",
		["Lava Foot Stomp"]			= "Breda",
		["Snow Bear Plunge"]		= "Breda",
		["The Trial of Five-Clawed Guile"]	= "Breda",
		["Signal Fire Sprint"]		= "Breda",
		["War Orphan's Sojourn"]		= "Breda",
		["Old Life Observance"]		= "Petronius Galenus",


-- 1.80 seasonally de-activated
-- Whitestrake's Mayhem
		["Speaking For The Dead"]		= "Legate Gallus",	-- (Memorial District, Legate Gallus)
		["The Lifeblood of an Empire"]	= "Valga Atrius",	-- (Arena District, Valga Atrius)
		["Historical Accuracy"]		= "Loncano",	-- (Arboretum, Loncano)
		["Watch Your Step"]			= "Brihana",	-- (Nobles District, Brihana)
		["Dousing the Fires of Industry"]	= "Quintia Rullus",	-- (Elven Gardens, Quintia Rullus)
		["Priceless Treasures"]		= "Sister J'Reeza",	-- (Temple District, Sister J'Reeza)

-- Bruma
		["Dangerously Low"]			= "Hjorik",
		["Capstone Caps"]			= "Hjorik",
		["Lost and Alone"]			= "Hjorik",
		["The Standing Stones"]		= "Hjorik",
		["Enemy Reinforcements"]		= "Hjorik",
		["Know thy Enemy"]			= "Grigerda",
		["Requests for Aid"]		= "Grigerda",
		["Bring Down the Magister"]		= "Grigerda",
		["The Unseen"]			= "Grigerda",
		["Timely Intervention"]		= "Grigerda",

-- Cheydinhal
		["Thorns in Our Side"]		= "Vyctoria Girien",
		["Spice"]				= "Vyctoria Girien",
		["Prisoners of War"]		= "Vyctoria Girien",
		["The Burned Estate"]		= "Vyctoria Girien",
		["Ayleid Treasure"]			= "Vyctoria Girien",
		["Bloodied Waters"]			= "Sylvian Herius",
		["Keepsake"]			= "Sylvian Herius",
		["A Debt Come Due"]			= "Sylvian Herius",
		["Stacking the Odds"]		= "Sylvian Herius",
		["For Piety's Sake"]		= "Sylvian Herius",

-- Chorrol & Weynan Priory
		["Death to the Black Daggers!"]	= "Lliae the Quick",
		["Guard Work is Never Done"]		= "Lliae the Quick",
		["Field of Fire"]			= "Lliae the Quick",
		["The High Cost of Lying"]		= "Lliae the Quick",
		["The Cache"]			= "Lliae the Quick",
		["Abominations"]			= "Mael",
		["Claw of Akatosh"]			= "Mael",
		["Overdue Supplies"]		= "Mael",
		["The Lich"]			= "Mael",
		["Black Dagger Supplies"]		= "Mael",

-- Cropsford	
		["Seeds of Hope"]			= "Prefect Antias",
		["Offerings to Zenithar"]		= "Prefect Antias",
		["Crown Point"]			= "Prefect Antias",
		["The Hedoran Estate"]		= "Prefect Antias",
		["Harvest Time"]			= "Ufgra gra-Gum",
		["The Dead of Culotte"]		= "Ufgra gra-Gum",
		["Bloody Hand Spies!"]		= "Ufgra gra-Gum",
		["Securing Knowledge"]		= "Ufgra gra-Gum",
		["Timberscar Troubles"]		= "Ufgra gra-Gum",

-- Vlastarus
		["The Direct Approach"]		= "Nelerien",
		["Death to the Crone"]		= "Nelerien",
		["Bear Essentials"]			= "Nelerien",
		["Rock Bone Diplomacy"]		= "Nelerien",
		["For a Friend"]			= "Nelerien",
		["An Evil Presence"]		= "Jurana",
		["Mementos"]			= "Jurana",
		["Essence of Flame"]		= "Jurana",
		["Silver Scales"]			= "Jurana",
			
		["Bounty: Black Daggers"]		= "FIGHTER'S GUILD BOUNTY",	-- Special case; different quest givers per alliance. See code below.
		["Bounty: Goblins"]			= "FIGHTER'S GUILD BOUNTY",
		["Bounty: Gray Vipers"]		= "FIGHTER'S GUILD BOUNTY",
		["Bounty: Shadowed Path"]		= "FIGHTER'S GUILD BOUNTY",
			
		["Capture Alessia Farm"]		= "Battle Mission Board",
		["Capture Alessia Lumbermill"]	= "Battle Mission Board",
		["Capture Alessia Mine"]		= "Battle Mission Board",
		["Capture Aleswell Farm"]		= "Battle Mission Board",
		["Capture Aleswell Lumbermill"]	= "Battle Mission Board",
		["Capture Aleswell Mine"]		= "Battle Mission Board",
		["Capture Arrius Farm"]		= "Battle Mission Board",
		["Capture Arrius Lumbermill"]		= "Battle Mission Board",
		["Capture Arrius Mine"]		= "Battle Mission Board",
		["Capture Ash Farm"]		= "Battle Mission Board",
		["Capture Ash Lumbermill"]		= "Battle Mission Board",
		["Capture Ash Mine"]		= "Battle Mission Board",
		["Capture Black Boot Farm"]		= "Battle Mission Board",
		["Capture Black Boot Lumbermill"]	= "Battle Mission Board",
		["Capture Black Boot Mine"]		= "Battle Mission Board",
		["Capture Bloodmayne Farm"]		= "Battle Mission Board",
		["Capture Bloodmayne Lumbermill"]	= "Battle Mission Board",
		["Capture Bloodmayne Mine"]		= "Battle Mission Board",
		["Capture Blue Road Farm"]		= "Battle Mission Board",
		["Capture Blue Road Lumbermill"]	= "Battle Mission Board",
		["Capture Blue Road Mine"]		= "Battle Mission Board",
		["Capture Brindle Farm"]		= "Battle Mission Board",
		["Capture Brindle Lumbermill"]	= "Battle Mission Board",
		["Capture Brindle Mine"]		= "Battle Mission Board",
		["Capture Chalman Farm"]		= "Battle Mission Board",
		["Capture Chalman Lumbermill"]	= "Battle Mission Board",
		["Capture Chalman Mine"]		= "Battle Mission Board",
		["Capture Dragonclaw Farm"]		= "Battle Mission Board",
		["Capture Dragonclaw Lumbermill"]	= "Battle Mission Board",
		["Capture Dragonclaw Mine"]		= "Battle Mission Board",
		["Capture Drakelowe Farm"]		= "Battle Mission Board",
		["Capture Drakelowe Lumbermill"]	= "Battle Mission Board",
		["Capture Drakelowe Mine"]		= "Battle Mission Board",
		["Capture Faregyl Farm"]		= "Battle Mission Board",
		["Capture Faregyl Lumbermill"]	= "Battle Mission Board",
		["Capture Faregyl Mine"]		= "Battle Mission Board",
		["Capture Farragut Farm"]		= "Battle Mission Board",
		["Capture Farragut Lumbermill"]	= "Battle Mission Board",
		["Capture Farragut Mine"]		= "Battle Mission Board",
		["Capture Glademist Farm"]		= "Battle Mission Board",
		["Capture Glademist Lumbermill"]	= "Battle Mission Board",
		["Capture Glademist Mine"]		= "Battle Mission Board",
		["Capture Kingscrest Farm"]		= "Battle Mission Board",
		["Capture Kingscrest Lumbermill"]	= "Battle Mission Board",
		["Capture Kingscrest Mine"]		= "Battle Mission Board",
		["Capture Rayles Farm"]		= "Battle Mission Board",
		["Capture Rayles Lumbermill"]		= "Battle Mission Board",
		["Capture Rayles Mine"]		= "Battle Mission Board",
		["Capture Roebeck Farm"]		= "Battle Mission Board",
		["Capture Roebeck Lumbermill"]	= "Battle Mission Board",
		["Capture Roebeck Mine"]		= "Battle Mission Board",
		["Capture Warden Farm"]		= "Battle Mission Board",
		["Capture Warden Lumbermill"]		= "Battle Mission Board",
		["Capture Warden Mine"]		= "Battle Mission Board",
			
		["Kill Enemy Dragonknights"]		= "Bounty Mission Board",
		["Kill Enemy Necromancers"]		= "Bounty Mission Board",
		["Kill Enemy Nightblades"]		= "Bounty Mission Board",
		["Kill Enemy Players"]		= "Bounty Mission Board",
		["Kill Enemy Sorcerers"]		= "Bounty Mission Board",
		["Kill Enemy Templars"]		= "Bounty Mission Board",
		["Kill Enemy Wardens"]		= "Bounty Mission Board",
			
		["Capture All 3 Towns"]		= "Conquest Mission Board",
		["Capture Any Nine Resources"]	= "Conquest Mission Board",
		["Capture Any Three Keeps"]		= "Conquest Mission Board",
		["Kill 40 Enemy Players"]		= "Conquest Mission Board",
			
		["Scout Alessia Farm"]		= "Scouting Mission Board",
		["Scout Alessia Lumbermill"]		= "Scouting Mission Board",
		["Scout Alessia Mine"]		= "Scouting Mission Board",
		["Scout Aleswell Farm"]		= "Scouting Mission Board",
		["Scout Aleswell Lumbermill"]		= "Scouting Mission Board",
		["Scout Aleswell Mine"]		= "Scouting Mission Board",
		["Scout Arrius Farm"]		= "Scouting Mission Board",
		["Scout Arrius Keep"]		= "Scouting Mission Board",
		["Scout Arrius Lumbermill"]		= "Scouting Mission Board",
		["Scout Arrius Mine"]		= "Scouting Mission Board",
		["Scout Ash Farm"]			= "Scouting Mission Board",
		["Scout Ash Lumbermill"]		= "Scouting Mission Board",
		["Scout Ash Mine"]			= "Scouting Mission Board",
		["Scout Black Boot Farm"]		= "Scouting Mission Board",
		["Scout Black Boot Lumbermill"]	= "Scouting Mission Board",
		["Scout Black Boot Mine"]		= "Scouting Mission Board",
		["Scout Bloodmayne Farm"]		= "Scouting Mission Board",
		["Scout Bloodmayne Lumbermill"]	= "Scouting Mission Board",
		["Scout Bloodmayne Mine"]		= "Scouting Mission Board",
		["Scout Blue Road Farm"]		= "Scouting Mission Board",
		["Scout Blue Road Keep"]		= "Scouting Mission Board",
		["Scout Blue Road Lumbermill"]	= "Scouting Mission Board",
		["Scout Blue Road Mine"]		= "Scouting Mission Board",
		["Scout Brindle Farm"]		= "Scouting Mission Board",
		["Scout Brindle Lumbermill"]		= "Scouting Mission Board",
		["Scout Brindle Mine"]		= "Scouting Mission Board",
		["Scout Castle Alessia"]		= "Scouting Mission Board",
		["Scout Castle Black Boot"]		= "Scouting Mission Board",
		["Scout Castle Bloodmayne"]		= "Scouting Mission Board",
		["Scout Castle Brindle"]		= "Scouting Mission Board",
		["Scout Castle Faregyl"]		= "Scouting Mission Board",
		["Scout Castle Roebeck"]		= "Scouting Mission Board",
		["Scout Chalman Farm"]		= "Scouting Mission Board",
		["Scout Chalman Keep"]		= "Scouting Mission Board",
		["Scout Chalman Lumbermill"]		= "Scouting Mission Board",
		["Scout Chalman Mine"]		= "Scouting Mission Board",
		["Scout Dragonclaw Farm"]		= "Scouting Mission Board",
		["Scout Dragonclaw Lumbermill"]	= "Scouting Mission Board",
		["Scout Dragonclaw Mine"]		= "Scouting Mission Board",
		["Scout Drakelowe Farm"]		= "Scouting Mission Board",
		["Scout Drakelowe Keep"]		= "Scouting Mission Board",
		["Scout Drakelowe Lumbermill"]	= "Scouting Mission Board",
		["Scout Drakelowe Mine"]		= "Scouting Mission Board",
		["Scout Faregyl Farm"]		= "Scouting Mission Board",
		["Scout Faregyl Lumbermill"]		= "Scouting Mission Board",
		["Scout Faregyl Mine"]		= "Scouting Mission Board",
		["Scout Farragut Farm"]		= "Scouting Mission Board",
		["Scout Farragut Keep"]		= "Scouting Mission Board",
		["Scout Farragut Lumbermill"]		= "Scouting Mission Board",
		["Scout Farragut Mine"]		= "Scouting Mission Board",
		["Scout Fort Aleswell"]		= "Scouting Mission Board",
		["Scout Fort Ash"]			= "Scouting Mission Board",
		["Scout Fort Dragonclaw"]		= "Scouting Mission Board",
		["Scout Fort Glademist"]		= "Scouting Mission Board",
		["Scout Fort Rayles"]		= "Scouting Mission Board",
		["Scout Fort Warden"]		= "Scouting Mission Board",
		["Scout Glademist Farm"]		= "Scouting Mission Board",
		["Scout Glademist Lumbermill"]	= "Scouting Mission Board",
		["Scout Glademist Mine"]		= "Scouting Mission Board",
		["Scout Kingscrest Farm"]		= "Scouting Mission Board",
		["Scout Kingscrest Keep"]		= "Scouting Mission Board",
		["Scout Kingscrest Lumbermill"]	= "Scouting Mission Board",
		["Scout Kingscrest Mine"]		= "Scouting Mission Board",
		["Scout Rayles Farm"]		= "Scouting Mission Board",
		["Scout Rayles Lumbermill"]		= "Scouting Mission Board",
		["Scout Rayles Mine"]		= "Scouting Mission Board",
		["Scout Roebeck Farm"]		= "Scouting Mission Board",
		["Scout Roebeck Lumbermill"]		= "Scouting Mission Board",
		["Scout Roebeck Mine"]		= "Scouting Mission Board",
		["Scout Warden Farm"]		= "Scouting Mission Board",
		["Scout Warden Lumbermill"]		= "Scouting Mission Board",
		["Scout Warden Mine"]		= "Scouting Mission Board",
			
		["Capture Castle Alessia"]		= "Warfront Mission Board",
		["Capture Castle Black Boot"]		= "Warfront Mission Board",
		["Capture Castle Bloodmayne"]		= "Warfront Mission Board",
		["Capture Castle Brindle"]		= "Warfront Mission Board",
		["Capture Castle Faregyl"]		= "Warfront Mission Board",
		["Capture Castle Roebeck"]		= "Warfront Mission Board",
		["Capture Fort Aleswell"]		= "Warfront Mission Board",
		["Capture Fort Ash"]		= "Warfront Mission Board",
		["Capture Fort Dragonclaw"]		= "Warfront Mission Board",
		["Capture Fort Glademist"]		= "Warfront Mission Board",
		["Capture Fort Rayles"]		= "Warfront Mission Board",
		["Capture Fort Warden"]		= "Warfront Mission Board",
		["Capture Arrius Keep"]		= "Warfront Mission Board",
		["Capture Blue Road Keep"]		= "Warfront Mission Board",
		["Capture Chalman Keep"]		= "Warfront Mission Board",
		["Capture Drakelowe Keep"]		= "Warfront Mission Board",
		["Capture Farragut Keep"]		= "Warfront Mission Board",
		["Capture Kingscrest Keep"]		= "Warfront Mission Board",
			
		["The Elder Scroll of Alma Ruma"]	= "SCROLL QUEST",	-- Special case; different quest givers per alliance. See code below.
		["The Elder Scroll of Altadoon"]	= "SCROLL QUEST",
		["The Elder Scroll of Chim"]		= "SCROLL QUEST",
		["The Elder Scroll of Ghartok"]	= "SCROLL QUEST",
		["The Elder Scroll of Mnem"]		= "SCROLL QUEST",
		["The Elder Scroll of Ni-Mohk"]	= "SCROLL QUEST",


-- Jester's Festival
		["Royal Revelry"]			= "Jester King Emeric",
		["Springtime Flair"]		= "Jester Queen Ayrenn",
		["A Noble Guest"]			= "Jester King Jorunn",
		["A Foe Most Porcine"]		= "Rozette the Rapscallion",
		["The King's Spoils"]		= "Jad'zirri",
		["Prankster's Carnival"]		= "Soars-in-Laughter",
		["Getting the Band Together"]		= "Samuel Gourone",

	}

-- 1.89 Added special cases for quest names that have multiple quest givers
	local SpecialQuestGivers = {
-- Skyrim (Dark Heart of Skyrim)
		["Talk to Swordthane Jylta"]		= "Swordthane Jylta",	-- Harrowstorm daily
		["Talk to Nelldena"]		= "Nelldena",		-- Harrowstorm daily

-- Whitestrake's Mayhem
		["Talk to Sebazi"]			= "Sebazi",		-- AD bounty quests
		["Talk to Arkas"]			= "Arkas",		-- DC bounty quests
		["Talk to Ikran"]			= "Ikran",		-- EP bounty quests

		["Talk to Grand Warlord Sorcalin"]	= "Grand Warlord Sorcalin",	-- AD scroll capture quests
		["Talk to Grand Warlord Dortene"]	= "Grand Warlord Dortene",	-- DC scroll capture quests
		["Talk to Grand Warlord Zimmeron"]	= "Grand Warlord Zimmeron",	-- EP scroll capture quests

}

-- 1.89 Added
	local EventNames = {
-- ******************************************
-- EVENTUPDATE QUESTTICKETS EVENT NAMES
-- ******************************************

-- 2.240 West Weald
		["Commandant Salerius"]  = "West Weald", -- 6 West Weald delve quests
		["Lieutenant Agrance"]  = "West Weald", -- 6 West Weald world boss quests
		["Lieutenant Jaida"]  = "West Weald", -- 2 West Weald Mirrormoor quests
		["Keshargo"]  = "West Weald", -- Lucent Citadel weekly trial quest
		["Gandrinar"]  = "West Weald", -- Special event daily quest

-- 2.240 Bretons - High Isle
		["Wayllod"]		= "Bretons",	-- 6 High Isle delve quests
		["Parisse Plouff"]		= "Bretons",	-- 6 High Isle world boss dailies
		["Druid Peeska"]		= "Bretons",	-- 2 Volcanic Vent dailies
		["Admiral Galvendier"]	= "Bretons",	-- Dreadsail Reef trial weekly quest
		["Kishka"]	= "Bretons",	-- NPC Tribute daily quest
		["Marunji"]	= "Bretons",	-- PvP Tribute daily quest

-- 2.240 Bretons - Galen
		["Juline Courcelles"]		= "Bretons",	-- 6 Galen delve quests
		["Druid Gastoc"]		= "Bretons",	-- 6 Galen world boss dailies
		["Druid Aishabeh"]		= "Bretons",	-- 2 Galen Volcanic Vent dailies


-- 1.98 Zeal of Zenithar
		["Fasaria"]		= "Zeal of Zenithar",

-- 2.050 For New Life, activators are "Breda", and "Petronius Galenus" for Old Life quest.
		["Breda"]			= "New Life",	-- New Life (9 "New Life" daily quests, plus starter quest that doesn't give tickets)
		["Petronius Galenus"]	= "New Life",	-- New Life (1 "Old Life" daily quest)


-- 1.80 seasonally de-activated
-- 1.71 Whitestrake's Mayhem
		["Legate Gallus"]		= "Whitestrake's Mayhem",	-- "Speaking For The Dead", Memorial District, IC
		["Valga Atrius"]		= "Whitestrake's Mayhem",	-- "The Lifeblood of an Empire", Arena
		["Loncano"]		= "Whitestrake's Mayhem",	-- "Historical Accuracy", Arboretum (questgiver name not checked)
		["Brihana"]		= "Whitestrake's Mayhem",	-- "Watch Your Step", Nobles
		["Quintia Rullus"]		= "Whitestrake's Mayhem",	-- "Dousing the Fires of Industry", Elven Gardens
		["Sister J'Reeza"]		= "Whitestrake's Mayhem",	-- "Priceless Treasures", Temple

		["Hjorik"]		= "Whitestrake's Mayhem",	-- Bruma (5)
		["Grigerda"]		= "Whitestrake's Mayhem",	-- Bruma (5)
		["Vyctoria Girien"]		= "Whitestrake's Mayhem",	-- Cheydinhal (5)
		["Sylvian Herius"]		= "Whitestrake's Mayhem",	-- Cheydinhal (5)
		["Lliae the Quick"]		= "Whitestrake's Mayhem",	-- Chorrol (5)
		["Mael"]			= "Whitestrake's Mayhem",	-- Weynan Priory (5)
		["Prefect Antias"]		= "Whitestrake's Mayhem",	-- Cropsford (4)
		["Ufgra gra-Gum"]		= "Whitestrake's Mayhem",	-- Cropsford (5)
		["Nelerien"]		= "Whitestrake's Mayhem",	-- Vlastarus (5)
		["Jurana"]		= "Whitestrake's Mayhem",	-- Vlastarus (4)

		["FIGHTER'S GUILD BOUNTY"]	= "Whitestrake's Mayhem",	-- Fighter's Guild bounty quests (This is a special category - see code)
		["Sebazi"]		= "Whitestrake's Mayhem",	-- AD bounty quests
		["Arkas"]			= "Whitestrake's Mayhem",	-- DC bounty quests
		["Ikran"]			= "Whitestrake's Mayhem",	-- EP bounty quests

		["Conquest Mission Board"]	= "Whitestrake's Mayhem",	-- All alliances
		["Scouting Mission Board"]	= "Whitestrake's Mayhem",	-- All alliances (non-sharable scouting quests, 500 AP)
		["Bounty Mission Board"]	= "Whitestrake's Mayhem",	-- All alliances (kill 20 enemy players)
		["Battle Mission Board"]	= "Whitestrake's Mayhem",	-- All alliances (capture a resource)
		["Warfront Mission Board"]	= "Whitestrake's Mayhem",	-- All alliances (capture a keep, 3k AP)

		["SCROLL QUEST"]		= "Whitestrake's Mayhem",	-- Scroll capture quests (This is a special category - see code)
		["Grand Warlord Sorcalin"]	= "Whitestrake's Mayhem",	-- AD scroll capture quests
		["Grand Warlord Dortene"]	= "Whitestrake's Mayhem",	-- DC scroll capture quests
		["Grand Warlord Zimmeron"]	= "Whitestrake's Mayhem",	-- EP scroll capture quests


-- Jester's Festival
		["Jester King Emeric"]	= "Jester's Festival",	-- "Royal Revelry"
		["Jester Queen Ayrenn"]	= "Jester's Festival",	-- "Springtime Flair"
		["Jester King Jorunn"]	= "Jester's Festival",	-- "A Noble Guest"
		["Rozette the Rapscallion"]	= "Jester's Festival",	-- "A Foe Most Porcine"
		["Jad'zirri"]		= "Jester's Festival",	-- "The King's Spoils"
		["Soars-in-Laughter"]	= "Jester's Festival",	-- "Prankster's Carnival"
		["Samuel Gourone"]		= "Jester's Festival",	-- "Getting the Band Together"

	}
	local EventName = "none"

-- ******************************************
-- GUILDS & GLORY SPECIAL 2
-- ******************************************
--[[ 2.060 Imperial City quests - setting this only for G&G because Mayhem will be the next event
	if EVT.vars.Current_Event == "Guilds & Glory" then
		EventNames["Legate Gallus"]		= "Guilds & Glory"	-- "Speaking For The Dead", Memorial District, IC
		EventNames["Valga Atrius"]		= "Guilds & Glory"	-- "The Lifeblood of an Empire", Arena
		EventNames["Loncano"]		= "Guilds & Glory"	-- "Historical Accuracy", Arboretum (questgiver name not checked)
		EventNames["Brihana"]		= "Guilds & Glory"	-- "Watch Your Step", Nobles
		EventNames["Quintia Rullus"]		= "Guilds & Glory"	-- "Dousing the Fires of Industry", Elven Gardens
		EventNames["Sister J'Reeza"]		= "Guilds & Glory"	-- "Priceless Treasures", Temple
	end
]]

	EVT.PrintDebug("|cFF00CCHere's a list of your active quests and whether it's completed:|r")
	local count = GetNumJournalQuests()
	for i = 1, count do
		local questName, bgText, activeStepText, activeStepType, activeStepTrackerOverrideText, QuestCompleted, QuestTracked, QuestLevel, QuestPushed, QuestType, InstanceDisplayType = GetJournalQuestInfo(i)

--    Returns: string questName, string backgroundText, string activeStepText, number activeStepType, string activeStepTrackerOverrideText, boolean completed, boolean tracked, number questLevel, boolean pushed, number questType, number InstanceDisplayType
-- Tracked: The currently active quest. Pushed: Always seems to be false. Don't know what this is.
		local QuestIsDone = "Completed"
		if QuestCompleted then QuestIsDone = "|c32CD32 YES|r" else QuestIsDone = "|cFF0000 NO|r" end

-- 1.89		EVT.PrintDebug(questName .. QuestIsDone)

		if EventQuestNames[questName] == nil then
			EventQuestGiver = "None"
		else
			EventQuestGiver = EventQuestNames[questName]
-- 1.89
			if QuestCompleted and GetJournalQuestConditionInfo(i)~="Talk to " .. EventQuestGiver then
				local index = GetJournalQuestConditionInfo(i)
-- 1.90				d(index)
				if SpecialQuestGivers[index] ~= nil then
-- 2.110 Removed old debugging line
--					d(SpecialQuestGivers[index])
				EventQuestGiver = SpecialQuestGivers[index] end
--				EVT.PrintDebug("|cFF0000QUEST GIVER OVERRIDE!!|r " .. EventQuestGiver)
			end

			EventName = EventNames[EventQuestGiver]
			EVT.PrintDebug(EventName .. questName .. QuestIsDone)
			EVT_QUEST_TICKETS[EventQuestGiver] = 0

			local numRewards = GetJournalQuestNumRewards(i)
			for j = 1, numRewards do
-- number RewardType, string name, number amount, textureName iconFile, boolean meetsUsageRequirement, number ItemQuality, number:nilable RewardItemType
				local rewardType, rewardname, amount = GetJournalQuestRewardInfo(i, j)
				if rewardType == REWARD_TYPE_EVENT_TICKETS then
					if QuestCompleted then
						EVT_QUEST_TICKETS[EventQuestGiver] = amount
						EVT.PrintDebug(string.format(" |cFF00CC %s %s|r |c00CCFFQuest giver: %s Tickets: %s|r",i,questName,EventQuestGiver,amount))
					else
						EVT.PrintDebug(string.format(" |cFFFFFF %s %sQuest giver: %s Tickets: %s - NOT DONE|r",i,questName,EventQuestGiver,amount))
					end
				end
			end

			if EventQuestGiver == "FIGHTER'S GUILD BOUNTY" then
				EVT_QUEST_TICKETS["Sebazi"] = EVT_QUEST_TICKETS[EventQuestGiver]	-- AD
				EVT_QUEST_TICKETS["Arkas"] = EVT_QUEST_TICKETS[EventQuestGiver]	-- DC
				EVT_QUEST_TICKETS["Ikran"] = EVT_QUEST_TICKETS[EventQuestGiver]	-- EP
			elseif EventQuestGiver == "SCROLL QUEST" then
				EVT_QUEST_TICKETS["Grand Warlord Sorcalin"] = EVT_QUEST_TICKETS[EventQuestGiver]	-- AD
				EVT_QUEST_TICKETS["Grand Warlord Dortene"] = EVT_QUEST_TICKETS[EventQuestGiver]		-- DC
				EVT_QUEST_TICKETS["Grand Warlord Zimmeron"] = EVT_QUEST_TICKETS[EventQuestGiver]	-- EP
			end
--			if EventQuestGiver ~= "None" then EVT.PrintDebug(string.format("Quest Giver: %s Quest: %s Finished: %s Tickets: %s",EventQuestGiver,questName,QuestIsDone,EVT_QUEST_TICKETS[EventQuestGiver])) end
		end
	end
--[[	for questgiver, tickets in pairs(EVT_QUEST_TICKETS) do
		if tickets > 0 then
			EVT.PrintDebug(string.format("|cFF00CCQuest Giver: %s Tickets: %s|r",questgiver,tickets))
		else
			EVT.PrintDebug(string.format("Quest Giver: %s Tickets: %s",questgiver,tickets))
		end
	end
]]
end


function EVT.Ticket_Location()

-- Dungeons/Trial: These are last room locations where tickets could be acquired.
-- Originally written for Dawn of the Dragonguard, Nov. 26-Dec. 9, 2019
-- Probably should've also had delves; if it's ever done again, add those
-- 1.57 Added ICP and WGT for Year One just in case tickets drop from those
	local find_location = {
		[1805] = "Skyrim",		-- "Kyne's Aegis" (starting room, for warning)
		[1858] = "Markarth",	-- All the Markarth daily quest givers will be in this location

		[771] = "Imperial City",	-- "Lost Sanctum" (final boss room of ICP) Starts: 765
		[918] = "Imperial City",	-- "Pinnacle" (final boss room of WGT) Starts: 907
-- 1.80		[890] = "Imperial City",	-- EP sewer base
-- 1.80		[897] = "Imperial City",	-- AD sewer base
-- 1.80		[900] = "Imperial City",	-- DC sewer base

--		[1286] = "Morrowind/Clockwork",	-- "Tyl Fyr" (Halls of Fabrication entrance)
--		[1391] = "Morrowind/Clockwork",	-- "Asylum Atrium" (Asylum Sanctorium entrance)
--		[1502] = "Summerset",	-- (Cloudrest entrance)

-- Halls of Fabrication might also count for Morrowind; Asylum Sanctorium for Clockwork City.
-- HoF Entrance: Tel Fyr (1286). AS: Asylum Atrium (1391), Asylum Atrium Upper Level (1392), . Clockwork City is 1313.
-- 1310 is Nchuleftingth PD in Vvardenfell. 1312 is also in there.
-- 1.57		[1060] = "Morrowind",	-- Vvardenfell (hopefully this will cover the Ald'ruhn dailies)
-- 1.57		[1231] = "Morrowind",	-- Saint Olms Waistworks
-- 1.57		[1234] = "Morrowind",	-- Saint Delyn Plaza

--[[		["Northern Elsweyr"] = "Northern Elsweyr",
		["Sunspire Courtyard"] = "Northern Elsweyr",
		["Sunspire Summit"] = "Northern Elsweyr",
		["Sunspire Temple Grounds"] = "Northern Elsweyr",
		["Southern Elsweyr"] = "Southern Elsweyr",
		["Moonlight's Mausoleum"] = "Southern Elsweyr",		-- Scalebreaker (Moongrave Fane, N. Elsweyr)
		["Azureblight Summit"] = "Southern Elsweyr",		-- Scalebreaker (Lair of Maarselok, Grahtwood)
		["Vault of Mhuvnak"] = "Southern Elsweyr",		-- Wrathstone (Frostvault, Eastmarch)
		["Tabernacle of Light Unyielding"] = "Southern Elsweyr",	-- Wrathstone (Depths of Malatar, Gold Coast)
]]
		}
	local where = GetCurrentMapId()

-- 1.57 Removed Morrowind stuff below
--[[	if find_location[where] == nil and (EVT.vars.Current_Event == "Tribunal" or EVT.vars.Current_Event == "None") and where < 1313 then
		EVT.PrintDebug("|cFF0000LOCATION GUESSED!|r Morrowind " .. string.format(GetCurrentMapId()) .. " " .. GetMapName())
		where = "Morrowind"
]]
	if find_location[where] == nil then
		EVT.PrintDebug("Unknown location: " .. string.format(GetCurrentMapId()) .. " " .. GetMapName())
		where = "Unknown"
	else
		where = find_location[GetCurrentMapId()]
		EVT.PrintDebug("Map: " .. GetMapName() .. ", Ticket: " .. where)
	end
	return where
end


----------------------------------------
-- Unknown Event
-- 1.17 Set up to handle collect ticket(s) twice per day
----------------------------------------
function EVT.UnknownEvent(NewTick,OldTick)
	local HowManyTickets = NewTick - OldTick

--[[ 1.34 Removed
	if MostRecentBox == EVT.FindCurrentTime() then
		if EVT.vars.T_Time[BoxType] ~= nil and EVT.vars.T_ToDo[BoxType] ~= nil then
			EVT.PrintDebug(BoxType .. " tickets done for the day because of quest.")
			EVT.vars.T_Time[BoxType] = EVT.FindCurrentTime()
			EVT.vars.T_ToDo[BoxType] = 0
		else
			if EVT.vars.T_Time[BoxType] == nil then
				EVT.PrintDebug("|cff0000" .. BoxType .. " identified, but tickets not reset because TIME is missing.|r")
			end
			if EVT.vars.T_ToDo[BoxType] == nil then
				EVT.PrintDebug("|cff0000" .. BoxType .. " identified, but tickets not reset because TO DO is missing.|r")
			end
		end
	end
]]

	if EVT.vars.Current_Event == "None" then
		EVT.PrintDebug("Setting up for new UNKNOWN event!!")
		EVT.vars.T_Types   = nil
		EVT.vars.T_Time    = nil
		EVT.vars.T_ToDo    = nil
		EVT.vars.T_Tickets = nil

		EVT.vars.T_Types   = {
			[1] = "First",
			[2] = "Second",
			[3] = "Boss",
		}
		EVT.vars.T_Time    = {EVT.FindCurrentTime(),EVT.FindCurrentTime(),EVT.FindCurrentTime(),}
		EVT.vars.T_ToDo    = {0,0,0,}
		EVT.vars.T_Tickets = {HowManyTickets,0,0,0,}

-- 1.34 Activate loot box identification if not already activated
		EVENT_MANAGER:RegisterForEvent(EVT.name, EVENT_LOOT_RECEIVED, EVT.OnLootReceived)

-- 1.18 If tickets hit cap, no idea what's going on, so dump it in "Unknown"
	elseif NewTick > 11 then
		EVT.vars.T_Tickets[3] = EVT.vars.T_Tickets[3] + HowManyTickets
	else
		if EVT.vars.T_ToDo[1] == 1 and EVT.vars.T_Tickets[1] == HowManyTickets then
			EVT.vars.T_ToDo[1] = 0
			EVT.PrintDebug("Saving FIRST ticket(s)!!")
		elseif EVT.vars.T_ToDo[2] == 1 and EVT.vars.T_Tickets[2] == HowManyTickets then
			EVT.vars.T_ToDo[2] = 0
			EVT.PrintDebug("Saving SECOND ticket(s)!!")
		elseif EVT.vars.T_Tickets[2] == 0 then
			EVT.vars.T_Tickets[2] = HowManyTickets
			EVT.vars.T_ToDo[2] = 0
			EVT.PrintDebug("Setting up unknown SECOND ticket(s)!!")
		end
	end

	EVT.vars.Current_Event  = "Unknown"
	EVT.vars.Event_Start = EVT.FindCurrentTime()
	EVT_EVENT_START = EVT.FindCurrentTime()
	EVT_EVENT_END = EVT_DATE_UNKNOWN
	EVT_NEXT_EVENT = "Unknown"

end


----------------------------------------
-- New Life Dec. 19, 2019 - Jan. 2, 2020
-- 1.34 Changed to handle any Quest-based event
-- Then neither tested nor used; decided to go with location.
----------------------------------------
--[[function EVT.Quest_Tickets(QuestEvent, QuestTickets)
-- 1.12 Completely re-wrote algorithm for tickets. Was using 2 tickets for New Life, 3 for Boss, since 1.08
--      Lost noticed that doesn't work if near cap and not all tickets are collected, so using quests now.
	if math.abs(MostRecentQuest-EVT.FindCurrentTime()) < 15 and QuestType == QuestEvent then
		EVT.vars.T_Time[1] = EVT.FindCurrentTime()
		EVT.vars.T_ToDo[1] = 0
	elseif QuestTickets == 3 or QuestTickets == 12 - EVT.vars.Total_Tickets then
		EVT.vars.T_Time[2] = EVT.FindCurrentTime()
		EVT.vars.T_ToDo[2] = 0
	end
end
]]


-- 1.17 Get rid of all the old stuff, in between events, and set a flag that it's been done so it doesn't have to be done again.
--EVENTUPDATE Change this every event to clear out anything that was used for the previous. After a full year cycle, probably won't need to add much more.
function EVT.ClearData()
	EVT.PrintDebug("Clearing data.")

	EVT.vars.T_Types   = {
		[1] = "First",
		[2] = "Second",
		[3] = "Boss",
		}
	EVT.vars.T_Time   = {
		["First"] = nil,
		["Second"] = nil,
		["not used"] = nil,
		["Boss"] = nil,
		["Other"] = nil,
		["Northern Elsweyr"] = nil,
		["Southern Elsweyr"] = nil,
		["New Life"] = nil,
		["Mid-Year"] = nil,
		["Mid-Year Mayhem"] = nil,
		["Murkmire"] = nil,
		["Jester's Festival"] = nil,
		["Anniversary"] = nil,
		[1] = 0,
		[2] = 0,
		[3] = 0,
	}
	EVT.vars.T_ToDo = {
		["First"] = nil,
		["Second"] = nil,
		["not used"] = nil,
		["Boss"] = nil,
		["Other"] = nil,
		["Northern Elsweyr"] = nil,
		["Southern Elsweyr"] = nil,
		["New Life"] = nil,
		["Mid-Year"] = nil,
		["Mid-Year Mayhem"] = nil,
		["Murkmire"] = nil,
		["Jester's Festival"] = nil,
		["Anniversary"] = nil,
		[1] = 0,
		[2] = 0,
		[3] = 0,
	}
	EVT.vars.T_Tickets = {
		["First"] = nil,
		["Second"] = nil,
		["not used"] = nil,
		["Unknown"] = nil,
		["Boss"] = nil,
		["Other"] = nil,
		["Northern Elsweyr"] = nil,
		["Southern Elsweyr"] = nil,
		["New Life"] = nil,
		["Mid-Year"] = nil,
		["Mid-Year Mayhem"] = nil,
		["Murkmire"] = nil,
		["Jester's Festival"] = nil,
		["Anniversary"] = nil,
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
	}

	if EVT.vars.Current_Event == "None" or EVT.vars.Current_Event == "Unknown" then
		if EVT_NEXT_EVENT  == "None" then
			EVT_PRE_INFO = No_Event_Info
			EVT_PRE_CHAT = No_Event_Info
		end
		EVT_CURRENT_INFO = No_Event_Info
		EVT_CURRENT_CHAT = No_Event_Info
	end

	EVT.vars.DataCleared = true
end
