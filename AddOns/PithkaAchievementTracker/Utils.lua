-- Initialize file
PITHKA       = PITHKA or {}
PITHKA.Utils = {}

-- return unique id
function PITHKA.Utils.uid()
    PITHKA.Utils.uidCurrent = (PITHKA.Utils.uidCurrent or 10000) + 1
    return PITHKA.Utils.uidCurrent
end

-- converts t[key]=value into t[index]={key,value} sorted by value
-- access return with "for _,r in ipairs(sorted) do ... key=r[1]; val=r[2]"
function PITHKA.Utils.sortByValues(t)
    local sorted = {}
    for k, v in pairs(t) do
        table.insert(sorted,{k,v})
    end
    table.sort(sorted, function(a,b) return a[2] > b[2] end)
    return sorted
end


-- checks for value in array
function PITHKA.Utils.valueInArray(value, array)
    for _, val in ipairs(array) do
        if val == value then return true end
    end
    return false
end

------------------------------------------------------------------------------------------------------------------
-- ID lookup functions for dev
------------------------------------------------------------------------------------------------------------------

-- Oct 30, 2023
function PITHKA.Utils.showLeaderboard()
    for n = 1, 100 do
        local name = GetRaidLeaderboardName(n)
        if name ~= "" and name~=nil then
            d("LBINDEX=" .. n .. " Name: " .. name)
        end
    end
end


function PITHKA.Utils.showEndless()
    for n = 0, 5 do -- Note this doesn't really work, no matter what n you put into the function it only returns a single score
        local rank, bestScoreSolo = GetEndlessDungeonLeaderboardLocalPlayerInfo(ENDLESS_DUNGEON_GROUP_TYPE_SOLO, n) -- first and currently only endless dungeon is ID 0
        local rank, bestScoreDuo = GetEndlessDungeonLeaderboardLocalPlayerInfo(ENDLESS_DUNGEON_GROUP_TYPE_DUO, n) -- first and currently only endless dungeon is ID 0
        d("endless ID:" .. n .. " score Solo:" .. (bestScoreSolo or "no_score").." Duo:".. (bestScoreDuo or "no_score"))
    end
end
-- Oct 30, 2023

-- print normal group  finder dungeon ids
function PITHKA.Utils.showVetDungeon()
    for n = 1, 60 do
        local id = GetActivityIdByTypeAndIndex(LFG_ACTIVITY_MASTER_DUNGEON, n)
        local name = GetActivityName(id)
        d(tostring(id)..', '..name)
    end
end

-- print vet dungeon group finder ids
function PITHKA.Utils.showNormDungeon()
    for n = 1, 60 do
        local id = GetActivityIdByTypeAndIndex(LFG_ACTIVITY_DUNGEON, n)
        local name = GetActivityName(id)
        d(tostring(id)..', '..name)
    end
end



function PITHKA.Utils.dumpAllDungeonAndTrialPortIds()

    -- to use this command enter this in game
    -- /script PITHKA.Utils.dumpAllDungeonAndTrialPortIds()


    -- use this command in game to explore a travel node ID
    -- /script d(GetFastTravelNodeInfo(331))


    local descr = ""
    for id=1,GetNumFastTravelNodes(),1 do -- 1000 is arbitrarily large to cover all possible wayshrines in the game
        local known, name, x, y, textureIcon, glowIcon, poiType, currentMap, collectibleIsLocked = GetFastTravelNodeInfo(id)
        if known then
            -- POI_TYPE_ACHIEVEMENT for trials
            -- POI_TYPE_GROUP_DUNGEON for dungeons
            -- others: POI_TYPE_WAYSHRINE, POI_TYPE_HOUSE
            if  poiType == POI_TYPE_GROUP_DUNGEON or poiType == POI_TYPE_ACHIEVEMENT then
                d("FastTravelToNode("..id..") --> "..name)
            end
        end
    end
end

-- Oct 30, 2023

-- table used to fix mappings to common abbreviations and fix issues with Achivement table
-- common Abbr, Achivement Abbv, Port Id, Name
PITHKA.Utils.abbvMapping = {
["IA"]   = {"EA1", nil, "Infinity Archive"},
["EA"]   = {"EA1", nil, "Infinity Archive"},
["EA1"]  = {  nil, nil, "Infinity Archive"}, -- needed because the name is Solo
["EA2"]  = {  nil, nil, "Infinity Archive"}, -- needed because the name is Duo
["SCP"]  = { "SP", nil, nil},
["MA"]   = {"MSA", nil, nil},
["VH"]   = {"VSA", nil, nil},
["BRF"]  = { "BF", nil, nil},
["MGF"]  = { "MF", nil, nil},
["SWR"]  = { "SR", nil, nil},
["ARX"]  = { "AC", nil, nil},
["DFK"]  = { "DK", nil, nil},
["BHH"]  = { "BH", nil, nil},
["BRP"]  = {  nil, 378, "Blackrose Prison"},-- needed because BRP has two entries and returns a table
}

function PITHKA.Utils.Teleport(tp_target)
    tp_target = string.upper(tp_target)
    local override = PITHKA.Utils.abbvMapping[tp_target]


    -- get abbreviation from override if it exists
    local abbreviation = (override and override[1]) or tp_target

    -- use abbreviation to get data from main table
    local data = PITHKA.Data.Achievements.DBFilter({ABBV=abbreviation})

    -- extract useful values, using override if they exist
    local portID = (override and override[2]) or (data and data['portID'])
    local name = (override and override[3]) or (data and data['NAME'])


    if portID == nil then
        d("Invalid teleport location")
    else
        d("Pithka's teleporting you to ".. name)
        FastTravelToNode(portID)
    end
end
-- Oct 30, 2023