-- Initialize File
PITHKA           = PITHKA or {}
PITHKA.Screens   = PITHKA.Screens or {}
PITHKA.Screens.Trials = {}




function PITHKA.Screens.Trials.initialize()
    local _v  = function() return PITHKA.SV.state.currentScreen == 'trial' end
    local _is = PITHKA.UI.Constants.iconSize
    local _vExtra = function() return PITHKA.SV.state.currentScreen == 'trial' and PITHKA.SV.state.showExtra end
    local _vWater = function() return PITHKA.SV.state.currentScreen == 'trial' and PITHKA.SV.state.showWatermark end
    
    -- create grid header
    local t = {{
        PITHKA.UI.Labels.basic{v=_v, f="ZoFontGameSmall", w=155, t="TRIALS"},
        PITHKA.UI.Labels.basic{v=_v, f="ZoFontGameSmall", w=75,  t="BEST SCORE", align=TEXT_ALIGN_RIGHT},
        PITHKA.UI.Misc.spacer{ v=_v, w=20},
        PITHKA.UI.Labels.basic{v=_v, f="ZoFontGameSmall", w=46, t="VET"},
        PITHKA.UI.Labels.basic{v=_v, f="ZoFontGameSmall", w=103, t="PARTIAL HM"},
        PITHKA.UI.Labels.basic{v=_v, f="ZoFontGameSmall", w=106, t="PARTIAL HM"},
        PITHKA.UI.Labels.basic{v=_v, f="ZoFontGameSmall", w=148, t="HARDMODE"},
        PITHKA.UI.Labels.basic{v=_v, f="ZoFontGameSmall", w=216, t="TRIFECTA"},
        PITHKA.UI.Labels.basic{v=_vExtra, f="ZoFontGameSmall", w=150, t="EXTRA"},
        }}


    -- create grid rows
    local rows = PITHKA.Data.Achievements.DBFilter({TYPE='trial'}) 
    local blue = PITHKA.UI.Constants.rgbBlue
    for _, row in pairs(rows) do
        t[#t+1] =  {
            PITHKA.UI.Labels.teleport{v=_v, w=150, t=row.NAME, c=PITHKA.UI.Constants.rgbBlue, portID=row.portID},
            PITHKA.UI.Labels.score{v=_v, w=75, abbv=row.ABBV, align=TEXT_ALIGN_RIGHT},
            PITHKA.UI.Misc.spacer{ v=_v, w=20},

            PITHKA.UI.Icons.achievement{v=_v, a=row.VET},
            PITHKA.UI.Misc.spacer{ v=_v, w=20},

            PITHKA.UI.Icons.achievement{ v=_v, a=row.PHM1},
            PITHKA.UI.Labels.achievement{v=_v, a=row.PHM1, t=row.PHM1NAME, w=80},

            PITHKA.UI.Icons.achievement{ v=_v, a=row.PHM2},
            PITHKA.UI.Labels.achievement{v=_v, a=row.PHM2, t=row.PHM2NAME, w=80},

            PITHKA.UI.Icons.achievement{ v=_v, a=row.HM},
            PITHKA.UI.Labels.achievement{v=_v, a=row.HM, t=row.HMNAME, w=120},

            PITHKA.UI.Icons.achievement{ v=_v, a=row.TRI},
            PITHKA.UI.Labels.achievement{v=_v, a=row.TRI, t=row.TRINAME, w=190},

            PITHKA.UI.Icons.achievement{ v=_vExtra, a=row.EXT},
            PITHKA.UI.Labels.achievement{v=_vExtra, a=row.EXT, t=row.EXTNAME, w=200},
        }
    end

    -- anchor grid
    PITHKA.UI.Layout.anchorGrid(t, PITHKA.UI.Layout.anchor(40, 60))

    -- watermarks
    local w = {        
        PITHKA.UI.Labels.watermark{v=_vWater, t=os.date('%b %d,   %Y'), vOffset=-75},
        PITHKA.UI.Labels.watermark{v=_vWater, t=GetDisplayName(), vOffset=75},
    } -- anchor not required for watermark, handled in label function

    
    -- summary config
    local control
    local options  = {'~ Trial Summary ~', 
                    'Aedra',
                    'Black Dragon Defenders',
--                    'Bora pro Wipe',
--                    'ESO Runs',
--                    'Rose ESO',
                    'Heart of Tamriel',
                    'One More Pull', 
                    'Seas of Oblivion',
                    'The Ashen Guard',
                    'The Grand Alliance', 
                    'The Union of Disorder',
                    }
    local stateVar = 'trialSummary'

    -- quick hack to remove a guild option
    -- if a user has the removed guild selected, the label function fails an assertion
    -- fix is to simply remove it from the saved variable
    if PITHKA.SV.state[stateVar] == 'Rose ESO' then PITHKA.SV.state[stateVar] = nil end
    if PITHKA.SV.state[stateVar] == 'ESO Runs' then PITHKA.SV.state[stateVar] = nil end
    if PITHKA.SV.state[stateVar] == 'Bora pro Wipe' then PITHKA.SV.state[stateVar] = nil end


    -- summary menu
    PITHKA.SV.state[stateVar] = PITHKA.SV.state[stateVar] or '~ Trial Summary ~' -- set default for state variable
    control = PITHKA.UI.Misc.menuButton{v=_v, options=options, stateVar=stateVar}
    control:SetAnchor(BOTTOMLEFT, PITHKA_GUI, BOTTOMLEFT, 0, 0)
    
    -- summary label
    control = PITHKA.UI.Labels.stateBased{v=_v, textFnLibrary=PITHKA.Data.Ranks.summaries, stateVar=stateVar, w=650, vAlign=TEXT_ALIGN_BOTTOM}
    control:SetAnchor(BOTTOMLEFT, PITHKA_GUI, BOTTOMLEFT, PITHKA.UI.Constants.iconSize, 0)
   
    -- ESO Runs icon
    local control = PITHKA.UI.Icons.basic({
        v = function() return PITHKA.SV.state.currentScreen == 'trial' and PITHKA.SV.state['trialSummary'] == "ESO Runs" end,
        s = 48, 
        t = "/PithkaAchievementTracker/Assets/esoruns.dds"
    })
    control:SetAnchor(BOTTOMLEFT, PITHKA_GUI, BOTTOMLEFT, 130, 10)

end
