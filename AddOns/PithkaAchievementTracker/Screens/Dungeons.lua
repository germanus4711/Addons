-- Initialize File
PITHKA           = PITHKA or {}
PITHKA.Screens   = PITHKA.Screens or {}
PITHKA.Screens.Dungeons = {}



function PITHKA.Screens.Dungeons.initialize()
    local _v  = function() return PITHKA.SV.state.currentScreen == 'dungeon' end
    local _is = PITHKA.UI.Constants.iconSize
    local _vExtra = function() return PITHKA.SV.state.currentScreen == 'dungeon' and PITHKA.SV.state.showExtra end
    local _vWater = function() return PITHKA.SV.state.currentScreen == 'dungeon' and PITHKA.SV.state.showWatermark end

    --m
    local t = {{
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=155,  t="DUNGEONS"},
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=_is,  t="VET",      tt="Veteran",  align=TEXT_ALIGN_CENTER},
        PITHKA.UI.Misc.spacer{  v=_v, w=20},
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=_is,  t="HM",       tt="Hard Mode",  align=TEXT_ALIGN_CENTER},
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=_is,  t="SR",       tt="Speed Run",  align=TEXT_ALIGN_CENTER},
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=_is,  t="ND",       tt="No Death",   align=TEXT_ALIGN_CENTER},
        PITHKA.UI.Misc.spacer{  v=_v, w=20},
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=270,  t='CHALLENGER & TRIFECTA' },
        PITHKA.UI.Labels.basic{ v=_vExtra, f="ZoFontGameSmall", w=200,  t='EXTRAS',   tt='Combat achievements at the challenger or trifecta difficulty'},
        }}


    -- create grid rows
    local rows = PITHKA.Data.Achievements.DBFilter({TYPE='dungeon'}) 
    local blue = PITHKA.UI.Constants.rgbBlue
    for _, row in pairs(rows) do
        t[#t+1] =  {
            PITHKA.UI.Labels.teleport{v=_v, t=row.NAME, w=155, c=PITHKA.UI.Constants.rgbBlue, vQueue=row.vQueue, nQueue=row.nQueue, portID=row.portID},
            PITHKA.UI.Icons.achievement{v=_v, a=row.VET},
            PITHKA.UI.Misc.spacer{v=_v, w=20},
            PITHKA.UI.Icons.achievement{v=_v, a=row.HM},
            PITHKA.UI.Icons.achievement{v=_v, a=row.SR},
            PITHKA.UI.Icons.achievement{v=_v, a=row.ND},
            PITHKA.UI.Misc.spacer{v=_v, w=20},
            PITHKA.UI.Icons.achievement{v=_v, a=row.CHA},
            PITHKA.UI.Icons.achievement{v=_v, a=row.TRI},
            PITHKA.UI.Labels.achievement{v=_v, t=row.TRINAME, w=210, a=row.TRI},
            PITHKA.UI.Icons.achievement{v=_vExtra, a=row.EXT},
            PITHKA.UI.Labels.achievement{v=_vExtra, t=row.EXTNAME, w=200, a=row.EXT},
        }
    end

    -- anchor grid
    PITHKA.UI.Layout.anchorGrid(t, PITHKA.UI.Layout.anchor(40, 60))

    -- watermarks
    local w = {
        PITHKA.UI.Labels.watermark{v=_vWater, t=GetDisplayName(), vOffset=-200},
        PITHKA.UI.Labels.watermark{v=_vWater, t=os.date('%b %d,   %Y'), vOffset=0},
        PITHKA.UI.Labels.watermark{v=_vWater, t=GetDisplayName(), vOffset=200},
    } -- anchor not required for watermark, handled in label function
    
    -- summary config
    local control
    local options  = {'~ Dungeon Summary ~', 
                    'Hard Dungeoneers',
                    'The Four Musketeers',
                    'TEAM MATES',
                    'EZ HM',
                    'Random Daily Guild',
                    }
    local stateVar = 'dungeonSummary'
    
    -- summary menu
    PITHKA.SV.state[stateVar] = PITHKA.SV.state[stateVar] or '~ Dungeon Summary ~' -- set default for state variable
    control = PITHKA.UI.Misc.menuButton{v=_v, options=options, stateVar=stateVar}
    control:SetAnchor(BOTTOMLEFT, PITHKA_GUI, BOTTOMLEFT, 0, 0)
    
    -- summary label
    control = PITHKA.UI.Labels.stateBased{v=_v, textFnLibrary=PITHKA.Data.Ranks.summaries, stateVar=stateVar, w=400, vAlign=TEXT_ALIGN_BOTTOM}
    control:SetAnchor(BOTTOMLEFT, PITHKA_GUI, BOTTOMLEFT, PITHKA.UI.Constants.iconSize, 0)

end


