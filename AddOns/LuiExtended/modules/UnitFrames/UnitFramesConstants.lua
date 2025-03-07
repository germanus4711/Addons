-- -----------------------------------------------------------------------------
--  LuiExtended                                                               --
--  Distributed under The MIT License (MIT) (see LICENSE file)                --
-- -----------------------------------------------------------------------------

--- @class (partial) LuiExtended
local LUIE = LUIE

-- Unit Frames namespace
--- @class (partial) UnitFrames
LUIE.UnitFrames = {}
LUIE.UnitFrames.__index = LUIE.UnitFrames

--- @class (partial) UnitFrames
local UnitFrames = LUIE.UnitFrames

UnitFrames.Enabled = false
UnitFrames.Defaults =
{
    ShortenNumbers = false,
    RepositionFrames = true,
    DefaultOocTransparency = 85,
    DefaultIncTransparency = 85,
    DefaultFramesNewPlayer = 1,
    DefaultFramesNewTarget = 1,
    DefaultFramesNewGroup = 1,
    DefaultFramesNewBoss = 2,
    Format = GetString(LUIE_STRING_UF_FORMAT_DEFAULT),
    DefaultFontFace = GetString(LUIE_STRING_UF_FONT_DEFAULT),
    DefaultFontStyle = GetString(LUIE_STRING_UF_FONT_STYLE_DEFAULT),
    DefaultFontSize = 16,
    DefaultTextColour = { 1, 1, 1 },
    TargetShowClass = true,
    TargetShowFriend = true,
    TargetColourByReaction = false,
    CustomFormatOnePT = GetString(LUIE_STRING_UF_FORMAT_PT_ONE),
    CustomFormatOneGroup = GetString(LUIE_STRING_UF_FORMAT_GROUP_ONE),
    CustomFormatTwoPT = GetString(LUIE_STRING_UF_FORMAT_PT_TWO),
    CustomFormatTwoGroup = GetString(LUIE_STRING_UF_FORMAT_GROUP_TWO),
    CustomFormatRaid = GetString(LUIE_STRING_UF_FORMAT_RAID),
    CustomFormatBoss = GetString(LUIE_STRING_UF_FORMAT_BOSS),
    CustomFontFace = GetString(LUIE_STRING_UF_FONT_DEFAULT),
    CustomFontStyle = GetString(LUIE_STRING_UF_FONT_STYLE_CUSTOM),
    CustomFontBars = 16,
    CustomFontOther = 20,
    CustomTexture = GetString(LUIE_STRING_UF_TEXTURE_DEFAULT),
    HideBuffsPlayerOoc = false,
    HideBuffsTargetOoc = false,
    PlayerOocAlpha = 85,
    PlayerIncAlpha = 85,
    TargetOocAlpha = 85,
    TargetIncAlpha = 85,
    GroupAlpha = 85,
    BossOocAlpha = 85,
    BossIncAlpha = 85,
    CustomOocAlphaPower = true,
    CustomColourHealth = { 202 / 255, 20 / 255, 0 },
    CustomColourShield = { 1, 192 / 255, 0 },
    CustomColourTrauma = { 90 / 255, 0, 99 / 255 },
    CustomColourMagicka = { 0, 83 / 255, 209 / 255 },
    CustomColourStamina = { 28 / 255, 177 / 255, 0 },
    CustomColourInvulnerable = { 95 / 255, 70 / 255, 60 / 255 },
    CustomColourDPS = { 130 / 255, 99 / 255, 65 / 255 },
    CustomColourHealer = { 117 / 255, 077 / 255, 135 / 255 },
    CustomColourTank = { 133 / 255, 018 / 255, 013 / 255 },
    CustomColourDragonknight = { 255 / 255, 125 / 255, 35 / 255 },
    CustomColourNightblade = { 255 / 255, 51 / 255, 49 / 255 },
    CustomColourSorcerer = { 75 / 255, 83 / 255, 247 / 255 },
    CustomColourTemplar = { 255 / 255, 240 / 255, 95 / 255 },
    CustomColourWarden = { 136 / 255, 245 / 255, 125 / 255 },
    CustomColourNecromancer = { 97 / 255, 37 / 255, 201 / 255 },
    CustomColourArcanist = { 90 / 255, 240 / 255, 80 / 255 },
    CustomShieldBarSeparate = false,
    CustomShieldBarHeight = 8,
    CustomShieldBarFull = false,
    CustomSmoothBar = true,
    CustomFramesPlayer = true,
    CustomFramesTarget = true,
    PlayerBarWidth = 300,
    TargetBarWidth = 300,
    PlayerBarHeightHealth = 30,
    PlayerBarHeightMagicka = 28,
    PlayerBarHeightStamina = 28,
    BossBarWidth = 300,
    BossBarHeight = 36,
    HideBarMagicka = false,
    HideLabelMagicka = false,
    HideBarStamina = false,
    HideLabelStamina = false,
    HideLabelHealth = false,
    HideBarHealth = false,
    PlayerBarSpacing = 0,
    TargetBarHeight = 36,
    PlayerEnableYourname = true,
    PlayerEnableAltbarMSW = true,
    PlayerEnableAltbarXP = true,
    PlayerChampionColour = true,
    PlayerEnableArmor = true,
    PlayerEnablePower = true,
    PlayerEnableRegen = true,
    GroupEnableArmor = false,
    GroupEnablePower = false,
    GroupEnableRegen = true,
    RaidEnableArmor = false,
    RaidEnablePower = false,
    RaidEnableRegen = false,
    BossEnableArmor = false,
    BossEnablePower = false,
    BossEnableRegen = false,
    TargetEnableClass = false,
    TargetEnableRank = true,
    TargetEnableRankIcon = true,
    TargetTitlePriority = GetString(LUIE_STRING_UF_TITLE_PRIORITY),
    TargetEnableTitle = true,
    TargetEnableSkull = true,
    CustomFramesGroup = true,
    GroupExcludePlayer = false,
    GroupBarWidth = 260,
    GroupBarHeight = 36,
    GroupBarSpacing = 40,
    CustomFramesRaid = true,
    RaidNameClip = 94,
    RaidBarWidth = 220,
    RaidBarHeight = 30,
    RaidLayout = GetString(LUIE_STRING_UF_RAID_LAYOUT),
    RoleIconSmallGroup = true,
    ColorRoleGroup = true,
    ColorRoleRaid = true,
    SortRoleRaid = true,
    ColorClassGroup = false,
    ColorClassRaid = false,
    RaidSpacers = false,
    CustomFramesBosses = true,
    AvaCustFramesTarget = false,
    AvaTargetBarWidth = 450,
    AvaTargetBarHeight = 36,
    Target_FontColour = { 1, 1, 1 },
    Target_FontColour_FriendlyNPC = { 0, 1, 0 },
    Target_FontColour_FriendlyPlayer = { 0.7, 0.7, 1 },
    Target_FontColour_Hostile = { 1, 0, 0 },
    Target_FontColour_Neutral = { 1, 1, 0 },
    Target_Neutral_UseDefaultColour = true,
    ReticleColour_Interact = { 1, 1, 0 },
    ReticleColourByReaction = false,
    DisplayOptionsPlayer = 2,
    DisplayOptionsTarget = 2,
    DisplayOptionsGroupRaid = 2,
    ExecutePercentage = 20,
    RaidIconOptions = 2,
    RepositionFramesAdjust = 0,
    PlayerFrameOptions = 1,
    AdjustStaminaHPos = 200,
    AdjustStaminaVPos = 0,
    AdjustMagickaHPos = 200,
    AdjustMagickaVPos = 0,
    FrameColorReaction = false,
    FrameColorClass = false,
    CustomColourPlayer = { 178 / 255, 178 / 255, 1 },
    CustomColourFriendly = { 0, 1, 0 },
    CustomColourHostile = { 1, 0, 0 },
    CustomColourNeutral = { 150 / 255, 150 / 255, 150 / 255 },
    CustomColourGuard = { 95 / 255, 70 / 255, 60 / 255 },
    CustomColourCompanionFrame = { 0, 1, 0 },
    LowResourceHealth = 25,
    LowResourceStamina = 25,
    LowResourceMagicka = 25,
    ShieldAlpha = 50,
    ResolutionOptions = 1,
    ReverseResourceBars = false,
    CustomFramesPet = true,
    CustomFormatPet = GetString(LUIE_STRING_UF_FORMAT_PET),
    CustomColourPet = { 202 / 255, 20 / 255, 0 },
    PetHeight = 30,
    PetWidth = 220,
    PetUseClassColor = false,
    PetIncAlpha = 85,
    PetOocAlpha = 85,
    whitelist = {}, -- Whitelist for pet names
    PetNameClip = 88,
    CustomFramesCompanion = true,
    CustomFormatCompanion = GetString(LUIE_STRING_UF_FORMAT_COMPANION),
    CustomColourCompanion = { 202 / 255, 20 / 255, 0 },
    CompanionHeight = 30,
    CompanionWidth = 220,
    CompanionUseClassColor = false,
    CompanionIncAlpha = 85,
    CompanionOocAlpha = 85,
    CompanionNameClip = 88,
    BarAlignPlayerHealth = 1,
    BarAlignPlayerMagicka = 1,
    BarAlignPlayerStamina = 1,
    BarAlignTarget = 1,
    BarAlignCenterLabelPlayer = false,
    BarAlignCenterLabelTarget = false,
    CustomFormatCenterLabel = GetString(LUIE_STRING_UF_FORMAT_CENTER_LABEL),
    CustomTargetMarker = false,
}


--- @class (partial) LUIE_UnitFrames_SV
UnitFrames.SV = {}

UnitFrames.CustomFrames = {}
UnitFrames.CustomFramesMovingState = false
