-- Initialize File
PITHKA           = PITHKA or {}
PITHKA.Screens   = PITHKA.Screens or {}
PITHKA.Screens.Trifectas = {}

function PITHKA.Screens.Trifectas.initialize()
    local _v  = function() return PITHKA.SV.state.currentScreen == 'trifecta' end
    local _vWater = function() return PITHKA.SV.state.currentScreen == 'trifecta' and PITHKA.SV.state.showWatermark end
    local _is = PITHKA.UI.Constants.iconSize
    local blue = PITHKA.UI.Constants.rgbBlue

    -- LEFT COLUMN WITH SCORE
    -- create header
    local t = {{
        PITHKA.UI.Labels.basic{v=_v, f="ZoFontGameSmall", w=155, t="TRIALS", tt="Click to port"},
        PITHKA.UI.Labels.basic{v=_v, f="ZoFontGameSmall", w=75,  t="BEST SCORE", align=TEXT_ALIGN_RIGHT},
        PITHKA.UI.Misc.spacer{ v=_v, w=20},
        PITHKA.UI.Labels.basic{v=_v, f="ZoFontGameSmall", w=216, t="TRIFECTA"},
        }}
        
    -- create trial rows
    local rows = PITHKA.Data.Achievements.DBFilter({TYPE='trial'}) 
    for _, row in pairs(rows) do
        if row.TRI then 
            t[#t+1] =  {
                PITHKA.UI.Labels.teleport{v=_v, w=150, t=row.NAME, c=PITHKA.UI.Constants.rgbBlue, portID=row.portID},
                PITHKA.UI.Labels.score{v=_v, w=75, abbv=row.ABBV, align=TEXT_ALIGN_RIGHT},
                PITHKA.UI.Misc.spacer{ v=_v, w=20},

                PITHKA.UI.Icons.achievement{ v=_v, a=row.TRI},
                PITHKA.UI.Labels.achievement{v=_v, a=row.TRI, t=row.TRINAME, w=190},
            }
        end
    end

    -- create arena rows
    t[#t+1] = {PITHKA.UI.Labels.basic{v=_v, f="ZoFontGameSmall", w=155, t="   "},}
    t[#t+1] = {PITHKA.UI.Labels.basic{v=_v, f="ZoFontGameSmall", w=155, t="ARENAS", tt="Click to port"},}
    local rows = PITHKA.Data.Achievements.DBFilter({TYPE='arena'})
    for _, row in pairs(rows) do
        --if row.TRI then
            t[#t+1] =  {
                PITHKA.UI.Labels.teleport{v=_v, w=150, t=row.NAME, c=PITHKA.UI.Constants.rgbBlue, portID=row.portID},
                PITHKA.UI.Labels.score{v=_v, w=75, abbv=row.ABBV, align=TEXT_ALIGN_RIGHT},
                PITHKA.UI.Misc.spacer{ v=_v, w=20},

                PITHKA.UI.Icons.achievement{ v=_v, a=row.TRI},
                PITHKA.UI.Labels.achievement{v=_v, a=row.TRI, t=row.TRINAME, w=190},
            }
        --end
    end
    -- Oct 30, 2023
    t[#t+1] = {PITHKA.UI.Labels.basic{v=_v, f="ZoFontGameSmall", w=155, t="   "},}
    t[#t+1] = {PITHKA.UI.Labels.basic{v=_v, f="ZoFontGameSmall", w=155, t="INFINITY ARCHIVE", tt="Click to port"},}
    local rows = PITHKA.Data.Achievements.DBFilter({TYPE='endless'})
    for _, row in pairs(rows) do
            t[#t+1] =  {
                PITHKA.UI.Labels.teleport{v=_v, w=150, t=row.NAME, c=PITHKA.UI.Constants.rgbBlue, portID=row.portID},
                PITHKA.UI.Labels.score{v=_v, w=75, abbv=row.ABBV, align=TEXT_ALIGN_RIGHT},
                PITHKA.UI.Misc.spacer{ v=_v, w=20},

                PITHKA.UI.Icons.achievement{ v=_v, a=row.TRI},
                PITHKA.UI.Labels.achievement{v=_v, a=row.TRI, t=row.TRINAME, w=190},
            }
    end
    -- Oct 30, 2023

    -- anchor
    PITHKA.UI.Layout.anchorGrid(t, PITHKA.UI.Layout.anchor(40, 60))

    -- RIGHT COLUMN DUNGEONS
    -- create header
    local t = {{
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=155,  t="DUNGEONS", tt="Click to port"},
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=270,  t='TRIFECTA' },
        }}


    -- create rows
    local rows = PITHKA.Data.Achievements.DBFilter({TYPE='dungeon'}) 
    for _, row in pairs(rows) do
        if row.TRI and row.ABBV ~= 'BRP' then -- BRP is included in score side
            t[#t+1] =  {
                PITHKA.UI.Labels.teleport{v=_v, t=row.NAME, w=155, c=PITHKA.UI.Constants.rgbBlue, vQueue=row.vQueue, nQueue=row.nQueue, portID=row.portID},
                PITHKA.UI.Icons.achievement{v=_v, a=row.TRI},
                PITHKA.UI.Labels.achievement{v=_v, t=row.TRINAME, w=210, a=row.TRI},
            }
        end
    end

    -- anchor
    PITHKA.UI.Layout.anchorGrid(t, PITHKA.UI.Layout.anchor(500, 60))

    -- create watermark
    local w = {
        PITHKA.UI.Labels.watermark{v=_vWater, t=GetDisplayName(), vOffset=-160},
        PITHKA.UI.Labels.watermark{v=_vWater, t=os.date('%b %d, %Y'), vOffset=0},
        PITHKA.UI.Labels.watermark{v=_vWater, t=GetDisplayName(), vOffset=160},
    } -- anchor not required for watermark, handled in label function

    -- summary config
    local control
    local options  = {'~ Trifecta Summary ~'}
    local stateVar = 'trifectaSummary'
    
    -- summary menu
    PITHKA.SV.state[stateVar] = PITHKA.SV.state[stateVar] or '~ Trifecta Summary ~' -- set default for state variable
    control = PITHKA.UI.Misc.menuButton{v=_v, options=options, stateVar=stateVar}
    control:SetAnchor(BOTTOMLEFT, PITHKA_GUI, BOTTOMLEFT, 0, 0)
    
    -- summary label
    control = PITHKA.UI.Labels.stateBased{v=_v, textFnLibrary=PITHKA.Data.Ranks.summaries, stateVar=stateVar, w=650, vAlign=TEXT_ALIGN_BOTTOM}
    control:SetAnchor(BOTTOMLEFT, PITHKA_GUI, BOTTOMLEFT, PITHKA.UI.Constants.iconSize, 0)

end