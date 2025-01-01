-----------------------------------------------------------
-- CrutchAlerts
-- @author Kyzeragon
-----------------------------------------------------------

CrutchAlerts = CrutchAlerts or {}
local Crutch = CrutchAlerts
Crutch.name = "CrutchAlerts"
Crutch.version = "1.6.4"

Crutch.registered = {
    begin = false,
    test = false,
    enemy = false,
    others = false,
    interrupts = false,
}

Crutch.unlock = false

-- Defaults
local defaultOptions = {
    display = {
        x = 0,
        y = GuiRoot:GetHeight() / 3,
    },
    damageableDisplay = {
        x = 0,
        y = GuiRoot:GetHeight() / 5,
    },
    spearsDisplay = {
        x = GuiRoot:GetWidth() / 4,
        y = 0,
    },
    cursePadsDisplay = {
        x = GuiRoot:GetWidth() / 4,
        y = GuiRoot:GetHeight() / 4,
    },
    bossHealthBarDisplay = {
        x = -GuiRoot:GetWidth() / 4,
        y = -100,
    },
    debugLine = false,
    debugChatSpam = false,
    debugOther = false,
    debugUi = false,
    showSubtitles = false,
    subtitlesIgnoredZones = {},
    prominentV2FirstTime = true,
    general = {
        showBegin = true,
            beginHideSelf = false,
        beginHideArcanist = false,
        showGained = true,
        showOthers = true,
        showProminent = true,
        hitValueBelowThreshold = 75,
            hitValueUseWhitelist = true,
        hitValueAboveThreshold = 60000, -- nothing above 1 minute... right?
        useNonNoneBlacklist = true,
        useNoneBlacklist = true,
        showDamageable = true,
        showRaidDiag = false,
    },
    bossHealthBar = {
        enabled = true,
        firstTime = false,
        scale = 1,
        useFloorRounding = true,
    },
    asylumsanctorium = {
        dingSelfCone = true,
        dingOthersCone = false,
    },
    cloudrest = {
        showSpears = true,
        spearsSound = true,
        deathIconColor = true,
        showFlaresSides = true,
    },
    dreadsailreef = {
        alertStaticStacks = true,
        staticThreshold = 7,
        alertVolatileStacks = true,
        volatileThreshold = 6,
    },
    hallsoffabrication = {
        showTripletsIcon = true,
        tripletsIconSize = 150,
        showAGIcons = true,
        agIconsSize = 150,
    },
    kynesaegis = {
        showSpearIcon = true,
        showPrisonIcon = true,
        showFalgravnIcons = true,
        falgravnIconsSize = 150,
    },
    lucentcitadel = {
        alertDarkness = true,
        showKnotTimer = true,
        showCavotIcon = true,
        cavotIconSize = 100,
        showOrphicIcons = true,
        orphicIconsNumbers = false,
        orphicIconSize = 150,
        showWeakeningCharge = "TANK", -- "NEVER", "TANK", "ALWAYS"
        showTempestIcons = true,
        tempestIconsSize = 150,
        showArcaneConveyance = true,
        showArcaneConveyanceTether = true,
    },
    rockgrove = {
        sludgeSides = true,
    },
    sanitysedge = {
        showAnsuulIcon = true,
        ansuulIconSize = 150,
    },
    sunspire = {
        showLokkIcons = true,
        lokkIconsSize = 150,
        lokkIconsSoloHeal = false,
        showYolIcons = true,
        yolLeftIcons = false,
        yolIconsSize = 150,
    },
    mawoflorkhaj = {
        showPads = true,
        showZhajIcons = true,
        zhajIconSize = 150,
        prominentColorSwap = true,
    },
    maelstrom = {
        normalDamageTaken = false,
        showRounds = true,
        stage1Boss = "Equip boss setup!",
        stage2Boss = "Equip boss setup!",
        stage3Boss = "Equip boss setup!",
        stage4Boss = "Equip boss setup!",
        stage5Boss = "Equip boss setup!",
        stage6Boss = "Equip boss setup!",
        stage7Boss = "Equip boss setup!",
        stage8Boss = "",
        stage9Boss = "Equip boss setup!",
    },
    blackrose = {
        showCursed = true, -- Not used, just a placeholder. Not sure if I can put it in prominent V2
    },
    dragonstar = {
        normalDamageTaken = false,
    },
    endlessArchive = {
        markFabled = true,
        markNegate = false,
        dingUppercut = false,
        dingDangerous = true,
        potionIcon = true,
    },
    vateshran = {
        showMissedAdds = false,
    },
    shipwrightsRegret = {
        showBombStacks = true,
    },
}
Crutch.defaultOptions = defaultOptions

local zoneUnregisters = {}
local zoneRegisters = {}

local crutchLFCPFilter = nil

---------------------------------------------------------------------
function CrutchAlerts:SavePosition()
    local x, y = CrutchAlertsContainer:GetCenter()
    local oX, oY = GuiRoot:GetCenter()
    -- x is the offset from the center
    Crutch.savedOptions.display.x = x - oX
    Crutch.savedOptions.display.y = y

    x, y = CrutchAlertsDamageable:GetCenter()
    Crutch.savedOptions.damageableDisplay.x = x - oX
    Crutch.savedOptions.damageableDisplay.y = y - oY

    x, y = CrutchAlertsCloudrest:GetCenter()
    Crutch.savedOptions.spearsDisplay.x = x - oX
    Crutch.savedOptions.spearsDisplay.y = y - oY

    x, y = CrutchAlertsMawOfLorkhaj:GetCenter()
    Crutch.savedOptions.cursePadsDisplay.x = x - oX
    Crutch.savedOptions.cursePadsDisplay.y = y - oY

    x = CrutchAlertsBossHealthBarContainer:GetLeft()
    y = CrutchAlertsBossHealthBarContainer:GetTop()
    Crutch.savedOptions.bossHealthBarDisplay.x = x - oX
    Crutch.savedOptions.bossHealthBarDisplay.y = y - oY
end

---------------------------------------------------------------------
function Crutch.dbgOther(text)
    if (Crutch.savedOptions.debugOther) then
        d("|c88FFFF[CO]|r " .. tostring(text))
    end
end

function Crutch.dbgSpam(text)
    if (Crutch.savedOptions.debugChatSpam) then
        if (crutchLFCPFilter) then
            crutchLFCPFilter:AddMessage(text)
        else
            d(text)
        end
    end
end

---------------------------------------------------------------------
-- Zone change
---------------------------------------------------------------------
local function OnPlayerActivated()
    -- clear the caches
    Crutch.groupIdToTag = {}
    Crutch.groupTagToId = {}
    Crutch.majorCowardiceUnitIds = {}

    local zoneId = GetZoneId(GetUnitZoneIndex("player"))

    -- Unregister previous active trial, if applicable
    if (zoneUnregisters[Crutch.zoneId]) then
        zoneUnregisters[Crutch.zoneId]()
    end
    Crutch.UnregisterProminents(Crutch.zoneId)
    Crutch.UnregisterEffects(Crutch.zoneId)

    -- Register current active trial, if applicable
    if (zoneRegisters[zoneId]) then
        zoneRegisters[zoneId]()
    end
    Crutch.RegisterProminents(zoneId)
    Crutch.RegisterEffects(zoneId)

    Crutch.zoneId = zoneId
end
Crutch.OnPlayerActivated = OnPlayerActivated

---------------------------------------------------------------------
-- First time player activated
---------------------------------------------------------------------
local function OnPlayerActivatedFirstTime()
    EVENT_MANAGER:UnregisterForEvent(Crutch.name .. "ActivatedFirstTime", EVENT_PLAYER_ACTIVATED)

    if (Crutch.savedOptions.bossHealthBar.firstTime) then
        Crutch.BossHealthBar.DisplayWarning()
        Crutch.savedOptions.bossHealthBar.firstTime = false
    end
end

---------------------------------------------------------------------
-- Initialize 
---------------------------------------------------------------------
local function Initialize()
    -- Settings and saved variables
    Crutch.AddProminentDefaults()
    Crutch.AddEffectDefaults()
    Crutch.savedOptions = ZO_SavedVars:NewAccountWide("CrutchAlertsSavedVariables", 1, "Options", defaultOptions)
    if (Crutch.savedOptions.prominentV2FirstTime) then
        Crutch.InitProminentV2Options()
        Crutch.savedOptions.prominentV2FirstTime = false
    end
    Crutch:CreateSettingsMenu()

    -- Position
    CrutchAlertsContainer:SetAnchor(CENTER, GuiRoot, TOP, Crutch.savedOptions.display.x, Crutch.savedOptions.display.y)
    CrutchAlertsDamageable:SetAnchor(CENTER, GuiRoot, CENTER, Crutch.savedOptions.damageableDisplay.x, Crutch.savedOptions.damageableDisplay.y)
    CrutchAlertsCloudrest:SetAnchor(CENTER, GuiRoot, CENTER, Crutch.savedOptions.spearsDisplay.x, Crutch.savedOptions.spearsDisplay.y)
    CrutchAlertsMawOfLorkhaj:SetAnchor(CENTER, GuiRoot, CENTER, Crutch.savedOptions.cursePadsDisplay.x, Crutch.savedOptions.cursePadsDisplay.y)

    -- Register events
    if (Crutch.savedOptions.general.showBegin) then
        Crutch.RegisterBegin()
    end
    if (Crutch.savedOptions.general.showGained) then
        Crutch.RegisterGained()
    end
    if (Crutch.savedOptions.general.showOthers) then
        Crutch.RegisterOthers()
    end

    -- Init general
    Crutch.InitializeHooks()
    Crutch.InitializeDamageable()
    Crutch.InitializeDamageTaken()
    Crutch.RegisterInterrupts()
    Crutch.RegisterTest()
    Crutch.RegisterStacks()
    Crutch.RegisterEffectChanged()
    Crutch.InitializeDebug()
    Crutch.RegisterFatecarver()
    Crutch.InitializeGlobalEvents()

    -- Boss health bar
    Crutch.BossHealthBar.Initialize()

    -- Debug chat panel
    if (LibFilteredChatPanel) then
        crutchLFCPFilter = LibFilteredChatPanel:CreateFilter(Crutch.name, "/esoui/art/ava/ava_rankicon64_volunteer.dds", {0.7, 0.7, 0.5}, false)
    end

    -- I paid once!
    if (HodorReflexes and HodorReflexes.users) then
        HodorReflexes.users["@Kyzeragone"] = {"Kyzeragone", "|c00ff00K|c00cc00y|c00aa00z|c008800e|c006600r|r", "HodorReflexes/users/misc/kyzeragon.dds"}
        HodorReflexes.users["@TheClawlessConqueror"] = {"Clawless", "|c00ff00C|c00ee00l|c00dd00a|c00cc00w|c00bb00l|c00aa00e|c009900s|c008800s|r", "HodorReflexes/users/misc/kyzeragon.dds"}
    end

    -- Register for when entering zone
    EVENT_MANAGER:RegisterForEvent(Crutch.name .. "ActivatedFirstTime", EVENT_PLAYER_ACTIVATED, OnPlayerActivatedFirstTime)
    EVENT_MANAGER:RegisterForEvent(Crutch.name .. "Activated", EVENT_PLAYER_ACTIVATED, OnPlayerActivated)

    zoneUnregisters = {
        -- [635 ] = true,  -- Dragonstar Arena
        -- [636 ] = true,  -- Hel Ra Citadel
        -- [638 ] = true,  -- Aetherian Archive
        -- [639 ] = true,  -- Sanctum Ophidia
        [677 ] = Crutch.UnregisterMaelstromArena,  -- Maelstrom Arena
        [725 ] = Crutch.UnregisterMawOfLorkhaj,  -- Maw of Lorkhaj
        [975 ] = Crutch.UnregisterHallsOfFabrication,  -- Halls of Fabrication
        [1000] = Crutch.UnregisterAsylumSanctorium,  -- Asylum Sanctorium
        [1051] = Crutch.UnregisterCloudrest,  -- Cloudrest
        -- [1082] = true,  -- Blackrose Prison
        [1121] = Crutch.UnregisterSunspire,  -- Sunspire
        [1196] = Crutch.UnregisterKynesAegis,  -- Kyne's Aegis
        [1227] = Crutch.UnregisterVateshran,  -- Vateshran Hollows
        [1263] = Crutch.UnregisterRockgrove,  -- Rockgrove
        [1344] = Crutch.UnregisterDreadsailReef,  -- Dreadsail Reef
        [1427] = Crutch.UnregisterSanitysEdge, -- Sanity's Edge
        [1478] = Crutch.UnregisterLucentCitadel,  -- Lucent Citadel

        [1436] = Crutch.UnregisterEndlessArchive, -- Endless Archive

        [1302] = Crutch.UnregisterShipwrightsRegret, -- Shipwright's Regret
        [1471] = Crutch.UnregisterBedlamVeil, -- Bedlam Veil
    }

    zoneRegisters = {
        -- [635 ] = true,  -- Dragonstar Arena
        -- [636 ] = true,  -- Hel Ra Citadel
        -- [638 ] = true,  -- Aetherian Archive
        -- [639 ] = true,  -- Sanctum Ophidia
        [677 ] = Crutch.RegisterMaelstromArena,  -- Maelstrom Arena
        [725 ] = Crutch.RegisterMawOfLorkhaj,  -- Maw of Lorkhaj
        [975 ] = Crutch.RegisterHallsOfFabrication,  -- Halls of Fabrication
        [1000] = Crutch.RegisterAsylumSanctorium,  -- Asylum Sanctorium
        [1051] = Crutch.RegisterCloudrest,  -- Cloudrest
        -- [1082] = true,  -- Blackrose Prison
        [1121] = Crutch.RegisterSunspire,  -- Sunspire
        [1196] = Crutch.RegisterKynesAegis,  -- Kyne's Aegis
        [1227] = Crutch.RegisterVateshran,  -- Vateshran Hollows
        [1263] = Crutch.RegisterRockgrove,  -- Rockgrove
        [1344] = Crutch.RegisterDreadsailReef,  -- Dreadsail Reef
        [1427] = Crutch.RegisterSanitysEdge, -- Sanity's Edge
        [1478] = Crutch.RegisterLucentCitadel,  -- Lucent Citadel

        [1436] = Crutch.RegisterEndlessArchive, -- Endless Archive

        [1302] = Crutch.RegisterShipwrightsRegret, -- Shipwright's Regret
        [1471] = Crutch.RegisterBedlamVeil, -- Bedlam Veil
    }
end


---------------------------------------------------------------------
-- On load
local function OnAddOnLoaded(_, addonName)
    if addonName == Crutch.name then
        EVENT_MANAGER:UnregisterForEvent(Crutch.name, EVENT_ADD_ON_LOADED)
        Initialize()
    end
end
 
EVENT_MANAGER:RegisterForEvent(Crutch.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)

