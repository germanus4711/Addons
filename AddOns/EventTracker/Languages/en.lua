-- Created May 11, 2020
-- Updated every time there's an event update for the addon.
-- 1.92 Added PTS info for Jester and Anniv 2023

local strings = {
-- 1.95 Added NEWS! EU and NA separate.
--	EVT_EVENT_INFO_NEWS_NA = "New ticket reset time; 4 hrs later than the old time! Only 4 hrs for last partial-day tickets on NA!",
--	EVT_EVENT_INFO_NEWS_EU = "New ticket reset time; 3 hrs earlier than the old time. Don't wait till the last minute for your first partial-day tickets!",
--	EVT_EVENT_INFO_NEWS_NA = "Zeal of Zenithar extended one extra day!",
--	EVT_EVENT_INFO_NEWS_NA = "New Life double xp will be PASSIVE! Doomchar Plateau will be available again starting January 2024!",
--	EVT_EVENT_INFO_NEWS_EU = "New Life double xp will be PASSIVE! Doomchar Plateau will be available again starting January 2024!",
	EVT_EVENT_INFO_NEWS_NA = "Whitestrake's Mayhem: Double XP applies to EVERYTHING in Cyro, IC, and battlegrounds. Double XP and AP are PASSIVE!",
	EVT_EVENT_INFO_NEWS_EU = "Whitestrake's Mayhem: Double XP applies to EVERYTHING in Cyro, IC, and battlegrounds. Double XP and AP are PASSIVE!",
	EVT_EVENT_INFO_NEWS_PTS = "PTS event cycle is always a mystery. Until it's not.",

-- 1.52 Added
	EVT_EVENT_INFO_TICKETS = "Spend",
	EVT_EVENT_INFO_IMPRESARIO = "at the",

	EVT_EVENT_INFO_PET = "3 fragments (5 tickets each) may be purchased from the Impresario to create a ",
-- 1.62 House costs 5. Also, announced with PTS New Life: all morph fragments will be available again then.
	EVT_EVENT_INFO_MORPH = "3 fragments (10 tickets each) can morph a |H1:collectible:10697|h|h Pet into a |H1:collectible:10913|h|h Personality or a |H1:collectible:10661|h|h Skin. The pet is consumed by this process. ",
-- Scales of Akatosh skin and Aurelic Quasigriff mount might be available again at New Life.",

-- 1.78 Added Indrik info (3 parts)
	EVT_EVENT_INFO_INDRIK = "Indriks are available during every event at the Indrik vendor in Craglorn. There are 4 feathers (5 tickets each) for a Nascent Indrik, and it takes a Nascent Indrik and 4 berries (10 tickets each) to morph into one of the fancier Indriks. '/evti cycle' for more info.",
--	EVT_EVENT_INFO_INDRIK_MORPH = "in Craglorn. Indriks can be morphed",
	EVT_EVENT_INFO_INDRIK_CYCLE_1 = "The Nascent Indrik",
	EVT_EVENT_INFO_INDRIK_CYCLE_2 = "is available during each event, plus 2 pets & berries for 2 mounts. Jan-Mar: Dawnwood & Spectral, Apr-Jun: Luminous & Icebreath, Jul-Sep: Onyx & Mossheart, Oct-Dec: Pure Snow & Crimson",

-- 1.62 Added
	EVT_XPBUFF = "4 annual events have PASSIVE DOUBLE XP running during the entire event. There is no buff; no way to see that it's working. It's just there. March: Jester's, April: Anniversary, Oct.: Witches, Dec.: New Life.",
--	EVT_XPBUFF = "4 annual events have a 2-hr xp buff available by using a TOOL (formerly memento). March: Jester's, April: Anniversary, Oct.: Witches, Dec.: New Life. Event Tracker will help you refresh it with the /xpbuff chat command.",

-- Future dates, not used yet
--	EVT_EVENT_INFO_FUTURE_DATES = " ", -- For when some info is known about upcoming quest dates, but nothing specific.

	EVT_EVENT_INFO_NONE = "There is no event going on right now.",
	EVT_EVENT_INFO_UNKNOWN = "This version of Event Tracker has no detailed information. There may be an update available.",

-- Boss, not used yet
--	EVT_EVENT_INFO_BOSS = "Additional tickets available every day from killing a world boss, delve boss, dolmen/geyser/dragon boss, or a final boss in a dungeon, arena, or trial.",
--	EVT_EVENT_INFO_BOSS = " Plus x additional tickets per day per account from a world or public dungeon boss, or the final boss of a delve, dark fissure, dolmen/geyser/dragon/harrowstorm, group dungeon, arena, or trial. Quest bosses may also work. ALWAYS LOOT BODIES/REWARD CHESTS!",

-- *************** ANNUAL EVENTS
-- July 12, 2021: Event name change announced, "Whitestrake's Mayhem".
	EVT_EVENT_INFO_WHITESTRAKE = "February, 2025. Tickets from DAILY quests: 2 from Battlegrounds or Cyrodiil, plus 1 from Imperial City; per account per day. DOUBLE XP/AP/Tel Var PASSIVE NOW!",
--	EVT_EVENT_INFO_WHITESTRAKE = "July 25-August 6, 2024 (39 tickets). Tickets from DAILY quests: 2 from Battlegrounds or Cyrodiil, plus 1 from Imperial City; per account per day. DOUBLE XP/AP/Tel Var PASSIVE NOW!",
--	EVT_EVENT_INFO_WHITESTRAKE = "Feb. 22-March 5, 2024. Tickets from DAILY quests: 2 from Battlegrounds or Cyrodiil, plus 1 from Imperial City; per account per day. DOUBLE XP/AP/Tel Var PASSIVE NOW!",
--	EVT_EVENT_INFO_WHITESTRAKE = "June 29-July 11, 2023 (39 tickets). Tickets from DAILY quests: 2 from Battlegrounds or Cyrodiil, plus 1 from Imperial City; per account per day.",
--	EVT_EVENT_INFO_WHITESTRAKE = "July 28-Aug. 9, 2022. Tickets from DAILY quests: 2 from Battlegrounds or Cyrodiil, plus 1 from Imperial City; per account per day.",
--	EVT_EVENT_INFO_WHITESTRAKE = "Feb. 17-March 1, 2022 (39 tickets). Tickets from DAILY quests: 2 from Battlegrounds or Cyrodiil, plus 1 from Imperial City; per account per day.",

	EVT_PTS_INFO_ANNIVERSARY = "PTS: Feb. 12-19, 2024.; Live: April. 3 tickets acquired once per day per account from eating Anniversary Cake. (Cake is a TOOL.) XP IS PASSIVE NOW!",
--	EVT_PTS_INFO_ANNIVERSARY = "PTS: Feb. 13-20; Live: Probably Apr. 6-18, 2023. 3 tickets acquired once per day per account from eating Anniversary Cake. (Cake is a TOOL now!)",
	EVT_EVENT_INFO_ANNIVERSARY = "EU: Apr. 4-25, 2024. NA: Apr. 4-24, 2024.  3 tickets acquired once per day per account from eating 2024 Anniversary Cake. XP IS PASSIVE NOW!",
--	EVT_EVENT_INFO_ANNIVERSARY = "April 6-18, 2023 (39 tickets). 3 tickets acquired once per day per account from eating Anniversary Cake. (Cake is a TOOL now!)",
--	EVT_EVENT_INFO_ANNIVERSARY = "April 7-19, 2022 (39 tickets). 3 tickets acquired once per day per account from eating Anniversary Cake. (Cake is a TOOL now!)",
--	EVT_EVENT_INFO_ANNIVERSARY = "April 1-15, 2021 (45 tickets). 3 tickets acquired once per day per account from eating Anniversary Cake. (Cake is a TOOL now!)",
--	EVT_EVENT_INFO_ANNIVERSARY = "April 2-14, 2020 (65 tickets). 3 tickets available per day per account from eating Anniversary Cake. Plus 2 additional tickets per day per account from a world or public dungeon boss, or the final boss of a delve, dark fissure, dolmen/geyser/dragon/harrowstorm, group dungeon, arena, or trial. Quest bosses may also work. ALWAYS LOOT BODIES/REWARD CHESTS!",
	EVT_PTS_INFO_JESTER = "PTS: Feb. 5-12, 2024; Live: Late March. 3 tickets per day per account from turning in your first Jester's daily. XP IS PASSIVE NOW!",
--	EVT_PTS_INFO_JESTER = "PTS: Feb. 6-13; Live: March 29-Apr. 6. 3 tickets per day per account from turning in your first Jester's daily. Eat pie (TOOL) for a 2-hr xp buff!",
	EVT_EVENT_INFO_JESTER = "March 28-Apr. 4, 2024 (21 tickets). 3 tickets per day per account from turning in your first Jester's daily. XP IS PASSIVE NOW!",
--	EVT_EVENT_INFO_JESTER = "March 29-Apr. 6, 2023 (24 tickets). 3 tickets per day per account from turning in your first Jester's daily. Eat pie (TOOL) for a 2-hr xp buff!",
--	EVT_EVENT_INFO_JESTER = "March 31-Apr. 7, 2022 (39 tickets). 3 tickets per day per account from turning in your first Jester's daily. Eat pie (TOOL) for a 2-hr xp buff!",
--	EVT_EVENT_INFO_JESTER = "March 25-Apr. 1, 2021 (24 tickets). 3 tickets per day per account from turning in your first Jester's daily. Eat pie (TOOL) for a 2-hr xp buff!",
--	EVT_EVENT_INFO_JESTER = "March 26-April 2, 2020 (24 tickets). Collect all 3 tickets once per day per account from turning in your first Jester's daily quest.",
	PTS_EVENT_INFO_WITCHES = "PTS: July 24-31; Live: October, 2024. 2 tickets, once/day/acct: World or pub dungeon boss; FINAL boss of delve, dark fissure, dolmen/dragon/etc, dungeon, arena, or trial. XP buff is PASSIVE NOW!!",
	EVT_EVENT_INFO_WITCHES = "Oct. 24-Nov. 6, 2024 (28 tickets). 2 tickets, once/day/acct: World or pub dungeon boss; FINAL boss of delve, dark fissure, dolmen/dragon/etc, dungeon, arena, or trial. DOUBLE XP PASSIVE NOW!!",
--	EVT_EVENT_INFO_WITCHES = "Oct. 26-Nov. 7, 2023 (26 tickets). 2 tickets, once/day/acct: World or pub dungeon boss; FINAL boss of delve, dark fissure, dolmen/dragon/etc, dungeon, arena, or trial. DOUBLE XP PASSIVE NOW!!",
--	EVT_EVENT_INFO_WITCHES = "Oct. 20-Nov. 2, 2022 (28 tickets). 2 tickets, once/day/acct: World or pub dungeon boss; FINAL boss of delve, dark fissure, dolmen/dragon/etc, dungeon, arena, or trial. ALWAYS LOOT BODIES/REWARD CHESTS! Use Witchmother's TOOL for xp!",
	EVT_EVENT_INFO_UNDAUNTED = "Sept. 12-24, 2024 (26 tickets). 2 tickets once per day per account from LOOTING the FINAL boss/reward chest of a GROUP dungeon. Dungeon Finder NOT required.",
--	EVT_EVENT_INFO_UNDAUNTED = "Sept. 7-19, 2023 (26 tickets). 2 tickets once per day per account from LOOTING the FINAL boss/reward chest of a GROUP dungeon. Dungeon Finder NOT required.",
--	EVT_EVENT_INFO_UNDAUNTED = "Sept. 8-20, 2022. (26 tickets) 2 tickets once per day per account from LOOTING the FINAL boss/reward chest of a GROUP dungeon. Dungeon Finder NOT required.",
--	EVT_EVENT_INFO_UNDAUNTED = "Nov. 18-30, 2021. (26 tickets) 2 tickets once per day per account from LOOTING the FINAL boss/reward chest of a GROUP dungeon. Dungeon Finder NOT required.",
	EVT_EVENT_INFO_NEW_LIFE = "Dec. 19, 2024-Jan. 7, 2025. 3 tickets/day/account from turning in your first New Life (or Old Life) daily quest. DOUBLE XP PASSIVE NOW!!",
--	EVT_EVENT_INFO_NEW_LIFE = "Dec. 21, 2023-Jan. 9, 2024. (60 tickets) 3 tickets/day/account from turning in your first New Life (or Old Life) daily quest. DOUBLE XP PASSIVE NOW!!",
--	EVT_EVENT_INFO_NEW_LIFE = "Dec. 15, 2022-Jan. 3, 2023. (60 tickets) 3 tickets/day/account from turning in your first New Life (or Old Life) daily quest. Drink Breda's Mead (TOOL) for a 2-hr xp buff!",
--	EVT_EVENT_INFO_NEW_LIFE = "Dec. 16, 2021-Jan. 4, 2022. (60 tickets) 3 tickets/day/account from turning in your first New Life (or Old Life) daily quest. Drink Breda's Mead (TOOL) for a 2-hr xp buff!",
	EVT_EVENT_INFO_ZEAL_OF_ZENITHAR = "June 20-July 2, 2024 (39 tickets). 3 tickets per day per account, from completing the Honest Toil quest (W of Belkarth, Craglorn).",
--	EVT_EVENT_INFO_ZEAL_OF_ZENITHAR = "July 27-Aug. 9, 2023 (42 tickets). 3 tickets per day per account, from completing the Honest Toil quest (W of Belkarth, Craglorn).",


-- *************** NON-ANNUAL EVENTS
-- 2.240 "Pan-Tamriel"
	EVT_EVENT_INFO_PAN_TAMRIEL = "Jan. 2025. 3 tickets, once/day/acct: World or pub dungeon boss; FINAL boss of delve, dark fissure, dolmen/dragon/etc, dungeon, arena, or trial.",
-- 2.240 "Legacy of the Bretons"
	EVT_EVENT_INFO_BRETONS = "Nov. 21-Dec. 3, 2024. 2 tickets/day/account, from your first High Isle/Tribute or Galen DAILY quest, Dreadsail WEEKLY quest, or the final boss of Coral Aerie, Shipwright's Regret, Earthen Root, or Graven Deep.",
-- 2.240 "Fallen Leaves of the West Weald"
	EVT_EVENT_INFO_WEST_WEALD = "Sept. 26-Oct. 8, 2024. 2 tickets/day/account, from your first Gold Road or event (Gandrinar) DAILY quest, or Lucent Citadel WEEKLY quest.",


-- *************** DEPRECATED EVENTS
-- 2.020 "Secrets of the Telvanni"
	EVT_EVENT_INFO_TELVANNI = "Sept. 28-Oct. 10, 2023. 2 tickets per day per account, from your first Necrom DAILY quest, or Sanity's Edge WEEKLY quest.",
-- 2.020 "Gates of Oblivion Celebration" (Oblivion)
	EVT_EVENT_INFO_OBLIVION = "Nov. 16-29, 2023 (29 tickets). 2 tickets/day/account, from your first Blackwood or Deadlands DAILY quest, Rockgrove WEEKLY quest, or the final boss of Red Petal Bastion, Cauldron, Dread Cellar, or Black Drake Villa.",
-- 2.020 "Guilds and Glory Celebration" (Guilds)
	EVT_EVENT_INFO_GUILDS = "Jan. 18-30, 2024. 2 tickets/day/account, from Wrothgar/Gold Coast/Hew's Bane/IC DAILY, MoL WEEKLY, IC district/sewer bosses, or ICP/WGT/MA final boss.",
-- "Season of the Dragon"
	EVT_EVENT_INFO_DRAGON = "Jan. 26-Feb. 7, 2023. (26 tickets) 2 tickets per day per account: 1 from N. Elsweyr DAILY quest (or Sunspire WEEKLY); plus 1 from S. Elsweyr DAILY.",
-- "Dark Heart of Skyrim"
	EVT_EVENT_INFO_SKYRIM = "Nov. 17-29, 2022. (26 tickets) 2 tickets per day per account: 1 from a Western Skyrim DAILY quest (or Kyne's Aegis WEEKLY); and 1 from a DAILY quest in The Reach. (A Harrowstorm can count for both!)",
	EVT_EVENT_INFO_HIGH_ISLE = "Sept 29-Oct. 11, 2022. (26 tickets) 2 tickets per day per account, from your first High Isle DAILY quest, or Dreadsail Reef WEEKLY quest.",
	EVT_EVENT_INFO_DAEDRIC_WAR = "Jan. 20-Feb. 1, 2022. (26 tickets) 2 tickets/day/account, from zone DAILY or trial WEEKLY quest: 1 Morrowind/HoF OR Clockwork City/AS; PLUS 1 Summerset/CR.",
	EVT_EVENT_INFO_YEAR_ONE = "Aug. 26-Sept. 7, 2021. (26 tickets) Tickets per day per account: 1 from a Craglorn or Wrothgar DAILY quest (or WEEKLY SO/AA/HRC trial); plus 1 from an IC DAILY. (NOT ICP or WGT.)",
	EVT_EVENT_INFO_BLACKWOOD = "Sept. 30-Oct. 12, 2021. (26 tickets) 2 tickets per day per account, from your first Blackwood DAILY quest, or Rockgrove WEEKLY quest.",
	EVT_EVENT_INFO_PAN_ELSWEYR = "July 22-Aug. 3, 2021. (26 tickets) Tickets per day per account: 1 from N. Elsweyr DAILY quest (or Sunspire WEEKLY); plus 1 from S. Elsweyr DAILY.",
	EVT_EVENT_INFO_TRIBUNAL = "Feb. 25-Mar. 9, 2021. (26 tickets) Tickets per day per account: 1 from Morrowind DAILY quest (or HoF WEEKLY); and 1 from Clockwork City DAILY (or Asylum WEEKLY).",
	EVT_EVENT_INFO_IMPERIAL_CITY = "Sept. 3-15, 2020 (39 tickets). Loot 3 tickets per day per account from any DAILY Imperial City quest, or the body of the FINAL BOSS of Imperial City Prison or White Gold Tower.",
	EVT_EVENT_INFO_LOST_TREASURES = "Sept. 23-Oct. 5, 2020 (39 tickets). 3 tickets per day per account, from a Greymoor DAILY quest or Kyne's Aegis WEEKLY.",
	EVT_EVENT_INFO_SUMMERSET = "July 23-Aug. 4, 2020 (39 tickets). 3 tickets per day per account, from a Summerset DAILY quest or Cloudrest WEEKLY.",
	EVT_EVENT_INFO_MURKMIRE = "Feb. 20-March 3, 2020 (39 tickets). Loot 3 tickets once per day per account, that could drop from anything, including other group members who aren't even near you. Recommend not being in a group until you get your tickets.",
	EVT_EVENT_INFO_WROTHGAR = "Aug. 8-19, 2019 (24 tickets). 2 tickets available per day per account for your first daily quest in Wrothgar.",
	EVT_EVENT_INFO_CRIME_PAYS = "July 2-15, 2019 (28 tickets). Tickets per day per account: 1 from a TG Heist, 1 from a DB Black Sacrament.",
	EVT_EVENT_INFO_MORROWIND = "Feb. 7-18, 2019 (24 tickets). Tickets per day per account: 1 from the daily delve quest and 1 from the daily world boss quest, in Vvardenfell.",
	EVT_EVENT_INFO_CLOCKWORK = "Nov. 15-26, 2018 (24 tickets). 2 tickets available per day per account from your first Clockwork City daily quest.",

}

for stringId, stringValue in pairs(strings) do
   ZO_CreateStringId(stringId, stringValue)
   SafeAddVersion(stringId, 1)
end

-- 2.000 Added for localization
--EventTrackerVars = EventTrackerVars or {}

EVT.lang = {
["WARNING"] = "WARNING",
["Tickets"] = "Tickets",
["tickets"] = "tickets",
["Available"] = "Available",

["Next Event"] = "Next Event",
["next"] = "next",
["Event ends"] = "Event Ends",
["EVENT ENDS"] = "EVENT ENDS",
["Final tickets finished"] = "Final tickets finished",
["days"] = "days",
["day"] = "day",
["hrs"] = "hrs",
["hr"] = "hr",
["mins"] = "mins",
["min"] = "min",

-- Date format 1, same month: "Mmm. d-d, yyyy"
["DateFormat1a"] = "%b. %d-",
["DateFormat1b"] = "%d, %Y",

-- Date format 2, different months: "Mmm. d-Mmm. d, yyyy"
["DateFormat2a"] = "%b. %d-",
["DateFormat2b"] = "%b. %d, %Y",

-- Date format Start, only starting date known: "Starts Mmm. d, yyyy"
["DateFormatStart"] = "Begins %b. %d, %Y",

--[[ UserInterface
	["Tickets"]	= "Tickets",
	["Available"]	= "Available",
]]
-- Events

--		A: Anniversary
	["EVENT INFO A"] = {
		["Begin"]	= "Pick up the FREE quest in the Crown Store to start (it doesn't cost anything.) Or look for the baking tent on the docks of Vulkhel Guard, Daggerfall, or Davon's Watch.",
		["Box"]		= "Get boxes from ANY DAILY QUEST, anywhere! (Even crafting!) Also world events like dolmens, dragons, etc. Final bosses of dungeons & trials. Rewards for the Worthy mails and Tribute boxes.",
		["Upcoming"]	= "None known yet.",
		["Info"]	= "3 tickets acquired once per day per account from eating Anniversary Cake. (Cake is a TOOL.) XP IS PASSIVE NOW!",
	},

--		J: Jesters Fest
	["EVENT INFO J"] = {
		["Begin"]	= "Pick up the FREE quest in the Crown Store to start (it doesn't cost anything.) Or go directly to a Jester's tent near Vulkhel Guard, Daggerfall, or south of Ebonheart in Stonefalls. They're marked on the map.",
		["Box"]		= "Get more boxes from Jester's dailies. There are quests at Vulkhel Guard, Daggerfall, and one extra quest that starts at Vivec's Antlers in Stonefall, south of Ebonheart.",
		["Upcoming"]	= "April 4: Anniversary (3). (number)=Tickets per day, per account.",
		["Info"]	= "3 tickets per day per account from turning in your first Jester's daily. XP IS PASSIVE NOW!",
	},

--		M: (Whitestrake's) Mayhem
	["EVENT INFO M"] = {
		["Begin"]	= "Look for Predicant Maera at any Battlegrounds Camp, or at your alliance base camp in Cyrodiil (use the alliance war menu, L, to travel there).",
		["Box"]		= "Get boxes from DAILY Battlegrounds quests, Cyrodiil quests (including towns), and Imperial City quests.",
		["Upcoming"]	= "March: Jester's (3); April: Anniversary (3). (number)=Tickets per day, per account.",
		["Info"]	= "Tickets from DAILY quests: 2 from Battlegrounds or Cyrodiil, plus 1 from Imperial City; per account per day. DOUBLE XP/AP/Tel Var PASSIVE NOW!",
	},

--		N: New Life
	["EVENT INFO N"] = {
		["Begin"]	= "Check Crown Store for FREE starter quest; get one extra purple box per character for the event.",
		["Box"]		= "Additional boxes drop from New Life and Old Life quests; up to 10 boxes total per character per day.",
		["Upcoming"]	= "None known yet.",
		["Info"]	= "3 tickets/day/account from turning in your first New Life (or Old Life) daily quest. DOUBLE XP PASSIVE NOW!!",
	},

--		U: Undaunted
	["EVENT INFO U"] = {
		["Begin"]	= "Pick up the FREE quest in the Crown Store to start (it doesn't cost anything.)",
		["Box"]		= "",
		["Upcoming"]	= "None known yet.",
		["Info"]	= "2 tickets once per day per account from LOOTING the FINAL boss/reward chest of a GROUP dungeon. Dungeon Finder NOT required.",
	},

--		W: Witches Fest
	["EVENT INFO W"] = {
		["Begin"]	= "Pick up the FREE quest in the Crown Store to start (it doesn't cost anything.)",
		["Box"]		= "",
		["Upcoming"]	= "None known yet.",
		["Info"]	= "2 tickets, once/day/acct: World or pub dungeon boss; FINAL boss of delve, dark fissure, dolmen/dragon/etc, dungeon, arena, or trial. DOUBLE XP PASSIVE NOW!!",
	},

--		Z: Zeal of Zenithar
	["EVENT INFO Z"] = {
		["Begin"]	= "Pick up the FREE quest in the Crown Store to start (it doesn't cost anything.)",
		["Box"]		= "",
		["Upcoming"]	= "None known yet.",
		["Info"]	= "3 tickets per day per account, from completing the Honest Toil quest (W of Belkarth, Craglorn).",
	},

--		Gol: (Gold Road) (I don't know what they'll call this event, but I'm sure there will be one.)
	["EVENT INFO Gol"] = {
		["Begin"]	= "Pick up the FREE quest in the Crown Store to start (it doesn't cost anything.)",
		["Box"]		= "",
		["Upcoming"]	= "None known yet.",
		["Info"]	= "",
	},

--[[ Old special one-time events not expected to return, in order from newest to oldest.
-- Still here just in case they do.
		G&G: Guilds and Glory
	["EVENT INFO G&G"] = {
		["Begin"]	= "Pick up the FREE quest in the Crown Store to start (it doesn't cost anything.)",
		["Box"]		= "",
		["Upcoming"]	= "None known yet.",
		["Info"]	= "",
	},

--		Bla: (Blackwood) Gates of Oblivion
	["EVENT INFO Bla"] = {
		["Begin"]	= "Pick up the FREE quest in the Crown Store to start (it doesn't cost anything.)",
		["Box"]		= "",
		["Upcoming"]	= "None known yet.",
		["Info"]	= "",
	},

--		Nec: (Necrom) Secrets of the Telvanni
	["EVENT INFO Nec"] = {
		["Begin"]	= "Pick up the FREE quest in the Crown Store to start (it doesn't cost anything.)",
		["Box"]		= "",
		["Upcoming"]	= "None known yet.",
		["Info"]	= "",
	},
]]
}
