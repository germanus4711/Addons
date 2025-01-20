-- Initialize File
PITHKA             = PITHKA or {}
PITHKA.Screens     = PITHKA.Screens or {}
PITHKA.Screens.Nav = {}



function PITHKA.Screens.Nav.initialize()
    -- create nav buttons
    local ns = PITHKA.UI.Constants.navIconSize+10
    local n0 = PITHKA.UI.Icons.nav{s=ns, tt='Starter Dungeons', state='baseDungeon', tta=LEFT, t=PITHKA.UI.Constants.texture.DUNGEON}
    local n1 = PITHKA.UI.Icons.nav{s=ns, tt='4-Man Trifectas', state='dungeon', tta=LEFT, t=PITHKA.UI.Constants.texture.INSTANCE}
    local n2 = PITHKA.UI.Icons.nav{s=ns, tt='Trials',   state='trial',   tta=LEFT, t=PITHKA.UI.Constants.texture.TRIAL}
    local n3 = PITHKA.UI.Icons.nav{s=ns+5, tt='All Tris and Scores',   state='trifecta', tta=LEFT, t=PITHKA.UI.Constants.texture.STAR}
    n0:SetAnchor(TOPLEFT, PITHKA_GUI, TOPLET, -ns-12, 0)
    n1:SetAnchor(TOP, n0, BOTTOM, 0, 0)
    n2:SetAnchor(TOP, n1, BOTTOM, 0, 0)
    n3:SetAnchor(TOP, n2, BOTTOM, 0, -5)

    -- create nav container
    navContainer = WINDOW_MANAGER:CreateControlFromVirtual("$(parent)_NavContainer"..PITHKA.Utils.uid(), PITHKA_GUI, "ZO_DefaultBackdrop")
    navContainer:ClearAnchors()
    navContainer:SetAnchor(TOPRIGHT, PITHKA_GUI, TOPLEFT, -6, -8)
    local xDim = ns + 10
    local yDim = ns * 4 + 10
    navContainer:SetDimensions(xDim, yDim)
  
    -- change title dynamically
    PITHKA.UI.Layout.registerRefreshFn(function ()
        PITHKA_GUI:GetNamedChild("WindowTitle"):SetText(
            string.format("%s|%s%s|r", 'Pithka Achievement Tracker  ', PITHKA.UI.Constants.hexBlue, PITHKA.SV.state.title)
            )
        end)


    -- create extra and watermark buttons    -- create buttons
    local eFn = function() return PITHKA.SV.state.currentScreen == 'dungeon' or PITHKA.SV.state.currentScreen == 'trial' end
    local buttons = {
        PITHKA.UI.Misc.checkBox{v=eFn, stateVar='showExtra'},
        PITHKA.UI.Labels.basic{v=eFn, w=60, t='EXTRAS', tt='Show extra achievements',  f="ZoFontGameSmall",},
        PITHKA.UI.Misc.checkBox{stateVar='showWatermark'},
        PITHKA.UI.Labels.basic{w=90, t='WATERMARKS', tt='Guilds typically require screenshots with watermaks',  f="ZoFontGameSmall",},
    }
    PITHKA.UI.Layout.anchorRowReverse(buttons, PITHKA.UI.Layout.anchor(0, 0, BOTTOMRIGHT))

end




