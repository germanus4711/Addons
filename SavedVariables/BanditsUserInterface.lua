BUI_VARS =
{
    ["Default"] = 
    {
        ["@germanus4711"] = 
        {
            ["$AccountWide"] = 
            {
                ["MiniMapTitle"] = true,
                ["GroupSynergy"] = 3,
                ["StatShareUlt"] = 3,
                ["FrameShieldColor1"] = 
                {
                    [4] = 1,
                    [1] = 0.9019607843,
                    [2] = 0.3921568627,
                    [3] = 0.0784313725,
                },
                ["FrameNameFormat"] = 1,
                ["RepeatableQuests"] = false,
                ["CustomBar"] = 
                {
                    ["Slash"] = 
                    {
                        [1] = 
                        {
                            ["enable"] = true,
                            ["icon"] = "/esoui/art/mounts/ridingskill_ready.dds",
                            ["command"] = "/reloadui",
                        },
                        [2] = 
                        {
                            ["enable"] = false,
                            ["icon"] = "/esoui/art/icons/ability_warrior_010.dds",
                            ["command"] = "/script StartChatInput('/z Guild [name] recruits new members!')",
                        },
                        [3] = 
                        {
                            ["enable"] = false,
                            ["icon"] = "/esoui/art/icons/ability_mage_066.dds",
                            ["command"] = "/dancedunmer",
                        },
                        [4] = 
                        {
                            ["enable"] = true,
                            ["icon"] = "/esoui/art/icons/ability_rogue_062.dds",
                            ["command"] = "/script ZO_CompassFrame:SetHidden(not ZO_CompassFrame:IsHidden())",
                        },
                        [5] = 
                        {
                            ["enable"] = false,
                            ["icon"] = "/esoui/art/icons/emote_mimewall.dds",
                            ["command"] = "/mimewall",
                        },
                        [6] = 
                        {
                            ["enable"] = true,
                            ["icon"] = "/esoui/art/icons/quest_gemstone_tear_0002.dds",
                            ["command"] = "/script UseCollectible(336)",
                        },
                        [7] = 
                        {
                            ["enable"] = false,
                            ["icon"] = "/esoui/art/tutorial/gamepad/gp_playermenu_icon_store.dds",
                            ["command"] = "/jumptoleader",
                        },
                        [8] = 
                        {
                            ["enable"] = false,
                            ["icon"] = "esoui/art/tutorial/chat-notifications_up.dds",
                            ["command"] = "/script zo_callLater(function() local name=GetUnitDisplayName('reticleover') if name then StartChatInput('/w '..name..' ') else a('No target') end end,100)",
                        },
                        [9] = 
                        {
                            ["enable"] = false,
                            ["icon"] = "/esoui/art/inventory/gamepad/gp_inventory_icon_stolenitem.dds",
                            ["command"] = "/script d(AreAnyItemsStolen(BAG_BACKPACK) and 'Have stolen items' or 'Have no stolen items')",
                        },
                        [10] = 
                        {
                            ["enable"] = false,
                            ["icon"] = "/esoui/art/icons/ability_ava_005_a.dds",
                            ["command"] = "/script local _,i=GetAbilityProgressionXPInfoFromAbilityId(40232) local _,m,r=GetAbilityProgressionInfo(i) local _,_,index=GetAbilityProgressionAbilityInfo(i,m,r) CallSecureProtected('SelectSlotAbility', index, 3)",
                        },
                        [11] = 
                        {
                            ["enable"] = false,
                            ["icon"] = "/esoui/art/progression/morph_up.dds",
                            ["command"] = "/script BUI.Vars.EnableWidgets=not BUI.Vars.EnableWidgets BUI.Frames.Widgets_Init() d('Widgets are now '..(BUI.Vars.EnableWidgets and '|c33EE33enabled|r' or '|EE3333disabled|r'))",
                        },
                        [12] = 
                        {
                            ["enable"] = false,
                            ["icon"] = "Text",
                            ["command"] = "/script local text='Another sample'd(text) a(text)",
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
                ["PinScale"] = 75,
                ["FrameTankColor"] = 
                {
                    [1] = 0.8588235294,
                    [2] = 0.5607843137,
                    [3] = 1,
                },
                ["MarkerSize"] = 40,
                ["UndauntedPledges"] = true,
                ["FriendStatus"] = true,
                ["StatsFontSize"] = 18,
                ["Meter_Power"] = false,
                ["FrameTraumaColor1"] = 
                {
                    [4] = 1,
                    [1] = 0.2941176471,
                    [2] = 0,
                    [3] = 0.5882352941,
                },
                ["SynergyCdDirection"] = "vertical",
                ["FrameHealerColor"] = 
                {
                    [1] = 1,
                    [2] = 0.7568627451,
                    [3] = 0.4980392157,
                },
                ["SwapIndicator"] = true,
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
                ["FrameHeight"] = 22,
                ["PvPmodeAnnouncement"] = true,
                ["StatsUpdateDPS"] = false,
                ["CurvedDepth"] = 0.8000000000,
                ["SynergyCdPWidth"] = 120,
                ["AutoQueue"] = true,
                ["StatsSplitElements"] = true,
                ["StatsTransparent"] = true,
                ["StatsMiniHealing"] = false,
                ["ColorRoles"] = true,
                ["HideSwapPanel"] = true,
                ["StatsMiniSpeed"] = false,
                ["ZoomSubZone"] = 30,
                ["QuickSlotsShow"] = 4,
                ["SelfColor"] = true,
                ["ReticleBoost"] = true,
                ["BuffsImportant"] = true,
                ["RaidFrames"] = true,
                ["MiniMap"] = false,
                ["FrameOpacityOut"] = 70,
                ["ProcAnimation"] = true,
                ["NotificationSound_2"] = "No_Sound",
                ["CustomBuffSize"] = 44,
                ["OnScreenPriorDeath"] = true,
                ["ZoomDungeon"] = 60,
                ["UltimateOrder"] = 2,
                ["Meter_Speed"] = true,
                ["FrameHealthColor1"] = 
                {
                    [4] = 1,
                    [1] = 1,
                    [2] = 0.1568627451,
                    [3] = 0.2745098039,
                },
                ["NotificationsTrial"] = true,
                ["PrimaryStat"] = 1,
                ["CastbyPlayer"] = true,
                ["ZoomCyrodiil"] = 45,
                ["DeleteMail"] = true,
                ["PassiveBuffSize"] = 36,
                ["PlayerBuffsAlign"] = 128,
                ["SynergyCdProgress"] = true,
                ["TauntTimerSource"] = true,
                ["StatsBuffs"] = true,
                ["Meter_Exp"] = true,
                ["Trauma"] = true,
                ["ShowDots"] = true,
                ["TargetHeight"] = 22,
                ["Glyphs"] = true,
                ["ReticleResist"] = 1,
                ["FrameStaminaColor"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.5490196078,
                    [3] = 0.1176470588,
                },
                ["BUI_OnScreenS"] = 
                {
                    [4] = -210,
                    [1] = 128,
                    [2] = 128,
                    [3] = 360,
                },
                ["BlockIndicator"] = true,
                ["ZoomGlobal"] = 3,
                ["CurvedFrame"] = 2,
                ["MinimumDuration"] = 3,
                ["DarkBrotherhoodSpree"] = false,
                ["EnableWidgets"] = false,
                ["PlayerFrame"] = false,
                ["HousePins"] = 4,
                ["ContainerHandler"] = true,
                ["BossWidth"] = 280,
                ["EnableNameplate"] = false,
                ["Meter_Crit"] = false,
                ["FrameShowMax"] = true,
                ["LargeRaidScale"] = 80,
                ["NotificationsWorld"] = true,
                ["StatsGroupDPSframe"] = false,
                ["FrameTraumaColor"] = 
                {
                    [4] = 1,
                    [1] = 0.5882352941,
                    [2] = 0.1960784314,
                    [3] = 1,
                },
                ["BUI_BuffsS"] = 
                {
                    [4] = 200,
                    [1] = 128,
                    [2] = 128,
                    [3] = -300,
                },
                ["ShieldGroup"] = true,
                ["SmallGroupScale"] = 120,
                ["BuffsPassives"] = "On additional panel",
                ["PlayerBuffSize"] = 44,
                ["BUI_Minimap"] = 
                {
                    [4] = 0,
                    [1] = 9,
                    [2] = 9,
                    [3] = 0,
                },
                ["EffectVisualisation"] = true,
                ["Widgets"] = 
                {
                    [61919] = true,
                    ["Major Sorcery"] = true,
                    [61927] = true,
                    [110067] = true,
                    ["Major Brutality"] = true,
                    [107141] = true,
                    [110118] = true,
                    [46327] = true,
                    ["Major Resolve"] = true,
                    ["Immovable"] = true,
                    ["Major Courage"] = true,
                    [104538] = true,
                    [109084] = true,
                    [126941] = true,
                    [110142] = true,
                    [110143] = true,
                },
                ["BUI_TargetFrame"] = 
                {
                    [4] = 200,
                    [1] = 3,
                    [2] = 128,
                    [3] = 250,
                },
                ["ReticleInvul"] = false,
                ["StatTriggerHeals"] = false,
                ["FrameMagickaColor"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.1176470588,
                    [3] = 0.8627450980,
                },
                ["TargetBuffSize"] = 44,
                ["GroupBuffs"] = false,
                ["BUI_BuffsC"] = 
                {
                    [4] = 300,
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
                ["RaidFontSize"] = 17,
                ["GroupAnimation"] = true,
                ["DecimalValues"] = true,
                ["StatsMiniGroupDps"] = true,
                ["CurvedHeight"] = 360,
                ["EnableCustomBuffs"] = false,
                ["CustomBuffsPWidth"] = 120,
                ["AdvancedSynergy"] = false,
                ["BuffsOtherHide"] = true,
                ["FrameHealthColor"] = 
                {
                    [4] = 1,
                    [1] = 0.5882352941,
                    [2] = 0.1176470588,
                    [3] = 0.2352941176,
                },
                ["CurvedOffset"] = -100,
                ["ActionSlots"] = true,
                ["Theme"] = 2,
                ["CastBar"] = 1,
                ["AdvancedThemeColor"] = 
                {
                    [4] = 0.9000000000,
                    [1] = 0.5000000000,
                    [2] = 0.6000000000,
                    [3] = 1,
                },
                ["QuickSlots"] = true,
                ["StatusIcons"] = true,
                ["ActionsFontSize"] = 16,
                ["LargeGroupInvite"] = true,
                ["DefaultPlayerFrames"] = false,
                ["FrameWidth"] = 280,
                ["FrameShieldColor"] = 
                {
                    [4] = 1,
                    [1] = 0.9803921569,
                    [2] = 0.3921568627,
                    [3] = 0.0784313725,
                },
                ["NotificationFood"] = true,
                ["ExpiresAnimation"] = true,
                ["FrameFont2"] = "esobold",
                ["ZoomZone"] = 60,
                ["CurvedShift"] = false,
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
                ["BUI_BuffsPas"] = 
                {
                    [4] = 0,
                    [1] = 12,
                    [2] = 12,
                    [3] = 0,
                },
                ["PassivePWidth"] = 100,
                ["PvPmode"] = true,
                ["RaidLevels"] = true,
                ["BUI_PlayerFrame"] = 
                {
                    [4] = 200,
                    [1] = 9,
                    [2] = 128,
                    [3] = -250,
                },
                ["AttackersWidth"] = 280,
                ["UseSwapPanel"] = true,
                ["ExecuteThreshold"] = 25,
                ["BossHeight"] = 28,
                ["Books"] = true,
                ["LargeGroupAnnoucement"] = true,
                ["ImpactAnimation"] = true,
                ["TargetWidth"] = 320,
                ["TauntTimer"] = 1,
                ["PassiveOakFilter"] = true,
                ["CustomBuffs"] = 
                {
                },
                ["ProcSound"] = "Ability_Ultimate_Ready_Sound",
                ["ZoomMountRatio"] = 70,
                ["PreferredTarget"] = true,
                ["QuickSlotsInventory"] = true,
                ["BuiltInGlobalCooldown"] = true,
                ["MarkerLeader"] = false,
                ["FoodBuff"] = true,
                ["version"] = 3,
                ["CurvedShiftAnimation"] = false,
                ["PlayerToPlayer"] = true,
                ["LootStolen"] = true,
                ["InCombatReticle"] = true,
                ["LeaderArrow"] = true,
                ["DodgeFatigue"] = true,
                ["StatsGroupDPS"] = false,
                ["CustomBuffsPSide"] = "right",
                ["FrameFontSize"] = 15,
                ["TraumaGroup"] = true,
                ["ActionsPrecise"] = true,
                ["CurvedDistance"] = 240,
                ["BUI_OnScreen"] = 
                {
                    [4] = -110,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["BuffsBlackList"] = 
                {
                    [63601] = true,
                    [14890] = true,
                    [76667] = true,
                },
                ["EnableStats"] = true,
                ["GroupLeave"] = true,
                ["BUI_BuffsP"] = 
                {
                    [4] = 345,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["AttackersHeight"] = 28,
                ["DeveloperMode"] = false,
                ["NotificationsTimer"] = 3000,
                ["FramePercents"] = false,
                ["WidgetSound1"] = "CrownCrates_Manifest_Chosen",
                ["StatsMiniMeter"] = true,
                ["ReticleDpS"] = true,
                ["Actions"] = true,
                ["FramesFade"] = true,
                ["RaidWidth"] = 220,
                ["NotificationsSize"] = 32,
                ["ConfirmLocked"] = true,
                ["BUI_HPlayerFrame"] = 
                {
                    [4] = 410,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["NotificationsGroup"] = true,
                ["PassiveProgress"] = false,
                ["BlockAnnouncement"] = false,
                ["SynergyCdPSide"] = "right",
                ["CollapseNormalDungeon"] = false,
                ["GroupElection"] = true,
                ["BUI_MiniMeter"] = 
                {
                    [4] = 0,
                    [1] = 9,
                    [2] = 1,
                    [3] = -400,
                },
                ["RaidColumnSize"] = 6,
                ["CustomBuffsProgress"] = true,
                ["BUI_GroupDPS"] = 
                {
                    [4] = 120,
                    [1] = 3,
                    [2] = 1,
                    [3] = -400,
                },
                ["LastVersion"] = 4.4240000000,
                ["ExecuteSound"] = true,
                ["FramesTexture"] = "rounded",
                ["FrameMagickaColor1"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.4784313725,
                    [3] = 1,
                },
                ["FullSwapPanel"] = false,
                ["ReticleMode"] = 4,
                ["FrameHorisontal"] = true,
                ["GroupSynergyCount"] = 2,
                ["EnableXPBar"] = true,
                ["WidgetsPWidth"] = 120,
                ["FrameFont1"] = "esobold",
                ["StatShare"] = false,
                ["EnableSynergyCd"] = false,
                ["DisableHelpAnnounce"] = false,
                ["RaidSplit"] = 0,
                ["DefaultTargetFrameText"] = true,
                ["Shield"] = true,
                ["SidePanel"] = 
                {
                    ["LFG_Role"] = true,
                    ["SubSampling"] = true,
                    ["Smuggler"] = true,
                    ["HealerHelper"] = true,
                    ["Compass"] = true,
                    ["Ragpicker"] = true,
                    ["AllowOther"] = true,
                    ["Trader"] = true,
                    ["WPamA"] = true,
                    ["Banker"] = true,
                    ["GearManager"] = true,
                    ["VeteranDifficulty"] = true,
                    ["Statistics"] = true,
                    ["Share"] = true,
                    ["Armorer"] = true,
                    ["Teleporter"] = true,
                    ["Widgets"] = true,
                    ["Settings"] = true,
                    ["DismissPets"] = true,
                    ["Minimap"] = true,
                    ["LeaderArrow"] = true,
                    ["Enable"] = true,
                },
                ["BossFrame"] = true,
                ["InitialDialog"] = true,
                ["JumpToLeader"] = false,
                ["BUI_RaidFrame"] = 
                {
                    [4] = 160,
                    [1] = 3,
                    [2] = 3,
                    [3] = 50,
                },
                ["MiniMapDimensions"] = 250,
                ["WidgetSound2"] = "CrownCrates_Manifest_Selected",
                ["EnableBlackList"] = true,
                ["FramesBorder"] = 2,
                ["AutoDismissPet"] = true,
                ["TargetFrame"] = false,
                ["StealthWield"] = true,
                ["FrameStaminaColor1"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.8235294118,
                    [3] = 0.0784313725,
                },
                ["ReportScale"] = 1,
                ["RaidSort"] = 1,
                ["PassivePSide"] = "left",
                ["TargetBuffs"] = true,
                ["FastTravel"] = true,
                ["GroupDeathSound"] = "Lockpicking_unlocked",
                ["DefaultTargetFrame"] = true,
                ["TargetBuffsAlign"] = 128,
                ["RaidHeight"] = 32,
                ["ZoomImperialsewer"] = 60,
                ["PlayerBuffs"] = true,
                ["CustomEdgeColor"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.0700000000,
                    [3] = 0.0700000000,
                },
                ["StatsShareDPS"] = false,
                ["FrameDamageColor"] = 
                {
                    [1] = 0.8784313725,
                    [2] = 0.1098039216,
                    [3] = 0.1098039216,
                },
                ["CurvedHitAnimation"] = false,
                ["FrameOpacityIn"] = 90,
                ["Log"] = false,
                ["SynergyCdSize"] = 44,
                ["CustomBuffsDirection"] = "vertical",
                ["TargetFrameTextAlign"] = "default",
                ["MiniMeterAplha"] = 0.8000000000,
                ["WidgetPotion"] = true,
                ["NotificationSound_1"] = "Champion_PointsCommitted",
                ["RepositionFrames"] = true,
                ["ZoomImperialCity"] = 80,
                ["CurvedStatValues"] = true,
                ["WidgetsSize"] = 44,
                ["Reports"] = 
                {
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
                ["version"] = 1,
                ["data"] = 
                {
                },
            },
        },
    },
}
