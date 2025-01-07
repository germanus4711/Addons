BUI_VARS =
{
    ["Default"] = 
    {
        ["@germanus4711"] = 
        {
            ["$AccountWide"] = 
            {
                ["StatsMiniGroupDps"] = true,
                ["CurvedStatValues"] = true,
                ["FullSwapPanel"] = false,
                ["FrameMagickaColor"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.1176470588,
                    [3] = 0.8627450980,
                },
                ["DodgeFatigue"] = true,
                ["LargeRaidScale"] = 80,
                ["WidgetSound1"] = "CrownCrates_Manifest_Chosen",
                ["RaidLevels"] = true,
                ["AttackersHeight"] = 28,
                ["WidgetSound2"] = "CrownCrates_Manifest_Selected",
                ["LastVersion"] = 4.4240000000,
                ["BuffsBlackList"] = 
                {
                    [63601] = true,
                    [14890] = true,
                    [76667] = true,
                },
                ["FriendStatus"] = true,
                ["ReticleBoost"] = true,
                ["CurvedDepth"] = 0.8000000000,
                ["PassiveBuffSize"] = 36,
                ["FrameShowMax"] = true,
                ["WidgetPotion"] = true,
                ["FrameMagickaColor1"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.4784313725,
                    [3] = 1,
                },
                ["NotificationSound_2"] = "No_Sound",
                ["RaidFontSize"] = 17,
                ["FrameTankColor"] = 
                {
                    [1] = 0.8588235294,
                    [2] = 0.5607843137,
                    [3] = 1,
                },
                ["EnableCustomBuffs"] = false,
                ["ActionsPrecise"] = true,
                ["InCombatReticle"] = true,
                ["SynergyCdPSide"] = "right",
                ["TargetBuffSize"] = 44,
                ["Log"] = false,
                ["BUI_BuffsP"] = 
                {
                    [4] = 345,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["CurvedFrame"] = 2,
                ["MiniMap"] = false,
                ["TraumaGroup"] = true,
                ["LeaderArrow"] = true,
                ["ColorRoles"] = true,
                ["ExecuteThreshold"] = 25,
                ["StatShare"] = false,
                ["ReticleMode"] = 4,
                ["SidePanel"] = 
                {
                    ["Teleporter"] = true,
                    ["DismissPets"] = true,
                    ["GearManager"] = true,
                    ["Trader"] = true,
                    ["Minimap"] = true,
                    ["LFG_Role"] = true,
                    ["HealerHelper"] = true,
                    ["VeteranDifficulty"] = true,
                    ["Settings"] = true,
                    ["AllowOther"] = true,
                    ["LeaderArrow"] = true,
                    ["Banker"] = true,
                    ["Ragpicker"] = true,
                    ["Widgets"] = true,
                    ["SubSampling"] = true,
                    ["Compass"] = true,
                    ["Share"] = true,
                    ["Enable"] = true,
                    ["WPamA"] = true,
                    ["Smuggler"] = true,
                    ["Statistics"] = true,
                    ["Armorer"] = true,
                },
                ["QuickSlotsShow"] = 4,
                ["CustomBar"] = 
                {
                    ["Leader"] = 
                    {
                        [1] = false,
                        [2] = false,
                        [3] = false,
                        [4] = false,
                        [5] = false,
                        [6] = false,
                    },
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
                    ["Enable"] = false,
                },
                ["AutoQueue"] = true,
                ["PassivePSide"] = "left",
                ["SmallGroupScale"] = 120,
                ["BUI_BuffsC"] = 
                {
                    [4] = 300,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["Meter_Exp"] = true,
                ["CastBar"] = 1,
                ["EnableNameplate"] = false,
                ["InitialDialog"] = true,
                ["CurvedHeight"] = 360,
                ["ProcAnimation"] = true,
                ["ReportScale"] = 1,
                ["DefaultTargetFrame"] = true,
                ["ContainerHandler"] = true,
                ["SelfColor"] = true,
                ["NotificationFood"] = true,
                ["BUI_PlayerFrame"] = 
                {
                    [4] = 200,
                    [1] = 9,
                    [2] = 128,
                    [3] = -250,
                },
                ["ZoomDungeon"] = 60,
                ["CustomBuffsProgress"] = true,
                ["AttackersWidth"] = 280,
                ["FrameHealerColor"] = 
                {
                    [1] = 1,
                    [2] = 0.7568627451,
                    [3] = 0.4980392157,
                },
                ["CustomBuffsPWidth"] = 120,
                ["BuffsOtherHide"] = true,
                ["HousePins"] = 4,
                ["DarkBrotherhoodSpree"] = false,
                ["DisableHelpAnnounce"] = false,
                ["FramePercents"] = false,
                ["BUI_GroupDPS"] = 
                {
                    [4] = 120,
                    [1] = 3,
                    [2] = 1,
                    [3] = -400,
                },
                ["CurvedDistance"] = 240,
                ["RaidSplit"] = 0,
                ["MinimumDuration"] = 3,
                ["GroupElection"] = true,
                ["ShowDots"] = true,
                ["Actions"] = true,
                ["NotificationSound_1"] = "Champion_PointsCommitted",
                ["Trauma"] = true,
                ["ExecuteSound"] = true,
                ["BuiltInGlobalCooldown"] = true,
                ["FrameFont1"] = "esobold",
                ["SynergyCdProgress"] = true,
                ["Reports"] = 
                {
                },
                ["CastbyPlayer"] = true,
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
                ["FrameHealthColor1"] = 
                {
                    [4] = 1,
                    [1] = 1,
                    [2] = 0.1568627451,
                    [3] = 0.2745098039,
                },
                ["ImpactAnimation"] = true,
                ["RaidSort"] = 1,
                ["FrameWidth"] = 280,
                ["ConfirmLocked"] = true,
                ["FrameDamageColor"] = 
                {
                    [1] = 0.8784313725,
                    [2] = 0.1098039216,
                    [3] = 0.1098039216,
                },
                ["GroupSynergy"] = 3,
                ["BUI_BuffsS"] = 
                {
                    [4] = 200,
                    [1] = 128,
                    [2] = 128,
                    [3] = -300,
                },
                ["ZoomZone"] = 60,
                ["FrameTraumaColor1"] = 
                {
                    [4] = 1,
                    [1] = 0.2941176471,
                    [2] = 0,
                    [3] = 0.5882352941,
                },
                ["UltimateOrder"] = 2,
                ["FastTravel"] = true,
                ["TargetBuffsAlign"] = 128,
                ["CustomBuffSize"] = 44,
                ["Shield"] = true,
                ["FramesBorder"] = 2,
                ["FrameNameFormat"] = 1,
                ["DeveloperMode"] = false,
                ["PlayerFrame"] = false,
                ["FrameHeight"] = 22,
                ["StatsTransparent"] = true,
                ["HideSwapPanel"] = true,
                ["BUI_TargetFrame"] = 
                {
                    [4] = 200,
                    [1] = 3,
                    [2] = 128,
                    [3] = 250,
                },
                ["QuickSlotsInventory"] = true,
                ["RaidFrames"] = true,
                ["BUI_Minimap"] = 
                {
                    [4] = 0,
                    [1] = 9,
                    [2] = 9,
                    [3] = 0,
                },
                ["BuffsImportant"] = true,
                ["RepositionFrames"] = true,
                ["FramesFade"] = true,
                ["StealthWield"] = true,
                ["ProcSound"] = "Ability_Ultimate_Ready_Sound",
                ["CustomBuffsPSide"] = "right",
                ["AdvancedThemeColor"] = 
                {
                    [4] = 0.9000000000,
                    [1] = 0.5000000000,
                    [2] = 0.6000000000,
                    [3] = 1,
                },
                ["RaidWidth"] = 220,
                ["StatsMiniMeter"] = true,
                ["EnableWidgets"] = false,
                ["TauntTimer"] = 1,
                ["EnableStats"] = true,
                ["SynergyCdPWidth"] = 120,
                ["GroupBuffs"] = false,
                ["ReticleInvul"] = false,
                ["NotificationsWorld"] = true,
                ["PrimaryStat"] = 1,
                ["EnableBlackList"] = true,
                ["PlayerBuffs"] = true,
                ["FrameHealthColor"] = 
                {
                    [4] = 1,
                    [1] = 0.5882352941,
                    [2] = 0.1176470588,
                    [3] = 0.2352941176,
                },
                ["CurvedOffset"] = -100,
                ["AdvancedSynergy"] = false,
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
                ["NotificationsTrial"] = true,
                ["StatsMiniHealing"] = false,
                ["PvPmodeAnnouncement"] = true,
                ["FrameShieldColor"] = 
                {
                    [4] = 1,
                    [1] = 0.9803921569,
                    [2] = 0.3921568627,
                    [3] = 0.0784313725,
                },
                ["RepeatableQuests"] = false,
                ["ReticleDpS"] = true,
                ["PlayerBuffsAlign"] = 128,
                ["BlockAnnouncement"] = false,
                ["PlayerBuffSize"] = 44,
                ["DefaultPlayerFrames"] = false,
                ["BUI_HPlayerFrame"] = 
                {
                    [4] = 410,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["TargetHeight"] = 22,
                ["StatsMiniSpeed"] = false,
                ["ZoomCyrodiil"] = 45,
                ["PreferredTarget"] = true,
                ["FrameFontSize"] = 15,
                ["EffectVisualisation"] = true,
                ["DeleteMail"] = true,
                ["CollapseNormalDungeon"] = false,
                ["GroupSynergyCount"] = 2,
                ["EnableXPBar"] = true,
                ["AutoDismissPet"] = true,
                ["MiniMapTitle"] = true,
                ["BUI_BuffsPas"] = 
                {
                    [4] = 0,
                    [1] = 12,
                    [2] = 12,
                    [3] = 0,
                },
                ["StatsFontSize"] = 18,
                ["GroupAnimation"] = true,
                ["NotificationsTimer"] = 3000,
                ["version"] = 3,
                ["TargetWidth"] = 320,
                ["CustomBuffs"] = 
                {
                },
                ["StatsUpdateDPS"] = false,
                ["StatShareUlt"] = 3,
                ["LargeGroupAnnoucement"] = true,
                ["ReticleResist"] = 1,
                ["RaidHeight"] = 32,
                ["Books"] = true,
                ["Meter_Power"] = false,
                ["FoodBuff"] = true,
                ["StatsGroupDPS"] = false,
                ["MiniMapDimensions"] = 250,
                ["BUI_MiniMeter"] = 
                {
                    [4] = 0,
                    [1] = 9,
                    [2] = 1,
                    [3] = -400,
                },
                ["CustomEdgeColor"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.0700000000,
                    [3] = 0.0700000000,
                },
                ["TargetFrame"] = false,
                ["EnableSynergyCd"] = false,
                ["ExpiresAnimation"] = true,
                ["LargeGroupInvite"] = true,
                ["WidgetsPWidth"] = 120,
                ["LootStolen"] = true,
                ["PvPmode"] = true,
                ["Glyphs"] = true,
                ["StatTriggerHeals"] = false,
                ["CustomBuffsDirection"] = "vertical",
                ["PinScale"] = 75,
                ["Meter_Crit"] = false,
                ["BUI_OnScreen"] = 
                {
                    [4] = -110,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["Theme"] = 2,
                ["PassiveOakFilter"] = true,
                ["TargetFrameTextAlign"] = "default",
                ["QuickSlots"] = true,
                ["SwapIndicator"] = true,
                ["JumpToLeader"] = false,
                ["DecimalValues"] = true,
                ["MarkerLeader"] = false,
                ["FrameShieldColor1"] = 
                {
                    [4] = 1,
                    [1] = 0.9019607843,
                    [2] = 0.3921568627,
                    [3] = 0.0784313725,
                },
                ["FrameHorisontal"] = true,
                ["ShieldGroup"] = true,
                ["ZoomGlobal"] = 3,
                ["ZoomImperialCity"] = 80,
                ["BlockIndicator"] = true,
                ["PlayerToPlayer"] = true,
                ["DefaultTargetFrameText"] = true,
                ["StatsBuffs"] = true,
                ["BossHeight"] = 28,
                ["Widgets"] = 
                {
                    ["Major Courage"] = true,
                    [110143] = true,
                    ["Immovable"] = true,
                    [110067] = true,
                    [61927] = true,
                    ["Major Resolve"] = true,
                    [110118] = true,
                    [46327] = true,
                    ["Major Brutality"] = true,
                    ["Major Sorcery"] = true,
                    [104538] = true,
                    [107141] = true,
                    [109084] = true,
                    [126941] = true,
                    [110142] = true,
                    [61919] = true,
                },
                ["BossFrame"] = true,
                ["ZoomImperialsewer"] = 60,
                ["BUI_RaidFrame"] = 
                {
                    [4] = 160,
                    [1] = 3,
                    [2] = 3,
                    [3] = 50,
                },
                ["ZoomSubZone"] = 30,
                ["UseSwapPanel"] = true,
                ["StatusIcons"] = true,
                ["NotificationsSize"] = 32,
                ["CurvedShift"] = false,
                ["GroupLeave"] = true,
                ["FrameOpacityIn"] = 90,
                ["CurvedHitAnimation"] = false,
                ["BuffsPassives"] = "On additional panel",
                ["UndauntedPledges"] = true,
                ["ZoomMountRatio"] = 70,
                ["PassivePWidth"] = 100,
                ["ActionSlots"] = true,
                ["TauntTimerSource"] = true,
                ["ActionsFontSize"] = 16,
                ["FrameOpacityOut"] = 70,
                ["StatsShareDPS"] = false,
                ["Meter_Speed"] = true,
                ["FramesTexture"] = "rounded",
                ["TargetBuffs"] = true,
                ["FrameTraumaColor"] = 
                {
                    [4] = 1,
                    [1] = 0.5882352941,
                    [2] = 0.1960784314,
                    [3] = 1,
                },
                ["RaidColumnSize"] = 6,
                ["GroupDeathSound"] = "Lockpicking_unlocked",
                ["NotificationsGroup"] = true,
                ["BUI_OnScreenS"] = 
                {
                    [4] = -210,
                    [1] = 128,
                    [2] = 128,
                    [3] = 360,
                },
                ["SynergyCdDirection"] = "vertical",
                ["CurvedShiftAnimation"] = false,
                ["OnScreenPriorDeath"] = true,
                ["SynergyCdSize"] = 44,
                ["FrameStaminaColor"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.5490196078,
                    [3] = 0.1176470588,
                },
                ["PassiveProgress"] = false,
                ["WidgetsSize"] = 44,
                ["MarkerSize"] = 40,
                ["FrameFont2"] = "esobold",
                ["FrameStaminaColor1"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.8235294118,
                    [3] = 0.0784313725,
                },
                ["BossWidth"] = 280,
                ["MiniMeterAplha"] = 0.8000000000,
                ["StatsGroupDPSframe"] = false,
                ["BUI_BuffsT"] = 
                {
                    [4] = -350,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["StatsSplitElements"] = true,
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
                ["version"] = 1,
                ["data"] = 
                {
                },
            },
        },
    },
}
