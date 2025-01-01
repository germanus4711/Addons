-- Initialize File
PITHKA           = PITHKA or {}
PITHKA.Screens   = PITHKA.Screens or {}
PITHKA.Screens.BaseDungeons = {}



function PITHKA.Screens.BaseDungeons.initialize()
    local _v  = function() return PITHKA.SV.state.currentScreen == 'baseDungeon' end
    local _is = PITHKA.UI.Constants.iconSize
    local _vWater = function() return PITHKA.SV.state.currentScreen == 'baseDungeon' and PITHKA.SV.state.showWatermark end

    -- COL A DUNGEONS ---------------------------------------------------------------------------------------------------------
    local rows = PITHKA.Data.Achievements.DBFilter({TYPE='baseDungeon', n=1}) 
    -- header
    local t = {{
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=155,  t="DUNGEONS", tt="Click to port"},
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=_is,  t="VET",      tt="Veteran",  align=TEXT_ALIGN_CENTER},
        -- PITHKA.UI.Misc.spacer{  v=_v, w=20},
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=_is,  t="HM",       tt="Hard Mode",  align=TEXT_ALIGN_CENTER},
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=_is,  t="SR",       tt="Speed Run",  align=TEXT_ALIGN_CENTER},
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=_is,  t="ND",       tt="No Death",   align=TEXT_ALIGN_CENTER},
        }}
    -- rows
    local blue = PITHKA.UI.Constants.rgbBlue
    for _, row in pairs(rows) do
        t[#t+1] =  {
            PITHKA.UI.Labels.teleport{v=_v, t=row.NAME, w=155, c=PITHKA.UI.Constants.rgbBlue, vQueue=row.vQueue, nQueue=row.nQueue, portID=row.portID},
            PITHKA.UI.Icons.achievement{v=_v, a=row.VET},
            -- PITHKA.UI.Misc.spacer{v=_v, w=20},
            PITHKA.UI.Icons.achievement{v=_v, a=row.HM},
            PITHKA.UI.Icons.achievement{v=_v, a=row.SR},
            PITHKA.UI.Icons.achievement{v=_v, a=row.ND},
        }
    end
    -- anchor
    PITHKA.UI.Layout.anchorGrid(t, PITHKA.UI.Layout.anchor(40, 60))


    -- COL B DUNGEONS ---------------------------------------------------------------------------------------------------------
    local rows = PITHKA.Data.Achievements.DBFilter({TYPE='baseDungeon', n=2}) 
    -- header
    local t = {{
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=160,  t="DUNGEONS", tt="Click to port"},
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=_is,  t="VET",      tt="Veteran",  align=TEXT_ALIGN_CENTER},
        -- PITHKA.UI.Misc.spacer{  v=_v, w=20},
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=_is,  t="HM",       tt="Hard Mode",  align=TEXT_ALIGN_CENTER},
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=_is,  t="SR",       tt="Speed Run",  align=TEXT_ALIGN_CENTER},
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=_is,  t="ND",       tt="No Death",   align=TEXT_ALIGN_CENTER},
        }}
    -- rows
    local blue = PITHKA.UI.Constants.rgbBlue
    for _, row in pairs(rows) do
        t[#t+1] =  {
            PITHKA.UI.Labels.teleport{v=_v, t=row.NAME, w=160, c=PITHKA.UI.Constants.rgbBlue, vQueue=row.vQueue, nQueue=row.nQueue, portID=row.portID},
            PITHKA.UI.Icons.achievement{v=_v, a=row.VET},
            -- PITHKA.UI.Misc.spacer{v=_v, w=20},
            PITHKA.UI.Icons.achievement{v=_v, a=row.HM},
            PITHKA.UI.Icons.achievement{v=_v, a=row.SR},
            PITHKA.UI.Icons.achievement{v=_v, a=row.ND},
        }
    end
    -- anchor
    PITHKA.UI.Layout.anchorGrid(t, PITHKA.UI.Layout.anchor(375, 60))
    
    
    -- COL C DUNGEONS ---------------------------------------------------------------------------------------------------------
    local rows = PITHKA.Data.Achievements.DBFilter({TYPE='baseDungeon', n=0}) 
    -- header
    local t = {{
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=155,  t="DUNGEONS", tt="Click to port"},
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=_is,  t="VET",      tt="Veteran",  align=TEXT_ALIGN_CENTER},
        -- PITHKA.UI.Misc.spacer{  v=_v, w=20},
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=_is,  t="HM",       tt="Hard Mode",  align=TEXT_ALIGN_CENTER},
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=_is,  t="SR",       tt="Speed Run",  align=TEXT_ALIGN_CENTER},
        PITHKA.UI.Labels.basic{ v=_v,      f="ZoFontGameSmall", w=_is,  t="ND",       tt="No Death",   align=TEXT_ALIGN_CENTER},
        }}
    -- rows
    local blue = PITHKA.UI.Constants.rgbBlue
    for _, row in pairs(rows) do
        t[#t+1] =  {
            PITHKA.UI.Labels.teleport{v=_v, t=row.NAME, w=155, c=PITHKA.UI.Constants.rgbBlue, vQueue=row.vQueue, nQueue=row.nQueue, portID=row.portID},
            PITHKA.UI.Icons.achievement{v=_v, a=row.VET},
            -- PITHKA.UI.Misc.spacer{v=_v, w=20},
            PITHKA.UI.Icons.achievement{v=_v, a=row.HM},
            PITHKA.UI.Icons.achievement{v=_v, a=row.SR},
            PITHKA.UI.Icons.achievement{v=_v, a=row.ND},
        }
    end
    -- anchor
    PITHKA.UI.Layout.anchorGrid(t, PITHKA.UI.Layout.anchor(700, 60))

    -- watermarks
    local w = {
        PITHKA.UI.Labels.watermark{v=_vWater, t=GetDisplayName(), vOffset=-100},
        PITHKA.UI.Labels.watermark{v=_vWater, t=os.date('%b %d, %y'), vOffset=50},
    } -- anchor not required for watermark, handled in label function
    
end

