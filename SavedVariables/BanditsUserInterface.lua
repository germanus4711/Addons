BUI_VARS =
{
    ["Default"] = 
    {
        ["@germanus4711"] = 
        {
            ["$AccountWide"] = 
            {
                ["ActionSlots"] = true,
                ["GroupBuffs"] = false,
                ["Glyphs"] = true,
                ["DefaultPlayerFrames"] = false,
                ["TauntTimer"] = 1,
                ["PlayerBuffsAlign"] = 128,
                ["TargetHeight"] = 22,
                ["QuickSlotsInventory"] = true,
                ["MarkerLeader"] = false,
                ["PlayerToPlayer"] = true,
                ["CurvedDepth"] = 0.8000000000,
                ["GroupSynergy"] = 3,
                ["DecimalValues"] = true,
                ["ZoomImperialsewer"] = 60,
                ["AutoDismissPet"] = true,
                ["FrameMagickaColor1"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.4784313725,
                    [3] = 1,
                },
                ["ProcAnimation"] = true,
                ["version"] = 3,
                ["SynergyCdPWidth"] = 120,
                ["LeaderArrow"] = true,
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
                    ["Enable"] = false,
                },
                ["EnableCustomBuffs"] = false,
                ["BlockIndicator"] = true,
                ["FramePercents"] = false,
                ["RaidHeight"] = 32,
                ["SynergyCdDirection"] = "vertical",
                ["Books"] = true,
                ["WidgetsSize"] = 44,
                ["OnScreenPriorDeath"] = true,
                ["Meter_Power"] = false,
                ["SmallGroupScale"] = 120,
                ["TargetBuffsAlign"] = 128,
                ["BUI_MiniMeter"] = 
                {
                    [4] = 0,
                    [1] = 9,
                    [2] = 1,
                    [3] = -400,
                },
                ["CurvedHitAnimation"] = false,
                ["FrameTankColor"] = 
                {
                    [1] = 0.8588235294,
                    [2] = 0.5607843137,
                    [3] = 1,
                },
                ["ExecuteThreshold"] = 25,
                ["AdvancedSynergy"] = false,
                ["GroupDeathSound"] = "Lockpicking_unlocked",
                ["FrameShowMax"] = true,
                ["BUI_HPlayerFrame"] = 
                {
                    [4] = 410,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["StatusIcons"] = true,
                ["TraumaGroup"] = true,
                ["BossHeight"] = 28,
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
                ["AutoQueue"] = true,
                ["CurvedHeight"] = 360,
                ["InCombatReticle"] = true,
                ["GroupLeave"] = true,
                ["StatsSplitElements"] = true,
                ["ShieldGroup"] = true,
                ["RepositionFrames"] = true,
                ["GroupAnimation"] = true,
                ["StealthWield"] = true,
                ["FrameWidth"] = 280,
                ["MarkerSize"] = 40,
                ["FrameMagickaColor"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.1176470588,
                    [3] = 0.8627450980,
                },
                ["CustomBuffs"] = 
                {
                },
                ["BossWidth"] = 280,
                ["UseSwapPanel"] = true,
                ["ReticleInvul"] = false,
                ["BUI_BuffsT"] = 
                {
                    [4] = -350,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["CurvedOffset"] = -100,
                ["LargeGroupInvite"] = true,
                ["Meter_Speed"] = true,
                ["RaidFrames"] = true,
                ["PlayerBuffSize"] = 44,
                ["GroupElection"] = true,
                ["LargeGroupAnnoucement"] = true,
                ["WidgetSound1"] = "CrownCrates_Manifest_Chosen",
                ["EnableStats"] = true,
                ["PlayerBuffs"] = true,
                ["ReportScale"] = 1,
                ["BossFrame"] = true,
                ["ZoomMountRatio"] = 70,
                ["SynergyCdSize"] = 44,
                ["RaidWidth"] = 220,
                ["WidgetsPWidth"] = 120,
                ["FoodBuff"] = true,
                ["ReticleMode"] = 4,
                ["EnableNameplate"] = false,
                ["CurvedFrame"] = 2,
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
                ["StatShare"] = false,
                ["LargeRaidScale"] = 80,
                ["Meter_Crit"] = false,
                ["FrameStaminaColor1"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.8235294118,
                    [3] = 0.0784313725,
                },
                ["FrameHorisontal"] = true,
                ["SynergyCdProgress"] = true,
                ["BUI_OnScreen"] = 
                {
                    [4] = -110,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["ExecuteSound"] = true,
                ["CustomBuffSize"] = 44,
                ["StatsBuffs"] = true,
                ["Shield"] = true,
                ["NotificationsTrial"] = true,
                ["RaidFontSize"] = 17,
                ["BUI_OnScreenS"] = 
                {
                    [4] = -210,
                    [1] = 128,
                    [2] = 128,
                    [3] = 360,
                },
                ["FrameShieldColor1"] = 
                {
                    [4] = 1,
                    [1] = 0.9019607843,
                    [2] = 0.3921568627,
                    [3] = 0.0784313725,
                },
                ["ActionsPrecise"] = true,
                ["PassiveProgress"] = false,
                ["PinScale"] = 75,
                ["BUI_BuffsP"] = 
                {
                    [4] = 345,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["SwapIndicator"] = true,
                ["Widgets"] = 
                {
                    [110143] = true,
                    ["Major Resolve"] = true,
                    ["Immovable"] = true,
                    [110067] = true,
                    ["Major Courage"] = true,
                    [107141] = true,
                    [110118] = true,
                    ["Major Brutality"] = true,
                    [61927] = true,
                    [46327] = true,
                    [104538] = true,
                    ["Major Sorcery"] = true,
                    [109084] = true,
                    [126941] = true,
                    [110142] = true,
                    [61919] = true,
                },
                ["MiniMeterAplha"] = 0.8000000000,
                ["BUI_PlayerFrame"] = 
                {
                    [4] = 200,
                    [1] = 9,
                    [2] = 128,
                    [3] = -250,
                },
                ["FrameHealerColor"] = 
                {
                    [1] = 1,
                    [2] = 0.7568627451,
                    [3] = 0.4980392157,
                },
                ["Trauma"] = true,
                ["CustomBuffsProgress"] = true,
                ["HousePins"] = 4,
                ["FrameStaminaColor"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.5490196078,
                    [3] = 0.1176470588,
                },
                ["BlockAnnouncement"] = false,
                ["TargetBuffSize"] = 44,
                ["FrameOpacityOut"] = 70,
                ["FrameFont2"] = "esobold",
                ["MiniMapDimensions"] = 250,
                ["TargetFrameTextAlign"] = "default",
                ["CustomBuffsPSide"] = "right",
                ["DeveloperMode"] = false,
                ["StatTriggerHeals"] = false,
                ["RaidSplit"] = 0,
                ["StatsMiniHealing"] = false,
                ["ZoomImperialCity"] = 80,
                ["CurvedShiftAnimation"] = false,
                ["AttackersWidth"] = 280,
                ["StatsGroupDPS"] = false,
                ["StatsMiniMeter"] = true,
                ["CastbyPlayer"] = true,
                ["ZoomGlobal"] = 3,
                ["TargetBuffs"] = true,
                ["ZoomZone"] = 60,
                ["UndauntedPledges"] = true,
                ["CurvedStatValues"] = true,
                ["ExpiresAnimation"] = true,
                ["StatsShareDPS"] = false,
                ["StatsUpdateDPS"] = false,
                ["AttackersHeight"] = 28,
                ["DodgeFatigue"] = true,
                ["BuiltInGlobalCooldown"] = true,
                ["ConfirmLocked"] = true,
                ["ZoomDungeon"] = 60,
                ["QuickSlots"] = true,
                ["MinimumDuration"] = 3,
                ["CastBar"] = 1,
                ["ZoomCyrodiil"] = 45,
                ["ImpactAnimation"] = true,
                ["FullSwapPanel"] = false,
                ["DeleteMail"] = true,
                ["PvPmodeAnnouncement"] = true,
                ["ReticleDpS"] = true,
                ["PassivePWidth"] = 100,
                ["FrameFontSize"] = 15,
                ["FrameNameFormat"] = 1,
                ["FrameTraumaColor1"] = 
                {
                    [4] = 1,
                    [1] = 0.2941176471,
                    [2] = 0,
                    [3] = 0.5882352941,
                },
                ["StatsMiniGroupDps"] = true,
                ["CustomEdgeColor"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.0700000000,
                    [3] = 0.0700000000,
                },
                ["ContainerHandler"] = true,
                ["ProcSound"] = "Ability_Ultimate_Ready_Sound",
                ["BUI_GroupDPS"] = 
                {
                    [4] = 120,
                    [1] = 3,
                    [2] = 1,
                    [3] = -400,
                },
                ["PreferredTarget"] = true,
                ["ActionsFontSize"] = 16,
                ["MiniMapTitle"] = true,
                ["BUI_BuffsPas"] = 
                {
                    [4] = 0,
                    [1] = 12,
                    [2] = 12,
                    [3] = 0,
                },
                ["FrameOpacityIn"] = 90,
                ["FrameShieldColor"] = 
                {
                    [4] = 1,
                    [1] = 0.9803921569,
                    [2] = 0.3921568627,
                    [3] = 0.0784313725,
                },
                ["StatsMiniSpeed"] = false,
                ["StatShareUlt"] = 3,
                ["NotificationsWorld"] = true,
                ["BUI_RaidFrame"] = 
                {
                    [4] = 160,
                    [1] = 3,
                    [2] = 3,
                    [3] = 50,
                },
                ["InitialDialog"] = true,
                ["QuickSlotsShow"] = 4,
                ["CustomBuffsPWidth"] = 120,
                ["FrameDamageColor"] = 
                {
                    [1] = 0.8784313725,
                    [2] = 0.1098039216,
                    [3] = 0.1098039216,
                },
                ["RaidLevels"] = true,
                ["CurvedShift"] = false,
                ["SynergyCdPSide"] = "right",
                ["DefaultTargetFrameText"] = true,
                ["JumpToLeader"] = false,
                ["LootStolen"] = true,
                ["PrimaryStat"] = 1,
                ["PassiveBuffSize"] = 36,
                ["DefaultTargetFrame"] = true,
                ["BUI_Minimap"] = 
                {
                    [4] = 0,
                    [1] = 9,
                    [2] = 9,
                    [3] = 0,
                },
                ["StatsTransparent"] = true,
                ["NotificationsSize"] = 32,
                ["BuffsImportant"] = true,
                ["FriendStatus"] = true,
                ["WidgetSound2"] = "CrownCrates_Manifest_Selected",
                ["EnableSynergyCd"] = false,
                ["SidePanel"] = 
                {
                    ["HealerHelper"] = true,
                    ["WPamA"] = true,
                    ["Widgets"] = true,
                    ["VeteranDifficulty"] = true,
                    ["Compass"] = true,
                    ["Share"] = true,
                    ["LeaderArrow"] = true,
                    ["Ragpicker"] = true,
                    ["GearManager"] = true,
                    ["Statistics"] = true,
                    ["LFG_Role"] = true,
                    ["Trader"] = true,
                    ["SubSampling"] = true,
                    ["Settings"] = true,
                    ["DismissPets"] = true,
                    ["Enable"] = true,
                    ["Minimap"] = true,
                    ["Smuggler"] = true,
                    ["AllowOther"] = true,
                    ["Teleporter"] = true,
                    ["Armorer"] = true,
                    ["Banker"] = true,
                },
                ["BuffsBlackList"] = 
                {
                    [63601] = true,
                    [14890] = true,
                    [76667] = true,
                },
                ["FramesFade"] = true,
                ["Actions"] = true,
                ["PassivePSide"] = "left",
                ["PvPmode"] = true,
                ["NotificationSound_2"] = "No_Sound",
                ["CollapseNormalDungeon"] = false,
                ["FrameHealthColor"] = 
                {
                    [4] = 1,
                    [1] = 0.5882352941,
                    [2] = 0.1176470588,
                    [3] = 0.2352941176,
                },
                ["ShowDots"] = true,
                ["GroupSynergyCount"] = 2,
                ["NotificationsGroup"] = true,
                ["HideSwapPanel"] = true,
                ["FastTravel"] = true,
                ["ColorRoles"] = true,
                ["FramesBorder"] = 2,
                ["RaidSort"] = 1,
                ["FrameFont1"] = "esobold",
                ["NotificationsTimer"] = 3000,
                ["CustomBuffsDirection"] = "vertical",
                ["TauntTimerSource"] = true,
                ["TargetWidth"] = 320,
                ["LastVersion"] = 4.4240000000,
                ["RepeatableQuests"] = false,
                ["PlayerFrame"] = false,
                ["BuffsOtherHide"] = true,
                ["NotificationSound_1"] = "Champion_PointsCommitted",
                ["CurvedDistance"] = 240,
                ["UltimateOrder"] = 2,
                ["FrameHealthColor1"] = 
                {
                    [4] = 1,
                    [1] = 1,
                    [2] = 0.1568627451,
                    [3] = 0.2745098039,
                },
                ["EnableXPBar"] = true,
                ["MiniMap"] = false,
                ["FramesTexture"] = "rounded",
                ["NotificationFood"] = true,
                ["ReticleBoost"] = true,
                ["BUI_BuffsC"] = 
                {
                    [4] = 300,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["TargetFrame"] = false,
                ["Reports"] = 
                {
                },
                ["FrameTraumaColor"] = 
                {
                    [4] = 1,
                    [1] = 0.5882352941,
                    [2] = 0.1960784314,
                    [3] = 1,
                },
                ["StatsGroupDPSframe"] = false,
                ["StatsFontSize"] = 18,
                ["FrameHeight"] = 22,
                ["Theme"] = 2,
                ["Meter_Exp"] = true,
                ["WidgetPotion"] = true,
                ["DisableHelpAnnounce"] = false,
                ["Log"] = false,
                ["PassiveOakFilter"] = true,
                ["DarkBrotherhoodSpree"] = false,
                ["BUI_TargetFrame"] = 
                {
                    [4] = 200,
                    [1] = 3,
                    [2] = 128,
                    [3] = 250,
                },
                ["RaidColumnSize"] = 6,
                ["EnableBlackList"] = true,
                ["BUI_BuffsS"] = 
                {
                    [4] = 200,
                    [1] = 128,
                    [2] = 128,
                    [3] = -300,
                },
                ["ReticleResist"] = 1,
                ["SelfColor"] = true,
                ["EnableWidgets"] = false,
                ["EffectVisualisation"] = true,
                ["AdvancedThemeColor"] = 
                {
                    [4] = 0.9000000000,
                    [1] = 0.5000000000,
                    [2] = 0.6000000000,
                    [3] = 1,
                },
                ["BuffsPassives"] = "On additional panel",
                ["ZoomSubZone"] = 30,
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
