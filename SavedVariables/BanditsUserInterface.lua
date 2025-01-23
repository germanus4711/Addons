BUI_VARS =
{
    ["Default"] = 
    {
        ["@germanus4711"] = 
        {
            ["$AccountWide"] = 
            {
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
                            ["icon"] = "/esoui/art/mounts/ridingskill_ready.dds",
                            ["command"] = "/reloadui",
                            ["enable"] = true,
                        },
                        [2] = 
                        {
                            ["icon"] = "/esoui/art/icons/ability_warrior_010.dds",
                            ["command"] = "/script StartChatInput('/z Guild [name] recruits new members!')",
                            ["enable"] = false,
                        },
                        [3] = 
                        {
                            ["icon"] = "/esoui/art/icons/ability_mage_066.dds",
                            ["command"] = "/dancedunmer",
                            ["enable"] = false,
                        },
                        [4] = 
                        {
                            ["icon"] = "/esoui/art/icons/ability_rogue_062.dds",
                            ["command"] = "/script ZO_CompassFrame:SetHidden(not ZO_CompassFrame:IsHidden())",
                            ["enable"] = true,
                        },
                        [5] = 
                        {
                            ["icon"] = "/esoui/art/icons/emote_mimewall.dds",
                            ["command"] = "/mimewall",
                            ["enable"] = false,
                        },
                        [6] = 
                        {
                            ["icon"] = "/esoui/art/icons/quest_gemstone_tear_0002.dds",
                            ["command"] = "/script UseCollectible(336)",
                            ["enable"] = true,
                        },
                        [7] = 
                        {
                            ["icon"] = "/esoui/art/tutorial/gamepad/gp_playermenu_icon_store.dds",
                            ["command"] = "/jumptoleader",
                            ["enable"] = false,
                        },
                        [8] = 
                        {
                            ["icon"] = "esoui/art/tutorial/chat-notifications_up.dds",
                            ["command"] = "/script zo_callLater(function() local name=GetUnitDisplayName('reticleover') if name then StartChatInput('/w '..name..' ') else a('No target') end end,100)",
                            ["enable"] = false,
                        },
                        [9] = 
                        {
                            ["icon"] = "/esoui/art/inventory/gamepad/gp_inventory_icon_stolenitem.dds",
                            ["command"] = "/script d(AreAnyItemsStolen(BAG_BACKPACK) and 'Have stolen items' or 'Have no stolen items')",
                            ["enable"] = false,
                        },
                        [10] = 
                        {
                            ["icon"] = "/esoui/art/icons/ability_ava_005_a.dds",
                            ["command"] = "/script local _,i=GetAbilityProgressionXPInfoFromAbilityId(40232) local _,m,r=GetAbilityProgressionInfo(i) local _,_,index=GetAbilityProgressionAbilityInfo(i,m,r) CallSecureProtected('SelectSlotAbility', index, 3)",
                            ["enable"] = false,
                        },
                        [11] = 
                        {
                            ["icon"] = "/esoui/art/progression/morph_up.dds",
                            ["command"] = "/script BUI.Vars.EnableWidgets=not BUI.Vars.EnableWidgets BUI.Frames.Widgets_Init() d('Widgets are now '..(BUI.Vars.EnableWidgets and '|c33EE33enabled|r' or '|EE3333disabled|r'))",
                            ["enable"] = false,
                        },
                        [12] = 
                        {
                            ["icon"] = "Text",
                            ["command"] = "/script local text='Another sample'd(text) a(text)",
                            ["enable"] = false,
                        },
                    },
                    ["Enable"] = false,
                },
                ["BUI_OnScreen"] = 
                {
                    [4] = -110,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["Meter_Crit"] = false,
                ["BUI_BuffsP"] = 
                {
                    [4] = 345,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["FrameStaminaColor"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.5490196078,
                    [3] = 0.1176470588,
                },
                ["SynergyCdDirection"] = "vertical",
                ["ShowDots"] = true,
                ["BlockAnnouncement"] = false,
                ["CustomBuffsPWidth"] = 120,
                ["SynergyCdPSide"] = "right",
                ["DefaultPlayerFrames"] = false,
                ["StatsMiniSpeed"] = false,
                ["ZoomZone"] = 60,
                ["CurvedHeight"] = 360,
                ["FrameTankColor"] = 
                {
                    [1] = 0.8588235294,
                    [2] = 0.5607843137,
                    [3] = 1,
                },
                ["Widgets"] = 
                {
                    [110143] = true,
                    ["Major Brutality"] = true,
                    [110142] = true,
                    [110067] = true,
                    ["Major Resolve"] = true,
                    [107141] = true,
                    ["Immovable"] = true,
                    [61927] = true,
                    [110118] = true,
                    ["Major Sorcery"] = true,
                    [104538] = true,
                    [46327] = true,
                    [109084] = true,
                    [126941] = true,
                    ["Major Courage"] = true,
                    [61919] = true,
                },
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
                ["PinScale"] = 75,
                ["TargetBuffSize"] = 44,
                ["LargeRaidScale"] = 80,
                ["FrameMagickaColor1"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.4784313725,
                    [3] = 1,
                },
                ["GroupDeathSound"] = "Lockpicking_unlocked",
                ["LargeGroupAnnoucement"] = true,
                ["HousePins"] = 4,
                ["EffectVisualisation"] = true,
                ["Meter_Power"] = false,
                ["StatsGroupDPS"] = false,
                ["NotificationsTrial"] = true,
                ["FrameWidth"] = 280,
                ["BUI_MiniMeter"] = 
                {
                    [4] = 0,
                    [1] = 9,
                    [2] = 1,
                    [3] = -400,
                },
                ["StatsFontSize"] = 18,
                ["BUI_BuffsPas"] = 
                {
                    [4] = 0,
                    [1] = 12,
                    [2] = 12,
                    [3] = 0,
                },
                ["PreferredTarget"] = true,
                ["SynergyCdPWidth"] = 120,
                ["BlockIndicator"] = true,
                ["ActionsPrecise"] = true,
                ["LeaderArrow"] = true,
                ["FrameHeight"] = 22,
                ["FramesBorder"] = 2,
                ["UltimateOrder"] = 2,
                ["WidgetSound2"] = "CrownCrates_Manifest_Selected",
                ["CurvedStatValues"] = true,
                ["HideSwapPanel"] = true,
                ["TargetHeight"] = 22,
                ["RaidSort"] = 1,
                ["CustomBuffsProgress"] = true,
                ["CustomBuffs"] = 
                {
                },
                ["PvPmodeAnnouncement"] = true,
                ["BUI_TargetFrame"] = 
                {
                    [4] = 200,
                    [1] = 3,
                    [2] = 128,
                    [3] = 250,
                },
                ["PlayerBuffsAlign"] = 128,
                ["AdvancedThemeColor"] = 
                {
                    [4] = 0.9000000000,
                    [1] = 0.5000000000,
                    [2] = 0.6000000000,
                    [3] = 1,
                },
                ["PassiveBuffSize"] = 36,
                ["BUI_GroupDPS"] = 
                {
                    [4] = 120,
                    [1] = 3,
                    [2] = 1,
                    [3] = -400,
                },
                ["GroupElection"] = true,
                ["PlayerFrame"] = false,
                ["QuickSlotsShow"] = 4,
                ["FrameNameFormat"] = 1,
                ["RepositionFrames"] = true,
                ["LastVersion"] = 4.4250000000,
                ["ZoomCyrodiil"] = 45,
                ["FrameTraumaColor"] = 
                {
                    [4] = 1,
                    [1] = 0.5882352941,
                    [2] = 0.1960784314,
                    [3] = 1,
                },
                ["DeleteMail"] = true,
                ["MarkerLeader"] = false,
                ["StatShare"] = false,
                ["ReticleInvul"] = false,
                ["BossWidth"] = 280,
                ["EnableStats"] = true,
                ["GroupAnimation"] = true,
                ["RepeatableQuests"] = false,
                ["WidgetsPWidth"] = 120,
                ["ActionSlots"] = true,
                ["FrameMagickaColor"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.1176470588,
                    [3] = 0.8627450980,
                },
                ["ReticleResist"] = 1,
                ["RaidLevels"] = true,
                ["NotificationsGroup"] = true,
                ["NotificationsSize"] = 32,
                ["BuiltInGlobalCooldown"] = true,
                ["WidgetSound1"] = "CrownCrates_Manifest_Chosen",
                ["ZoomDungeon"] = 60,
                ["FrameShowMax"] = true,
                ["StatsBuffs"] = true,
                ["ExecuteSound"] = true,
                ["FullSwapPanel"] = false,
                ["ActionsFontSize"] = 16,
                ["NotificationsTimer"] = 3000,
                ["StatsUpdateDPS"] = false,
                ["MiniMapTitle"] = true,
                ["ZoomImperialCity"] = 80,
                ["BossHeight"] = 28,
                ["TargetWidth"] = 320,
                ["RaidColumnSize"] = 6,
                ["QuickSlots"] = true,
                ["UndauntedPledges"] = true,
                ["PvPmode"] = true,
                ["Meter_Exp"] = true,
                ["CollapseNormalDungeon"] = false,
                ["FriendStatus"] = true,
                ["StatsGroupDPSframe"] = false,
                ["BUI_BuffsT"] = 
                {
                    [4] = -350,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["PassivePWidth"] = 100,
                ["TargetBuffsAlign"] = 128,
                ["StatsSplitElements"] = true,
                ["InCombatReticle"] = true,
                ["ColorRoles"] = true,
                ["SelfColor"] = true,
                ["DefaultTargetFrame"] = true,
                ["ZoomMountRatio"] = 70,
                ["ContainerHandler"] = true,
                ["AttackersWidth"] = 280,
                ["BUI_BuffsS"] = 
                {
                    [4] = 200,
                    [1] = 128,
                    [2] = 128,
                    [3] = -300,
                },
                ["FrameStaminaColor1"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.8235294118,
                    [3] = 0.0784313725,
                },
                ["StatsTransparent"] = true,
                ["ShieldGroup"] = true,
                ["ProcAnimation"] = true,
                ["InitialDialog"] = true,
                ["SidePanel"] = 
                {
                    ["GearManager"] = true,
                    ["DismissPets"] = true,
                    ["LFG_Role"] = true,
                    ["Smuggler"] = true,
                    ["Enable"] = true,
                    ["VeteranDifficulty"] = true,
                    ["Share"] = true,
                    ["LeaderArrow"] = true,
                    ["Teleporter"] = true,
                    ["Trader"] = true,
                    ["SubSampling"] = true,
                    ["Widgets"] = true,
                    ["Compass"] = true,
                    ["Banker"] = true,
                    ["Ragpicker"] = true,
                    ["Statistics"] = true,
                    ["Minimap"] = true,
                    ["Settings"] = true,
                    ["HealerHelper"] = true,
                    ["Armorer"] = true,
                    ["WPamA"] = true,
                    ["AllowOther"] = true,
                },
                ["CustomBuffsDirection"] = "vertical",
                ["StatsShareDPS"] = false,
                ["TauntTimerSource"] = true,
                ["FrameHorisontal"] = true,
                ["EnableNameplate"] = false,
                ["RaidWidth"] = 220,
                ["ReticleMode"] = 4,
                ["SwapIndicator"] = true,
                ["FramePercents"] = false,
                ["NotificationFood"] = true,
                ["CurvedDistance"] = 240,
                ["Books"] = true,
                ["CurvedHitAnimation"] = false,
                ["FrameTraumaColor1"] = 
                {
                    [4] = 1,
                    [1] = 0.2941176471,
                    [2] = 0,
                    [3] = 0.5882352941,
                },
                ["RaidFrames"] = true,
                ["FrameShieldColor"] = 
                {
                    [4] = 1,
                    [1] = 0.9803921569,
                    [2] = 0.3921568627,
                    [3] = 0.0784313725,
                },
                ["BuffsBlackList"] = 
                {
                    [63601] = true,
                    [14890] = true,
                    [76667] = true,
                },
                ["CustomBuffsPSide"] = "right",
                ["GroupLeave"] = true,
                ["ReportScale"] = 1,
                ["RaidFontSize"] = 17,
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
                ["MiniMap"] = false,
                ["FrameFont2"] = "esobold",
                ["MarkerSize"] = 40,
                ["Shield"] = true,
                ["CurvedOffset"] = -100,
                ["StatsMiniGroupDps"] = true,
                ["TargetFrame"] = false,
                ["BUI_PlayerFrame"] = 
                {
                    [4] = 200,
                    [1] = 9,
                    [2] = 128,
                    [3] = -250,
                },
                ["TauntTimer"] = 1,
                ["AttackersHeight"] = 28,
                ["CurvedFrame"] = 2,
                ["DeveloperMode"] = false,
                ["DarkBrotherhoodSpree"] = false,
                ["DefaultTargetFrameText"] = true,
                ["FrameOpacityOut"] = 70,
                ["TraumaGroup"] = true,
                ["GroupSynergyCount"] = 2,
                ["BossFrame"] = true,
                ["BUI_BuffsC"] = 
                {
                    [4] = 300,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["Log"] = false,
                ["Actions"] = true,
                ["PlayerToPlayer"] = true,
                ["SmallGroupScale"] = 120,
                ["JumpToLeader"] = false,
                ["TargetBuffs"] = true,
                ["ZoomGlobal"] = 3,
                ["AutoDismissPet"] = true,
                ["LootStolen"] = true,
                ["RaidHeight"] = 32,
                ["FrameDamageColor"] = 
                {
                    [1] = 0.8784313725,
                    [2] = 0.1098039216,
                    [3] = 0.1098039216,
                },
                ["Reports"] = 
                {
                },
                ["BuffsImportant"] = true,
                ["ZoomImperialsewer"] = 60,
                ["PassiveOakFilter"] = true,
                ["CurvedShift"] = false,
                ["StatusIcons"] = true,
                ["CastBar"] = 1,
                ["FrameHealthColor"] = 
                {
                    [4] = 1,
                    [1] = 0.5882352941,
                    [2] = 0.1176470588,
                    [3] = 0.2352941176,
                },
                ["FoodBuff"] = true,
                ["EnableCustomBuffs"] = false,
                ["MiniMapDimensions"] = 250,
                ["BUI_HPlayerFrame"] = 
                {
                    [4] = 410,
                    [1] = 128,
                    [2] = 128,
                    [3] = 0,
                },
                ["NotificationSound_2"] = "No_Sound",
                ["StealthWield"] = true,
                ["CastbyPlayer"] = true,
                ["version"] = 3,
                ["FrameHealthColor1"] = 
                {
                    [4] = 1,
                    [1] = 1,
                    [2] = 0.1568627451,
                    [3] = 0.2745098039,
                },
                ["TargetFrameTextAlign"] = "default",
                ["StatShareUlt"] = 3,
                ["FramesTexture"] = "rounded",
                ["MinimumDuration"] = 3,
                ["PrimaryStat"] = 1,
                ["BUI_Minimap"] = 
                {
                    [4] = 0,
                    [1] = 9,
                    [2] = 9,
                    [3] = 0,
                },
                ["AdvancedSynergy"] = false,
                ["CustomBuffSize"] = 44,
                ["FramesFade"] = true,
                ["SynergyCdProgress"] = true,
                ["EnableXPBar"] = true,
                ["WidgetPotion"] = true,
                ["EnableBlackList"] = true,
                ["StatsMiniMeter"] = true,
                ["ZoomSubZone"] = 30,
                ["FrameFontSize"] = 15,
                ["GroupSynergy"] = 3,
                ["GroupBuffs"] = false,
                ["PlayerBuffSize"] = 44,
                ["StatsMiniHealing"] = false,
                ["Meter_Speed"] = true,
                ["BuffsPassives"] = "On additional panel",
                ["BUI_OnScreenS"] = 
                {
                    [4] = -210,
                    [1] = 128,
                    [2] = 128,
                    [3] = 360,
                },
                ["CustomEdgeColor"] = 
                {
                    [4] = 1,
                    [1] = 0,
                    [2] = 0.0700000000,
                    [3] = 0.0700000000,
                },
                ["ReticleDpS"] = true,
                ["PassivePSide"] = "left",
                ["RaidSplit"] = 0,
                ["StatTriggerHeals"] = false,
                ["BuffsOtherHide"] = true,
                ["AutoQueue"] = true,
                ["EnableSynergyCd"] = false,
                ["QuickSlotsInventory"] = true,
                ["DecimalValues"] = true,
                ["ImpactAnimation"] = true,
                ["ProcSound"] = "Ability_Ultimate_Ready_Sound",
                ["ConfirmLocked"] = true,
                ["FrameHealerColor"] = 
                {
                    [1] = 1,
                    [2] = 0.7568627451,
                    [3] = 0.4980392157,
                },
                ["NotificationSound_1"] = "Champion_PointsCommitted",
                ["NotificationsWorld"] = true,
                ["EnableWidgets"] = false,
                ["MiniMeterAplha"] = 0.8000000000,
                ["OnScreenPriorDeath"] = true,
                ["FrameFont1"] = "esobold",
                ["FrameShieldColor1"] = 
                {
                    [4] = 1,
                    [1] = 0.9019607843,
                    [2] = 0.3921568627,
                    [3] = 0.0784313725,
                },
                ["BUI_RaidFrame"] = 
                {
                    [4] = 160,
                    [1] = 3,
                    [2] = 3,
                    [3] = 50,
                },
                ["CurvedShiftAnimation"] = false,
                ["Glyphs"] = true,
                ["LargeGroupInvite"] = true,
                ["Theme"] = 2,
                ["FastTravel"] = true,
                ["DodgeFatigue"] = true,
                ["Trauma"] = true,
                ["ReticleBoost"] = true,
                ["CurvedDepth"] = 0.8000000000,
                ["PassiveProgress"] = false,
                ["WidgetsSize"] = 44,
                ["ExecuteThreshold"] = 25,
                ["FrameOpacityIn"] = 90,
                ["DisableHelpAnnounce"] = false,
                ["SynergyCdSize"] = 44,
                ["PlayerBuffs"] = true,
                ["ExpiresAnimation"] = true,
                ["UseSwapPanel"] = true,
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
