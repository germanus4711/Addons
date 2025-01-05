BUI_VARS =
{
    ["Default"] = 
    {
        ["@germanus4711"] = 
        {
            ["$AccountWide"] = 
            {
                ["FrameOpacityOut"] = 70,
                ["BUI_GroupDPS"] = 
                {
                    [4] = 120,
                    [1] = 3,
                    [2] = 1,
                    [3] = -400,
                },
                ["AttackersWidth"] = 280,
                ["Log"] = false,
                ["BUI_BuffsS"] = 
                {
                    [4] = 200,
                    [1] = 128,
                    [2] = 128,
                    [3] = -300,
                },
                ["ZoomSubZone"] = 30,
                ["FrameStaminaColor"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.5490196078,
                    [3] = 0.1176470588,
                },
                ["CurvedFrame"] = 2,
                ["RaidHeight"] = 32,
                ["CurvedDistance"] = 240,
                ["BossHeight"] = 28,
                ["CustomBuffs"] = 
                {
                },
                ["BUI_BuffsP"] = 
                {
                    [4] = 345,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["ImpactAnimation"] = true,
                ["RepeatableQuests"] = false,
                ["PassiveProgress"] = false,
                ["EffectVisualisation"] = true,
                ["ActionSlots"] = true,
                ["Glyphs"] = true,
                ["Widgets"] = 
                {
                    [110143] = true,
                    ["Major Courage"] = true,
                    ["Immovable"] = true,
                    [110067] = true,
                    [61927] = true,
                    [107141] = true,
                    [110118] = true,
                    ["Major Brutality"] = true,
                    [46327] = true,
                    [104538] = true,
                    ["Major Sorcery"] = true,
                    ["Major Resolve"] = true,
                    [109084] = true,
                    [126941] = true,
                    [110142] = true,
                    [61919] = true,
                },
                ["RaidSort"] = 1,
                ["CustomBar"] = 
                {
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
                    ["Enable"] = false,
                },
                ["RaidSplit"] = 0,
                ["StatsBuffs"] = true,
                ["BuffsOtherHide"] = true,
                ["Theme"] = 2,
                ["FrameNameFormat"] = 1,
                ["PrimaryStat"] = 1,
                ["ActionsPrecise"] = true,
                ["EnableWidgets"] = false,
                ["BUI_BuffsPas"] = 
                {
                    [4] = 0,
                    [1] = 12,
                    [2] = 12,
                    [3] = 0,
                },
                ["ReticleInvul"] = false,
                ["FrameWidth"] = 280,
                ["Books"] = true,
                ["MiniMap"] = false,
                ["MiniMeterAplha"] = 0.8000000000,
                ["PlayerBuffs"] = true,
                ["Reports"] = 
                {
                },
                ["TargetWidth"] = 320,
                ["StatsMiniGroupDps"] = true,
                ["NotificationsTimer"] = 3000,
                ["UndauntedPledges"] = true,
                ["Meter_Exp"] = true,
                ["WidgetsPWidth"] = 120,
                ["CurvedShift"] = false,
                ["BUI_TargetFrame"] = 
                {
                    [4] = 200,
                    [1] = 3,
                    [2] = 128,
                    [3] = 250,
                },
                ["RaidFontSize"] = 17,
                ["PvPmodeAnnouncement"] = true,
                ["FramesBorder"] = 2,
                ["FramesFade"] = true,
                ["FrameTraumaColor"] = 
                {
                    [4] = 1,
                    [1] = 0.5882352941,
                    [2] = 0.1960784314,
                    [3] = 1,
                },
                ["BossWidth"] = 280,
                ["FrameDamageColor"] = 
                {
                    [1] = 0.8784313725,
                    [2] = 0.1098039216,
                    [3] = 0.1098039216,
                },
                ["StatusIcons"] = true,
                ["NotificationsWorld"] = true,
                ["TauntTimer"] = 1,
                ["ReticleMode"] = 4,
                ["QuickSlots"] = true,
                ["Actions"] = true,
                ["PassivePWidth"] = 100,
                ["StatShareUlt"] = 3,
                ["FoodBuff"] = true,
                ["DodgeFatigue"] = true,
                ["Meter_Speed"] = true,
                ["BuffsImportant"] = true,
                ["EnableXPBar"] = true,
                ["SidePanel"] = 
                {
                    ["WPamA"] = true,
                    ["Trader"] = true,
                    ["Statistics"] = true,
                    ["GearManager"] = true,
                    ["Share"] = true,
                    ["Armorer"] = true,
                    ["Teleporter"] = true,
                    ["LFG_Role"] = true,
                    ["VeteranDifficulty"] = true,
                    ["DismissPets"] = true,
                    ["AllowOther"] = true,
                    ["LeaderArrow"] = true,
                    ["Banker"] = true,
                    ["Ragpicker"] = true,
                    ["Smuggler"] = true,
                    ["Widgets"] = true,
                    ["HealerHelper"] = true,
                    ["Compass"] = true,
                    ["Minimap"] = true,
                    ["Enable"] = true,
                    ["Settings"] = true,
                    ["SubSampling"] = true,
                },
                ["GroupBuffs"] = false,
                ["SynergyCdProgress"] = true,
                ["HideSwapPanel"] = true,
                ["FrameOpacityIn"] = 90,
                ["StatsMiniMeter"] = true,
                ["PlayerToPlayer"] = true,
                ["CustomBuffsProgress"] = true,
                ["DefaultPlayerFrames"] = false,
                ["PvPmode"] = true,
                ["SynergyCdPWidth"] = 120,
                ["CustomBuffSize"] = 44,
                ["LeaderArrow"] = true,
                ["CurvedOffset"] = -100,
                ["version"] = 3,
                ["ReticleBoost"] = true,
                ["NotificationsGroup"] = true,
                ["NotificationsSize"] = 32,
                ["RaidWidth"] = 220,
                ["NotificationsTrial"] = true,
                ["FrameShieldColor"] = 
                {
                    [4] = 1,
                    [1] = 0.9803921569,
                    [2] = 0.3921568627,
                    [3] = 0.0784313725,
                },
                ["FrameFontSize"] = 15,
                ["ExecuteSound"] = true,
                ["PlayerFrame"] = false,
                ["LargeRaidScale"] = 80,
                ["PassiveOakFilter"] = true,
                ["QuickSlotsInventory"] = true,
                ["MarkerSize"] = 40,
                ["CollapseNormalDungeon"] = false,
                ["StatTriggerHeals"] = false,
                ["BuffsBlackList"] = 
                {
                    [63601] = true,
                    [14890] = true,
                    [76667] = true,
                },
                ["BossFrame"] = true,
                ["LootStolen"] = true,
                ["PreferredTarget"] = true,
                ["ShowDots"] = true,
                ["BUI_HPlayerFrame"] = 
                {
                    [4] = 410,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["DefaultTargetFrame"] = true,
                ["StatsMiniSpeed"] = false,
                ["Meter_Crit"] = false,
                ["ZoomZone"] = 60,
                ["SelfColor"] = true,
                ["StatShare"] = false,
                ["CustomBuffsPWidth"] = 120,
                ["Meter_Power"] = false,
                ["UltimateOrder"] = 2,
                ["BUI_BuffsC"] = 
                {
                    [4] = 300,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["StatsGroupDPS"] = false,
                ["ColorRoles"] = true,
                ["CurvedShiftAnimation"] = false,
                ["BUI_RaidFrame"] = 
                {
                    [4] = 160,
                    [1] = 3,
                    [2] = 3,
                    [3] = 50,
                },
                ["BlockIndicator"] = true,
                ["ZoomImperialsewer"] = 60,
                ["BUI_OnScreenS"] = 
                {
                    [4] = -210,
                    [1] = 128,
                    [2] = 128,
                    [3] = 360,
                },
                ["NotificationSound_1"] = "Champion_PointsCommitted",
                ["TargetFrame"] = false,
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
                ["TargetFrameTextAlign"] = "default",
                ["AutoQueue"] = true,
                ["EnableBlackList"] = true,
                ["WidgetsSize"] = 44,
                ["HousePins"] = 4,
                ["CurvedHeight"] = 360,
                ["ReticleDpS"] = true,
                ["StatsShareDPS"] = false,
                ["DecimalValues"] = true,
                ["ZoomCyrodiil"] = 45,
                ["ReportScale"] = 1,
                ["DisableHelpAnnounce"] = false,
                ["AttackersHeight"] = 28,
                ["CustomEdgeColor"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.0700000000,
                    [3] = 0.0700000000,
                },
                ["SynergyCdPSide"] = "right",
                ["MiniMapTitle"] = true,
                ["GroupAnimation"] = true,
                ["QuickSlotsShow"] = 4,
                ["FrameShieldColor1"] = 
                {
                    [4] = 1,
                    [1] = 0.9019607843,
                    [2] = 0.3921568627,
                    [3] = 0.0784313725,
                },
                ["FrameMagickaColor1"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.4784313725,
                    [3] = 1,
                },
                ["PlayerBuffSize"] = 44,
                ["CurvedHitAnimation"] = false,
                ["FrameFont1"] = "esobold",
                ["ProcSound"] = "Ability_Ultimate_Ready_Sound",
                ["ZoomMountRatio"] = 70,
                ["OnScreenPriorDeath"] = true,
                ["UseSwapPanel"] = true,
                ["PassivePSide"] = "left",
                ["StatsSplitElements"] = true,
                ["LargeGroupInvite"] = true,
                ["SwapIndicator"] = true,
                ["GroupSynergy"] = 3,
                ["WidgetPotion"] = true,
                ["AutoDismissPet"] = true,
                ["TraumaGroup"] = true,
                ["TargetBuffs"] = true,
                ["AdvancedSynergy"] = false,
                ["BlockAnnouncement"] = false,
                ["BUI_OnScreen"] = 
                {
                    [4] = -110,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["BUI_BuffsT"] = 
                {
                    [4] = -350,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["CurvedDepth"] = 0.8000000000,
                ["BuiltInGlobalCooldown"] = true,
                ["FrameHealthColor1"] = 
                {
                    [4] = 1,
                    [1] = 1,
                    [2] = 0.1568627451,
                    [3] = 0.2745098039,
                },
                ["InCombatReticle"] = true,
                ["FriendStatus"] = true,
                ["FrameTankColor"] = 
                {
                    [1] = 0.8588235294,
                    [2] = 0.5607843137,
                    [3] = 1,
                },
                ["RaidLevels"] = true,
                ["TargetBuffsAlign"] = 128,
                ["FrameHorisontal"] = true,
                ["ExpiresAnimation"] = true,
                ["StealthWield"] = true,
                ["MarkerLeader"] = false,
                ["FrameHealthColor"] = 
                {
                    [4] = 1,
                    [1] = 0.5882352941,
                    [2] = 0.1176470588,
                    [3] = 0.2352941176,
                },
                ["CastBar"] = 1,
                ["CustomBuffsPSide"] = "right",
                ["WidgetSound2"] = "CrownCrates_Manifest_Selected",
                ["PlayerBuffsAlign"] = 128,
                ["EnableNameplate"] = false,
                ["ReticleResist"] = 1,
                ["WidgetSound1"] = "CrownCrates_Manifest_Chosen",
                ["ZoomGlobal"] = 3,
                ["PassiveBuffSize"] = 36,
                ["ConfirmLocked"] = true,
                ["SynergyCdDirection"] = "vertical",
                ["CustomBuffsDirection"] = "vertical",
                ["DeleteMail"] = true,
                ["EnableSynergyCd"] = false,
                ["FramesTexture"] = "rounded",
                ["InitialDialog"] = true,
                ["SynergyCdSize"] = 44,
                ["ProcAnimation"] = true,
                ["FrameMagickaColor"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.1176470588,
                    [3] = 0.8627450980,
                },
                ["FastTravel"] = true,
                ["LastVersion"] = 4.4240000000,
                ["BUI_PlayerFrame"] = 
                {
                    [4] = 200,
                    [1] = 9,
                    [2] = 128,
                    [3] = -250,
                },
                ["CurvedStatValues"] = true,
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
                ["ZoomImperialCity"] = 80,
                ["StatsFontSize"] = 18,
                ["MinimumDuration"] = 3,
                ["RaidFrames"] = true,
                ["TargetHeight"] = 22,
                ["StatsTransparent"] = true,
                ["ExecuteThreshold"] = 25,
                ["AdvancedThemeColor"] = 
                {
                    [4] = 0.9000000000,
                    [1] = 0.5000000000,
                    [2] = 0.6000000000,
                    [3] = 1,
                },
                ["ShieldGroup"] = true,
                ["GroupDeathSound"] = "Lockpicking_unlocked",
                ["GroupElection"] = true,
                ["StatsMiniHealing"] = false,
                ["PinScale"] = 75,
                ["MiniMapDimensions"] = 250,
                ["EnableCustomBuffs"] = false,
                ["GroupLeave"] = true,
                ["FrameStaminaColor1"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.8235294118,
                    [3] = 0.0784313725,
                },
                ["BUI_MiniMeter"] = 
                {
                    [4] = 0,
                    [1] = 9,
                    [2] = 1,
                    [3] = -400,
                },
                ["Shield"] = true,
                ["EnableStats"] = true,
                ["LargeGroupAnnoucement"] = true,
                ["DefaultTargetFrameText"] = true,
                ["FrameHealerColor"] = 
                {
                    [1] = 1,
                    [2] = 0.7568627451,
                    [3] = 0.4980392157,
                },
                ["ZoomDungeon"] = 60,
                ["ContainerHandler"] = true,
                ["NotificationSound_2"] = "No_Sound",
                ["NotificationFood"] = true,
                ["Trauma"] = true,
                ["FramePercents"] = false,
                ["DarkBrotherhoodSpree"] = false,
                ["CastbyPlayer"] = true,
                ["BUI_Minimap"] = 
                {
                    [4] = 0,
                    [1] = 9,
                    [2] = 9,
                    [3] = 0,
                },
                ["GroupSynergyCount"] = 2,
                ["StatsUpdateDPS"] = false,
                ["FrameTraumaColor1"] = 
                {
                    [4] = 1,
                    [1] = 0.2941176471,
                    [2] = 0,
                    [3] = 0.5882352941,
                },
                ["StatsGroupDPSframe"] = false,
                ["TargetBuffSize"] = 44,
                ["DeveloperMode"] = false,
                ["SmallGroupScale"] = 120,
                ["ActionsFontSize"] = 16,
                ["FullSwapPanel"] = false,
                ["FrameHeight"] = 22,
                ["RepositionFrames"] = true,
                ["FrameShowMax"] = true,
                ["FrameFont2"] = "esobold",
                ["JumpToLeader"] = false,
                ["TauntTimerSource"] = true,
                ["BuffsPassives"] = "On additional panel",
                ["RaidColumnSize"] = 6,
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
