-- Initialize File
PITHKA = PITHKA or {}
PITHKA.Data = PITHKA.Data or {}
PITHKA.Data.Scores = {}


PITHKA.GlobalMaxRaidId = 17 -- Oct 30, 2023
PITHKA.GlobalMaxEndlessId = 5 -- Oct 30, 2023


function PITHKA.Data.Scores.lbQuery()
    -- API is weird af
    -- claims to be QueryRaidLeaderboardData(raidCategory, raidId, classId)
    -- however everything has a unique raidId so can simply increment through the numbers
    QueryRaidLeaderboardData(0, 1)

    QueryEndlessDungeonLeaderboardData(ENDLESS_DUNGEON_GROUP_TYPE_SOLO, 0, 1) -- Oct 30, 2023
end
    

------------------------------------------------------------------------------------------------------------------
-- LEADERBOARD SCORE CHECKS
------------------------------------------------------------------------------------------------------------------
function PITHKA.Data.Scores.lbCallback(event, raidCategory, raidId, classId)
    local _, bestScore = GetRaidLeaderboardLocalPlayerInfo(raidId)
    local abbv  = PITHKA.Data.Achievements.DBFilter({LBINDEX=raidId}, 'ABBV')
    if bestScore and bestScore > 0 then
        PITHKA.Data.Scores.setScore(abbv, bestScore)
    end

    --d('debug - callback' ..', '.. raidCategory ..', '.. raidId ..', '.. (abbv or 'no_ABBV') ..', '.. (bestScore or 'no_SCORE'))
    local nextRaidId = raidId + 1
    if nextRaidId <= PITHKA.GlobalMaxRaidId then 
        QueryRaidLeaderboardData(raidCategory, nextRaidId, classId)
    end
end

-- Oct 30, 2023
function PITHKA.Data.Scores.endlesslbCallback(endlessDungeonGroupType, endlessDungeonId, classId)
    local _, bestScoreSolo = GetEndlessDungeonLeaderboardLocalPlayerInfo(ENDLESS_DUNGEON_GROUP_TYPE_SOLO, endlessDungeonId)
    local _, bestScoreDuo = GetEndlessDungeonLeaderboardLocalPlayerInfo(ENDLESS_DUNGEON_GROUP_TYPE_DUO, endlessDungeonId)

    local abbvSolo  = PITHKA.Data.Achievements.DBFilter({ENDLESSLBINDEX=endlessDungeonId, GROUPTYPE=ENDLESS_DUNGEON_GROUP_TYPE_SOLO}, 'ABBV')
    local abbvDuo  = PITHKA.Data.Achievements.DBFilter({ENDLESSLBINDEX=endlessDungeonId, GROUPTYPE=ENDLESS_DUNGEON_GROUP_TYPE_DUO}, 'ABBV')

    if bestScoreSolo and bestScoreSolo > 0 then
        PITHKA.Data.Scores.setScore(abbvSolo, bestScoreSolo)
    end

    if bestScoreDuo and bestScoreDuo > 0 then
        PITHKA.Data.Scores.setScore(abbvDuo, bestScoreDuo)
    end

    --d('debug endless solo - callback' ..', '.. ENDLESS_DUNGEON_GROUP_TYPE_SOLO ..', '.. endlessDungeonId ..', '.. (abbvSolo or 'no_ABBV') ..', '.. (bestScoreSolo or 'no_SCORE'))
    --d('debug endless duo - callback' ..', '.. ENDLESS_DUNGEON_GROUP_TYPE_DUO ..', '.. endlessDungeonId ..', '.. (abbvDuo or 'no_ABBV') ..', '.. (bestScoreDuo or 'no_SCORE'))

    -- this method of looping through the endless dungeons doesn't appear to work, anyhow we only have 1 endless dungeon for now
   -- local nextEndlessId = endlessDungeonId + 1
   -- if nextEndlessId <= PITHKA.GlobalMaxEndlessId then
   --     QueryEndlessDungeonLeaderboardData(ENDLESS_DUNGEON_GROUP_TYPE_SOLO, nextEndlessId, 1)
   -- end
end
-- Oct 30, 2023



EVENT_MANAGER:RegisterForEvent(PITHKA.name, EVENT_RAID_LEADERBOARD_DATA_RECEIVED, PITHKA.Data.Scores.lbCallback)
EVENT_MANAGER:RegisterForEvent(PITHKA.name, EVENT_ENDLESS_DUNGEON_LEADERBOARD_DATA_RECEIVED, PITHKA.Data.Scores.endlesslbCallback) -- Oct 30, 2023


-- sets score but keeps highest
function PITHKA.Data.Scores.setScore(abbv, score)
    -- initialize data structure with abbr and playername
    local name = GetUnitName("player")
    if abbv ~=nil and PITHKA.SV ~= nil and PITHKA.SV.scores ~=nil then -- Oct 30, 2023 prevents a situation when a /reloadui gets here before we load scores
        PITHKA.SV.scores[abbv] = PITHKA.SV.scores[abbv] or {}
        -- record if best score OR score is nil
        if (PITHKA.SV.scores[abbv][name] == nil) or (score > PITHKA.SV.scores[abbv][name]) then
            PITHKA.SV.scores[abbv][name] = score
        end
    end
end

-- resets scores in case of bugs
function PITHKA.Data.Scores.resetScore(abbv, account_wide)
    if account_wide then
        PITHKA.SV.scores[abbv] = nil
    else
        local name = GetUnitName("player")
        PITHKA.SV.scores[abbv][name] = nil
    end
end
------------------------------------------------------------------------------------------------------------------
-- LEADERBOARD SCORE CHECKS
------------------------------------------------------------------------------------------------------------------

function PITHKA.Data.Scores.OnTrialComplete(eventCode, trialName, score, totalTime)
    local altTrialName = string.sub(trialName,1,-11) -- drop "(Veteran)" for match
    local row = PITHKA.Data.Achievements.DBFilter{NAME=trialName} or PITHKA.Data.Achievements.DBFilter{NAME=altTrialName} -- test both names
    
    if row then -- to do - row look up fails in other languages
        PITHKA.Data.Scores.setScore(row.ABBV, score)
    end
end

EVENT_MANAGER:RegisterForEvent(PITHKA.name, EVENT_RAID_TRIAL_COMPLETE, PITHKA.Data.Scores.OnTrialComplete);

------------------------------------------------------------------------------------------------------------------
-- ACCESS FUNCTIONS FOR CONTROLS
------------------------------------------------------------------------------------------------------------------

function PITHKA.Data.Scores.getBestScoreString(abbv)
    local scoreString
    if not PITHKA.SV.scores[abbv] then
        scoreString = '0'
    else
        local sortedScores = PITHKA.Utils.sortByValues(PITHKA.SV.scores[abbv])
        local scoreInt = sortedScores and sortedScores[1] and sortedScores[1][2] or 0 --[1] for first item, [2] for score in {toon,score}
        scoreString = ZO_LocalizeDecimalNumber(scoreInt) -- adds commma
    end
    return zo_strformat(string.format("|c%06X%s|r","0xc5c29e","<<1>>"), scoreString)
end

function PITHKA.Data.Scores.getAllScoresString(abbv)
    local s 
    if PITHKA.SV.scores[abbv] then 
        s = 'SCORES BY CHARACTER\n'
        local sortedScores = PITHKA.Utils.sortByValues(PITHKA.SV.scores[abbv])  -- converts t[key]=value into t[index]={key,value} sorted by value
        for _,r in ipairs(sortedScores) do 
            local toon  = r[1]
            local score =  ZO_LocalizeDecimalNumber(r[2])
            s = s .. '\n' .. string.rep(' ',10-#score) .. score .. '    ' .. toon  
        end
    else
        s = 'NO SCORES RECORDED'
    end
    return s
end

---------------------------------------------------------------------------------------------------------
--  Remove old toons
---------------------------------------------------------------------------------------------------------

function PITHKA.Data.Scores.checkForToonRenames()
    -- create table of current toons on current server
    local currentToons = {}
    for i=1,GetNumCharacters() do
      local name = string.gmatch(GetCharacterInfo(i),'[^\^]+')() -- lots of info returned, name is first
      currentToons[#currentToons+1] = name
    end
  
    -- save current toons by server
    PITHKA.SV.currentToons = PITHKA.SV.currentToons or {}
    PITHKA.SV.currentToons[GetWorldName()] = currentToons
  
    -- build unioned list of toon
    local unionedToons = {}
    for server,toons in pairs(PITHKA.SV.currentToons) do
      for _, t in ipairs(toons) do
        -- d(server .. ' : '.. t) -- for debugging
        unionedToons[#unionedToons+1] = t
      end
    end
  
    for abbv, toonList in pairs(PITHKA.SV.scores) do
        for toon, score in pairs(toonList) do
            if not PITHKA.Utils.valueInArray(toon, unionedToons) then
                PITHKA.SV.scores[abbv][toon] = nil
            end
        end
    end
end


function PITHKA.Data.Scores.OnEndlessNewBestScore(endlessDungeonName, score)
    --d("EVENT - EVENT_ENDLESS_DUNGEON_NEW_BEST_SCORE")
    --d("endlessDungeonName - "..endlessDungeonName)
    --d("score - "..tostring(score)) -- score seems to always be blank


    if endlessDungeonName == 131824 then -- 131824 appears to be the id for Endless Archive
        local _, bestScoreSolo = GetEndlessDungeonLeaderboardLocalPlayerInfo(ENDLESS_DUNGEON_GROUP_TYPE_SOLO, nil) -- dungeonID = nil? seems to work since we aren't given the ID
        local _, bestScoreDuo = GetEndlessDungeonLeaderboardLocalPlayerInfo(ENDLESS_DUNGEON_GROUP_TYPE_DUO, nil) -- dungeonID = nil? seems to work since we aren't given the ID

        --d("bestScoreSolo - "..bestScoreSolo)
        --d("bestScoreDuo - "..bestScoreDuo)

        local abbvSolo  = PITHKA.Data.Achievements.DBFilter({ENDLESSLBINDEX=0, GROUPTYPE=ENDLESS_DUNGEON_GROUP_TYPE_SOLO}, 'ABBV')
        local abbvDuo  = PITHKA.Data.Achievements.DBFilter({ENDLESSLBINDEX=0, GROUPTYPE=ENDLESS_DUNGEON_GROUP_TYPE_DUO}, 'ABBV')

        if bestScoreSolo and bestScoreSolo > 0 then
            PITHKA.Data.Scores.setScore(abbvSolo, bestScoreSolo)
        end

        if bestScoreDuo and bestScoreDuo > 0 then
            PITHKA.Data.Scores.setScore(abbvDuo, bestScoreDuo)
        end
    else
        d("PAT: New Endless Dungeon ID found ".. endlessDungeonName)
    end



end

EVENT_MANAGER:RegisterForEvent(PITHKA.name, EVENT_ENDLESS_DUNGEON_NEW_BEST_SCORE, PITHKA.Data.Scores.OnEndlessNewBestScore)