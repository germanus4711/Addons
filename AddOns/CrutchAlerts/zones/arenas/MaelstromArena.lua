CrutchAlerts = CrutchAlerts or {}
local Crutch = CrutchAlerts

---------------------------------------------------------------------
-- Stages keyed by map ID (not the same as zone ID!)
---------------------------------------------------------------------
local stagesData = {
    [988] = { -- Vale of the Surreal
        stage = 1,
        numRounds = 4,
    },
    [963] = { -- Seht's Balcony
        stage = 2,
        numRounds = 4,
    },
    [978] = { -- Drome of Toxic Shock
        stage = 3,
        numRounds = 4,
    },
    [970] = { -- Seht's Flywheel
        stage = 4,
        numRounds = 4,
    },
    [976] = { -- Rink of Frozen Blood
        stage = 5,
        numRounds = 5,
    },
    [973] = { -- Spiral Shadows
        stage = 6,
        numRounds = 5,
    },
    [987] = { -- Vault of Umbrage
        stage = 7,
        numRounds = 5,
    },
    [986] = { -- Igneous Cistern
        stage = 8,
        numRounds = 5,
    },
    [985] = { -- Theater of Despair
        stage = 9,
        numRounds = 6,
    },
}

---------------------------------------------------------------------
-- On announcement
---------------------------------------------------------------------
local function OnCSA(_, title, description)
    if (not Crutch.savedOptions.maelstrom.showRounds) then return end

    local round = string.match(title, "^.+%s(%d)$")
    if (round) then
        round = tonumber(round)
        local stageData = stagesData[GetCurrentMapId()]
        local stage = stageData.stage

        CHAT_SYSTEM:AddMessage(string.format("|c3bdb5e[CrutchAlerts] |cAAAAAAStage |cFFFFFF%d|cAAAAAA, Round |cFFFFFF%d|r",
            stage, round))

        if (round == stageData.numRounds - 1) then
            -- Display message for final round next
            zo_callLater(function()
                local extraText = Crutch.savedOptions.maelstrom["stage" .. stage .. "Boss"]
                CHAT_SYSTEM:AddMessage(string.format("|c3bdb5e[CrutchAlerts] |cAAAAAAFinal round soonTM!%s|r",
                    (extraText ~= "") and (" |cFF00FF" .. extraText) or ""))
            end, 15000)
        end
    end
end


---------------------------------------------------------------------
-- Register/Unregister
---------------------------------------------------------------------
function Crutch.RegisterMaelstromArena()
    EVENT_MANAGER:RegisterForEvent(Crutch.name .. "MAAnnouncement", EVENT_DISPLAY_ANNOUNCEMENT, OnCSA)

    Crutch.dbgOther("|c88FFFF[CT]|r Registered Maelstrom Arena")
end

function Crutch.UnregisterMaelstromArena()
    EVENT_MANAGER:UnregisterForEvent(Crutch.name .. "MAAnnouncement", EVENT_DISPLAY_ANNOUNCEMENT)

    Crutch.dbgOther("|c88FFFF[CT]|r Unregistered Maelstrom Arena")
end
