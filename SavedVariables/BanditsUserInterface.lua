BUI_VARS =
{
    ["Default"] = 
    {
        ["@germanus4711"] = 
        {
            ["$AccountWide"] = 
            {
                ["TargetWidth"] = 320,
                ["Meter_Power"] = false,
                ["RaidSplit"] = 0,
                ["TargetBuffs"] = true,
                ["SynergyCdProgress"] = true,
                ["BUI_HPlayerFrame"] = 
                {
                    [4] = 410,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["FramesFade"] = true,
                ["BUI_RaidFrame"] = 
                {
                    [4] = 160,
                    [1] = 3,
                    [2] = 3,
                    [3] = 50,
                },
                ["SynergyCdSize"] = 44,
                ["ZoomImperialsewer"] = 60,
                ["CustomEdgeColor"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.0700000000,
                    [3] = 0.0700000000,
                },
                ["FramesTexture"] = "rounded",
                ["NotificationsTimer"] = 3000,
                ["CustomBar"] = 
                {
                    ["Enable"] = false,
                    ["Slash"] = 
                    {
                        [1] = 
                        {
                            ["command"] = "/reloadui",
                            ["icon"] = "/esoui/art/mounts/ridingskill_ready.dds",
                            ["enable"] = true,
                        },
                        [2] = 
                        {
                            ["command"] = "/script StartChatInput('/z Guild [name] recruits new members!')",
                            ["icon"] = "/esoui/art/icons/ability_warrior_010.dds",
                            ["enable"] = false,
                        },
                        [3] = 
                        {
                            ["command"] = "/dancedunmer",
                            ["icon"] = "/esoui/art/icons/ability_mage_066.dds",
                            ["enable"] = false,
                        },
                        [4] = 
                        {
                            ["command"] = "/script ZO_CompassFrame:SetHidden(not ZO_CompassFrame:IsHidden())",
                            ["icon"] = "/esoui/art/icons/ability_rogue_062.dds",
                            ["enable"] = true,
                        },
                        [5] = 
                        {
                            ["command"] = "/mimewall",
                            ["icon"] = "/esoui/art/icons/emote_mimewall.dds",
                            ["enable"] = false,
                        },
                        [6] = 
                        {
                            ["command"] = "/script UseCollectible(336)",
                            ["icon"] = "/esoui/art/icons/quest_gemstone_tear_0002.dds",
                            ["enable"] = true,
                        },
                        [7] = 
                        {
                            ["command"] = "/jumptoleader",
                            ["icon"] = "/esoui/art/tutorial/gamepad/gp_playermenu_icon_store.dds",
                            ["enable"] = false,
                        },
                        [8] = 
                        {
                            ["command"] = "/script zo_callLater(function() local name=GetUnitDisplayName('reticleover') if name then StartChatInput('/w '..name..' ') else a('No target') end end,100)",
                            ["icon"] = "esoui/art/tutorial/chat-notifications_up.dds",
                            ["enable"] = false,
                        },
                        [9] = 
                        {
                            ["command"] = "/script d(AreAnyItemsStolen(BAG_BACKPACK) and 'Have stolen items' or 'Have no stolen items')",
                            ["icon"] = "/esoui/art/inventory/gamepad/gp_inventory_icon_stolenitem.dds",
                            ["enable"] = false,
                        },
                        [10] = 
                        {
                            ["command"] = "/script local _,i=GetAbilityProgressionXPInfoFromAbilityId(40232) local _,m,r=GetAbilityProgressionInfo(i) local _,_,index=GetAbilityProgressionAbilityInfo(i,m,r) CallSecureProtected('SelectSlotAbility', index, 3)",
                            ["icon"] = "/esoui/art/icons/ability_ava_005_a.dds",
                            ["enable"] = false,
                        },
                        [11] = 
                        {
                            ["command"] = "/script BUI.Vars.EnableWidgets=not BUI.Vars.EnableWidgets BUI.Frames.Widgets_Init() d('Widgets are now '..(BUI.Vars.EnableWidgets and '|c33EE33enabled|r' or '|EE3333disabled|r'))",
                            ["icon"] = "/esoui/art/progression/morph_up.dds",
                            ["enable"] = false,
                        },
                        [12] = 
                        {
                            ["command"] = "/script local text='Another sample'd(text) a(text)",
                            ["icon"] = "Text",
                            ["enable"] = false,
                        },
                    },
                    ["Leader"] = 
                    {
                        [1] = false,
                        [2] = false,
                        [3] = false,
                        [4] = false,
                        [5] = false,
                        [6] = false,
                    },
                },
                ["LastVersion"] = 4.4250000000,
                ["NotificationsTrial"] = true,
                ["QuickSlots"] = true,
                ["ShieldGroup"] = true,
                ["BUI_BuffsPas"] = 
                {
                    [4] = 0,
                    [1] = 12,
                    [2] = 12,
                    [3] = 0,
                },
                ["WidgetSound1"] = "CrownCrates_Manifest_Chosen",
                ["ReticleBoost"] = true,
                ["CollapseNormalDungeon"] = false,
                ["CustomBuffsPWidth"] = 120,
                ["StatShareUlt"] = 3,
                ["ActionsPrecise"] = true,
                ["BossWidth"] = 280,
                ["Theme"] = 2,
                ["RaidSort"] = 1,
                ["FrameTraumaColor"] = 
                {
                    [4] = 1,
                    [1] = 0.5882352941,
                    [2] = 0.1960784314,
                    [3] = 1,
                },
                ["PassiveProgress"] = false,
                ["StatTriggerHeals"] = false,
                ["WidgetsPWidth"] = 120,
                ["ZoomImperialCity"] = 80,
                ["EnableBlackList"] = true,
                ["CustomBuffsProgress"] = true,
                ["ImpactAnimation"] = true,
                ["FrameFontSize"] = 15,
                ["FrameWidth"] = 280,
                ["EnableXPBar"] = true,
                ["QuickSlotsShow"] = 4,
                ["BuffsPassives"] = "On additional panel",
                ["Actions"] = true,
                ["FrameDamageColor"] = 
                {
                    [1] = 0.8784313725,
                    [2] = 0.1098039216,
                    [3] = 0.1098039216,
                },
                ["ReticleInvul"] = false,
                ["BuiltInGlobalCooldown"] = true,
                ["BossFrame"] = true,
                ["ZoomCyrodiil"] = 45,
                ["Meter_Crit"] = false,
                ["BuffsImportant"] = true,
                ["UltimateOrder"] = 2,
                ["RaidFontSize"] = 17,
                ["Shield"] = true,
                ["ZoomZone"] = 60,
                ["FrameNameFormat"] = 1,
                ["CustomBuffs"] = 
                {
                },
                ["MiniMap"] = false,
                ["FrameHorisontal"] = true,
                ["ReticleResist"] = 1,
                ["ZoomGlobal"] = 3,
                ["FrameStaminaColor"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.5490196078,
                    [3] = 0.1176470588,
                },
                ["NotificationSound_2"] = "No_Sound",
                ["EnableNameplate"] = false,
                ["ContainerHandler"] = true,
                ["BuffsOtherHide"] = true,
                ["AutoDismissPet"] = true,
                ["StatsFontSize"] = 18,
                ["BUI_Minimap"] = 
                {
                    [4] = 0,
                    [1] = 9,
                    [2] = 9,
                    [3] = 0,
                },
                ["LargeGroupInvite"] = true,
                ["FrameMagickaColor"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.1176470588,
                    [3] = 0.8627450980,
                },
                ["StatShare"] = false,
                ["BUI_PlayerFrame"] = 
                {
                    [4] = 200,
                    [1] = 9,
                    [2] = 128,
                    [3] = -250,
                },
                ["FrameFont2"] = "esobold",
                ["PreferredTarget"] = true,
                ["PlayerBuffSize"] = 44,
                ["StatsGroupDPS"] = false,
                ["NotificationsGroup"] = true,
                ["EnableCustomBuffs"] = false,
                ["MinimumDuration"] = 3,
                ["BlockIndicator"] = true,
                ["RaidLevels"] = true,
                ["DefaultTargetFrame"] = true,
                ["FrameHealerColor"] = 
                {
                    [1] = 1,
                    [2] = 0.7568627451,
                    [3] = 0.4980392157,
                },
                ["Reports"] = 
                {
                },
                ["MiniMapDimensions"] = 250,
                ["AdvancedSynergy"] = false,
                ["LargeGroupAnnoucement"] = true,
                ["MarkerSize"] = 40,
                ["Log"] = false,
                ["PvPmodeAnnouncement"] = true,
                ["EnableWidgets"] = false,
                ["CurvedHitAnimation"] = false,
                ["HideSwapPanel"] = true,
                ["Widgets"] = 
                {
                    ["Major Courage"] = true,
                    [110143] = true,
                    [110142] = true,
                    [110067] = true,
                    ["Immovable"] = true,
                    [107141] = true,
                    [110118] = true,
                    [61927] = true,
                    [109084] = true,
                    [46327] = true,
                    [104538] = true,
                    ["Major Brutality"] = true,
                    ["Major Sorcery"] = true,
                    [126941] = true,
                    ["Major Resolve"] = true,
                    [61919] = true,
                },
                ["RaidFrames"] = true,
                ["CustomBuffSize"] = 44,
                ["ProcAnimation"] = true,
                ["FullSwapPanel"] = false,
                ["DisableHelpAnnounce"] = false,
                ["FrameShieldColor1"] = 
                {
                    [4] = 1,
                    [1] = 0.9019607843,
                    [2] = 0.3921568627,
                    [3] = 0.0784313725,
                },
                ["FrameStaminaColor1"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.8235294118,
                    [3] = 0.0784313725,
                },
                ["RaidWidth"] = 220,
                ["GroupLeave"] = true,
                ["FrameTraumaColor1"] = 
                {
                    [4] = 1,
                    [1] = 0.2941176471,
                    [2] = 0,
                    [3] = 0.5882352941,
                },
                ["DeleteMail"] = true,
                ["TargetFrame"] = false,
                ["ShowDots"] = true,
                ["UndauntedPledges"] = true,
                ["version"] = 3,
                ["ProcSound"] = "Ability_Ultimate_Ready_Sound",
                ["WidgetSound2"] = "CrownCrates_Manifest_Selected",
                ["PlayerFrame"] = false,
                ["FrameHeight"] = 22,
                ["Champion"] = 
                {
                    [1] = 
                    {
                    },
                    [2] = 
                    {
                    },
                    [3] = 
                    {
                    },
                },
                ["TargetBuffsAlign"] = 128,
                ["SynergyCdPSide"] = "right",
                ["CastbyPlayer"] = true,
                ["FoodBuff"] = true,
                ["ActionSlots"] = true,
                ["DecimalValues"] = true,
                ["BuffsBlackList"] = 
                {
                    [63601] = true,
                    [14890] = true,
                    [76667] = true,
                },
                ["DefaultTargetFrameText"] = true,
                ["PlayerBuffsAlign"] = 128,
                ["CurvedDistance"] = 240,
                ["StatsMiniSpeed"] = false,
                ["LargeRaidScale"] = 80,
                ["CurvedStatValues"] = true,
                ["CurvedOffset"] = -100,
                ["PlayerToPlayer"] = true,
                ["RaidHeight"] = 32,
                ["ReportScale"] = 1,
                ["NotificationSound_1"] = "Champion_PointsCommitted",
                ["ExecuteSound"] = true,
                ["BUI_MiniMeter"] = 
                {
                    [4] = 0,
                    [1] = 9,
                    [2] = 1,
                    [3] = -400,
                },
                ["TargetBuffSize"] = 44,
                ["TauntTimerSource"] = true,
                ["DarkBrotherhoodSpree"] = false,
                ["EnableSynergyCd"] = false,
                ["AutoQueue"] = true,
                ["BlockAnnouncement"] = false,
                ["FramesBorder"] = 2,
                ["BUI_BuffsC"] = 
                {
                    [4] = 300,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["TargetFrameTextAlign"] = "default",
                ["PassivePWidth"] = 100,
                ["InCombatReticle"] = true,
                ["CustomBuffsDirection"] = "vertical",
                ["ActionsFontSize"] = 16,
                ["RepositionFrames"] = true,
                ["GroupAnimation"] = true,
                ["StatsMiniGroupDps"] = true,
                ["FrameOpacityOut"] = 70,
                ["Trauma"] = true,
                ["MiniMapTitle"] = true,
                ["ZoomMountRatio"] = 70,
                ["Meter_Exp"] = true,
                ["FastTravel"] = true,
                ["ZoomSubZone"] = 30,
                ["FrameOpacityIn"] = 90,
                ["CurvedFrame"] = 2,
                ["PlayerBuffs"] = true,
                ["StatsBuffs"] = true,
                ["BUI_OnScreen"] = 
                {
                    [4] = -110,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["MarkerLeader"] = false,
                ["StatsGroupDPSframe"] = false,
                ["SwapIndicator"] = true,
                ["BUI_BuffsS"] = 
                {
                    [4] = 200,
                    [1] = 128,
                    [2] = 128,
                    [3] = -300,
                },
                ["ConfirmLocked"] = true,
                ["MiniMeterAplha"] = 0.8000000000,
                ["PrimaryStat"] = 1,
                ["PassiveBuffSize"] = 36,
                ["BUI_BuffsP"] = 
                {
                    [4] = 345,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["NotificationsWorld"] = true,
                ["SmallGroupScale"] = 120,
                ["ReticleMode"] = 4,
                ["FrameMagickaColor1"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.4784313725,
                    [3] = 1,
                },
                ["PassiveOakFilter"] = true,
                ["TauntTimer"] = 1,
                ["BUI_BuffsT"] = 
                {
                    [4] = -350,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["Meter_Speed"] = true,
                ["TraumaGroup"] = true,
                ["SynergyCdDirection"] = "vertical",
                ["FrameShieldColor"] = 
                {
                    [4] = 1,
                    [1] = 0.9803921569,
                    [2] = 0.3921568627,
                    [3] = 0.0784313725,
                },
                ["SidePanel"] = 
                {
                    ["Minimap"] = true,
                    ["Banker"] = true,
                    ["SubSampling"] = true,
                    ["Compass"] = true,
                    ["Widgets"] = true,
                    ["Enable"] = true,
                    ["LFG_Role"] = true,
                    ["Armorer"] = true,
                    ["Smuggler"] = true,
                    ["VeteranDifficulty"] = true,
                    ["AllowOther"] = true,
                    ["Teleporter"] = true,
                    ["WPamA"] = true,
                    ["Settings"] = true,
                    ["Share"] = true,
                    ["Trader"] = true,
                    ["HealerHelper"] = true,
                    ["Statistics"] = true,
                    ["LeaderArrow"] = true,
                    ["DismissPets"] = true,
                    ["Ragpicker"] = true,
                    ["GearManager"] = true,
                },
                ["PinScale"] = 75,
                ["FrameShowMax"] = true,
                ["CurvedShiftAnimation"] = false,
                ["GroupDeathSound"] = "Lockpicking_unlocked",
                ["StealthWield"] = true,
                ["FrameTankColor"] = 
                {
                    [1] = 0.8588235294,
                    [2] = 0.5607843137,
                    [3] = 1,
                },
                ["CustomBuffsPSide"] = "right",
                ["PinColor"] = 
                {
                    [40] = 
                    {
                        [4] = 1,
                        [1] = 1,
                        [2] = 1,
                        [3] = 1,
                    },
                    [1] = 
                    {
                        [4] = 1,
                        [1] = 1,
                        [2] = 1,
                        [3] = 1,
                    },
                    [2] = 
                    {
                        [4] = 1,
                        [1] = 1,
                        [2] = 1,
                        [3] = 0,
                    },
                    [204] = 
                    {
                        [4] = 1,
                        [1] = 1,
                        [2] = 1,
                        [3] = 1,
                    },
                    [12] = 
                    {
                        [4] = 1,
                        [1] = 1,
                        [2] = 1,
                        [3] = 1,
                    },
                },
                ["StatsTransparent"] = true,
                ["Glyphs"] = true,
                ["ZoomDungeon"] = 60,
                ["CurvedDepth"] = 0.8000000000,
                ["StatsMiniMeter"] = true,
                ["ReticleDpS"] = true,
                ["FramePercents"] = false,
                ["AdvancedThemeColor"] = 
                {
                    [4] = 0.9000000000,
                    [1] = 0.5000000000,
                    [2] = 0.6000000000,
                    [3] = 1,
                },
                ["ExpiresAnimation"] = true,
                ["AttackersHeight"] = 28,
                ["GroupBuffs"] = false,
                ["DodgeFatigue"] = true,
                ["NotificationFood"] = true,
                ["BossHeight"] = 28,
                ["RepeatableQuests"] = false,
                ["UseSwapPanel"] = true,
                ["LootStolen"] = true,
                ["ColorRoles"] = true,
                ["BUI_OnScreenS"] = 
                {
                    [4] = -210,
                    [1] = 128,
                    [2] = 128,
                    [3] = 360,
                },
                ["StatsSplitElements"] = true,
                ["FriendStatus"] = true,
                ["NotificationsSize"] = 32,
                ["ExecuteThreshold"] = 25,
                ["HousePins"] = 4,
                ["StatsMiniHealing"] = false,
                ["DeveloperMode"] = false,
                ["PvPmode"] = true,
                ["StatusIcons"] = true,
                ["PassivePSide"] = "left",
                ["GroupSynergyCount"] = 2,
                ["FrameHealthColor"] = 
                {
                    [4] = 1,
                    [1] = 0.5882352941,
                    [2] = 0.1176470588,
                    [3] = 0.2352941176,
                },
                ["StatsShareDPS"] = false,
                ["TargetHeight"] = 22,
                ["StatsUpdateDPS"] = false,
                ["QuickSlotsInventory"] = true,
                ["WidgetPotion"] = true,
                ["FrameFont1"] = "esobold",
                ["JumpToLeader"] = false,
                ["CurvedShift"] = false,
                ["OnScreenPriorDeath"] = true,
                ["Books"] = true,
                ["EnableStats"] = true,
                ["InitialDialog"] = true,
                ["WidgetsSize"] = 44,
                ["EffectVisualisation"] = true,
                ["GroupElection"] = true,
                ["DefaultPlayerFrames"] = false,
                ["BUI_GroupDPS"] = 
                {
                    [4] = 120,
                    [1] = 3,
                    [2] = 1,
                    [3] = -400,
                },
                ["AttackersWidth"] = 280,
                ["RaidColumnSize"] = 6,
                ["BUI_TargetFrame"] = 
                {
                    [4] = 200,
                    [1] = 3,
                    [2] = 128,
                    [3] = 250,
                },
                ["CastBar"] = 1,
                ["GroupSynergy"] = 3,
                ["SelfColor"] = true,
                ["LeaderArrow"] = true,
                ["CurvedHeight"] = 360,
                ["SynergyCdPWidth"] = 120,
                ["FrameHealthColor1"] = 
                {
                    [4] = 1,
                    [1] = 1,
                    [2] = 0.1568627451,
                    [3] = 0.2745098039,
                },
            },
        },
    },
}
BUI_REPORTS =
{
    ["Default"] = 
    {
        ["@germanus4711"] = 
        {
            ["$AccountWide"] = 
            {
                ["data"] = 
                {
                },
                ["version"] = 1,
            },
        },
    },
}
