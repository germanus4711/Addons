-- -----------------------------------------------------------------------------
--  LuiExtended                                                               --
--  Distributed under The MIT License (MIT) (see LICENSE file)                --
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--- @class (partial) LuiExtended
--- @field UI table UI utilities
--- @field SV table Saved variables
local LUIE = LUIE
-- -----------------------------------------------------------------------------
local UI = LUIE.UI
local eventManager = GetEventManager()
local sceneManager = SCENE_MANAGER
-- -----------------------------------------------------------------------------
local firstRun = true
local g_LUIE_Movers = {}
local g_framesUnlocked = false
-- -----------------------------------------------------------------------------
--- Table of UI elements to unlock for moving.
--- Constraints for some elements need to be adjusted - using values from Azurah.
--- @type table<Control, {[integer]:string, [integer]:number?, [integer]:number?}>
local defaultPanels =
{
    [ZO_HUDInfamyMeter] = { GetString(LUIE_STRING_DEFAULT_FRAME_INFAMY_METER) },
    [ZO_HUDTelvarMeter] = { GetString(LUIE_STRING_DEFAULT_FRAME_TEL_VAR_METER) },
    [ZO_HUDDaedricEnergyMeter] = { GetString(LUIE_STRING_DEFAULT_FRAME_VOLENDRUNG_METER) },
    [ZO_HUDEquipmentStatus] = { GetString(LUIE_STRING_DEFAULT_FRAME_EQUIPMENT_STATUS), 64, 64 },
    [ZO_FocusedQuestTrackerPanel] = { GetString(LUIE_STRING_DEFAULT_FRAME_QUEST_LOG), nil, 200 },
    [ZO_LootHistoryControl_Keyboard] = { GetString(LUIE_STRING_DEFAULT_FRAME_LOOT_HISTORY), 280, 400 },
    [ZO_BattlegroundHUDFragmentTopLevel] = { GetString(LUIE_STRING_DEFAULT_FRAME_BATTLEGROUND_SCORE), nil, 200 },
    [ZO_ActionBar1] = { GetString(LUIE_STRING_DEFAULT_FRAME_ACTION_BAR) },
    [ZO_Subtitles] = { GetString(LUIE_STRING_DEFAULT_FRAME_SUBTITLES), 256, 80 },
    [ZO_TutorialHudInfoTipKeyboard] = { GetString(LUIE_STRING_DEFAULT_FRAME_TUTORIALS) },
    [ZO_ObjectiveCaptureMeter] = { GetString(LUIE_STRING_DEFAULT_FRAME_OBJECTIVE_METER), 128, 128 },
    [ZO_PlayerToPlayerAreaPromptContainer] = { GetString(LUIE_STRING_DEFAULT_FRAME_PLAYER_INTERACTION), nil, 30 },
    [ZO_SynergyTopLevelContainer] = { GetString(LUIE_STRING_DEFAULT_FRAME_SYNERGY) },
    [ZO_AlertTextNotification] = { GetString(LUIE_STRING_DEFAULT_FRAME_ALERTS), 600, 56 },
    [ZO_CompassFrame] = { GetString(LUIE_STRING_DEFAULT_FRAME_COMPASS) },                                        -- Needs custom template applied
    [ZO_ActiveCombatTipsTip] = { GetString(LUIE_STRING_DEFAULT_FRAME_ACTIVE_COMBAT_TIPS), 250, 20 },             -- Needs custom template applied
    [ZO_PlayerProgress] = { GetString(LUIE_STRING_DEFAULT_FRAME_PLAYER_PROGRESS) },                              -- Needs custom template applied
    [ZO_EndDunHUDTrackerContainer] = { GetString(LUIE_STRING_DEFAULT_FRAME_ENDLESS_DUNGEON_TRACKER), 230, 100 }, -- Needs custom template applied
    [ZO_ReticleContainerInteract] = { GetString(LUIE_STRING_DEFAULT_FRAME_RETICLE_CONTAINER_INTERACT) }
}
-- -----------------------------------------------------------------------------
--- Replace the template function for certain elements to also use custom positions
--- @param object table The object containing the template function to be replaced
--- @param functionName string The name of the template function to be replaced
--- @param frameName string The name of the frame associated with the template function
local function ReplaceDefaultTemplate(object, functionName, frameName)
    local zos_function = object[functionName]
    object[functionName] = function (self)
        local result = zos_function(self)
        local frameData = LUIE.SV[frameName]
        if frameData then
            local frame = _G[frameName]
            --- @cast frame userdata
            frame:ClearAnchors()
            frame:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, frameData[1], frameData[2])
        end
        return result
    end
end
-- -----------------------------------------------------------------------------
--- Run when the UI scene changes to hide the unlocked elements if we're in the Addon Settings Menu
--- @param oldState number The previous state of the UI scene
--- @param newState number The new state of the UI scene
local function sceneChange(oldState, newState)
    if not g_framesUnlocked then return end

    local isHidden = (newState == SCENE_SHOWN)
    for _, v in pairs(g_LUIE_Movers) do
        v:SetHidden(isHidden)
    end
end
-- -----------------------------------------------------------------------------
--- Helper function to adjust an element
--- @param k Control The element to be adjusted
--- @param v {[1]:string, [2]:number?, [3]:number?} The table containing adjustment values
local function adjustElement(k, v)
    k:SetClampedToScreen(true)
    if v[2] then
        k:SetWidth(v[2])
    end
    if v[3] then
        k:SetHeight(v[3])
    end
end
-- -----------------------------------------------------------------------------
--- Grid Snap Functions
-- -----------------------------------------------------------------------------

--- Snaps a position to the nearest grid point
--- @param position integer The position to snap
--- @param gridSize integer The size of the grid
--- @return integer @The snapped position
local function SnapToGrid(position, gridSize)
    -- Round down
    position = zo_floor(position)

    -- Return value to closest grid point
    if (position % gridSize >= gridSize / 2) then
        return position + (gridSize - (position % gridSize))
    else
        return position - (position % gridSize)
    end
end

LUIE.SnapToGrid = SnapToGrid

--- Applies grid snapping to a pair of coordinates based on the specified grid type
--- @param left integer The x coordinate
--- @param top integer The y coordinate
--- @param gridType string The type of grid to use ("default", "unitFrames", "buffs")
--- @return integer x
--- @return integer y
local function ApplyGridSnap(left, top, gridType)
    local gridSetting = "snapToGrid" .. (gridType and ("_" .. gridType) or "")
    local sizeSetting = "snapToGridSize" .. (gridType and ("_" .. gridType) or "")

    if LUIE.SV[gridSetting] then
        local gridSize = LUIE.SV[sizeSetting] or 10
        left = SnapToGrid(left, gridSize)
        top = SnapToGrid(top, gridSize)
    end
    return left, top
end

LUIE.ApplyGridSnap = ApplyGridSnap
-- -----------------------------------------------------------------------------
--- Helper function to set the anchor of an element
--- @param k Control The element to set the anchor for
--- @param frameName string The name of the frame associated with the element
local function setAnchor(k, frameName)
    local x = LUIE.SV[frameName][1] --- @type integer
    local y = LUIE.SV[frameName][2] --- @type integer

    -- Apply grid snapping if enabled
    if x ~= nil and y ~= nil then
        x, y = ApplyGridSnap(x, y, "default")
        k:ClearAnchors()
        k:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, x, y)
    end
    -- Fix the Objective Capture Meter fill alignment.
    if k == ZO_ObjectiveCaptureMeter then
        ZO_ObjectiveCaptureMeterFrame:SetAnchor(BOTTOM, ZO_ObjectiveCaptureMeter, BOTTOM, 0, 0)
    end
    -- Setup Alert Text to anchor properly.
    -- Thanks to Phinix (Azurah) for this method of adjusting the fadingControlBuffer anchor to reposition the alert text.
    if k == ZO_AlertTextNotification then
        -- Throw a dummy alert just in case so alert text exists.
        ZO_Alert(UI_ALERT_CATEGORY_ALERT, nil, " ")
        local alertText
        if not IsInGamepadPreferredMode() then
            alertText = ZO_AlertTextNotification:GetChild(1)
        else
            alertText = ZO_AlertTextNotificationGamepad:GetChild(1)
        end
        -- Only adjust this if a custom position is set.
        if x ~= nil and y ~= nil then
            -- Anchor to the Top Right corner of the Alerts frame.
            --- @diagnostic disable-next-line: undefined-field
            alertText.fadingControlBuffer.anchor = ZO_Anchor:New(TOPRIGHT, ZO_AlertTextNotification, TOPRIGHT)
        end
    end
end
-- -----------------------------------------------------------------------------
--- Called when an element mover is adjusted and on initialization to update all positions
function LUIE.SetElementPosition()
    for k, v in pairs(defaultPanels) do
        local frameName = k:GetName()
        if LUIE.SV[frameName] then
            adjustElement(k, v)
            setAnchor(k, frameName)
        end
        ReplaceDefaultTemplate(ACTIVE_COMBAT_TIP_SYSTEM, "ApplyStyle", "ZO_ActiveCombatTips")
        ReplaceDefaultTemplate(COMPASS_FRAME, "ApplyStyle", "ZO_CompassFrame")
        ReplaceDefaultTemplate(PLAYER_PROGRESS_BAR, "RefreshTemplate", "ZO_PlayerProgress")
        ReplaceDefaultTemplate(ZO_HUDTracker_Base, "RefreshAnchors", "ZO_EndDunHUDTrackerContainer")
    end
end

-- -----------------------------------------------------------------------------
--- Helper function to create a top-level window
--- @param k Control The element to create the top-level window for
--- @param v {[1]:string, [2]:number?, [3]:number?} The table containing window configuration values
--- @param point number The anchor point for the top-level window
--- @param relativePoint number The relative anchor point for the top-level window
--- @param offsetX number The X offset for the top-level window
--- @param offsetY number The Y offset for the top-level window
--- @param relativeTo Control The element to which the top-level window is relative
--- @return TopLevelWindow tlw The created top-level window
local function createTopLevelWindow(k, v, point, relativePoint, offsetX, offsetY, relativeTo)
    local tlw = UI:TopLevel({ point, relativePoint, offsetX, offsetY, relativeTo }, { k:GetWidth(), k:GetHeight() })
    tlw.customPositionAttr = k:GetName()

    -- Create preview backdrop
    tlw.preview = UI:Backdrop(tlw, "fill", nil, nil, nil, false)
    tlw.preview:SetDrawLayer(DL_OVERLAY)
    tlw.preview:SetDrawLevel(5)
    tlw.preview:SetDrawTier(DT_MEDIUM)

    -- Create preview backdrop
    tlw.preview = UI:Backdrop(tlw, "fill", nil, nil, nil, false)

    -- Get initial position from saved variables if it exists
    local positionText = "Default"
    if LUIE.SV[tlw.customPositionAttr] then
        local x = LUIE.SV[tlw.customPositionAttr][1] or 0
        local y = LUIE.SV[tlw.customPositionAttr][2] or 0
        positionText = string.format("%d, %d | %s", x, y, v[1])
    else
        positionText = string.format("Default | %s", v[1])
    end

    -- Create coordinate label with initial position
    tlw.preview.coordLabel = UI:Label(tlw.preview, { BOTTOMLEFT, TOPLEFT, 0, -1 }, nil, { 0, 2 }, "ZoFontGameSmall", positionText, false)
    tlw.preview.coordLabel:SetColor(1, 1, 0, 1)
    tlw.preview.coordLabel:SetDrawLayer(DL_OVERLAY)
    tlw.preview.coordLabel:SetDrawLevel(5)
    tlw.preview.coordLabel:SetDrawTier(DT_MEDIUM)

    -- Create label background
    tlw.preview.coordLabelBg = UI:Backdrop(tlw.preview.coordLabel, "fill", nil, { 0, 0, 0, 1 }, { 0, 0, 0, 1 }, false)
    tlw.preview.coordLabelBg:SetDrawLayer(DL_OVERLAY)
    tlw.preview.coordLabelBg:SetDrawLevel(5)
    tlw.preview.coordLabel:SetDrawTier(DT_MEDIUM)

    -- Create label background
    tlw.preview.coordLabelBg = UI:Backdrop(tlw.preview.coordLabel, "fill", nil, { 0, 0, 0, 1 }, { 0, 0, 0, 1 }, false)
    tlw.preview.coordLabelBg:SetDrawLayer(DL_OVERLAY)
    tlw.preview.coordLabelBg:SetDrawTier(DT_LOW)

    -- Add movement handlers
    tlw:SetHandler("OnMoveStart",
        --- @param self TopLevelWindow
        function (self)
            eventManager:RegisterForUpdate("LUIE_UnlockMoveUpdate", 200, function ()
                if self.preview and self.preview.coordLabel then
                    local frameName = v[1] -- Get the frame name from the defaultPanels table
                    self.preview.coordLabel:SetText(string.format("%d, %d | %s", self:GetLeft(), self:GetTop(), frameName))
                    -- Anchor label to inside top-left of the frame
                    self.preview.coordLabel:ClearAnchors()
                    self.preview.coordLabel:SetAnchor(TOPLEFT, self.preview, TOPLEFT, 2, 2)
                end
            end)
        end)

    tlw:SetHandler("OnMoveStop",
        --- @param self TopLevelWindow
        function (self)
            eventManager:UnregisterForUpdate("LUIE_UnlockMoveUpdate")
            if self.preview and self.preview.coordLabel then
                local frameName = v[1] -- Get the frame name from the defaultPanels table
                self.preview.coordLabel:SetText(string.format("%d, %d | %s", self:GetLeft(), self:GetTop(), frameName))
                -- Anchor label to inside top-left of the frame
                self.preview.coordLabel:ClearAnchors()
                self.preview.coordLabel:SetAnchor(TOPLEFT, self.preview, TOPLEFT, 2, 2)
            end
        end)

    return tlw
end

-- -----------------------------------------------------------------------------
-- Element Movers.
-- -----------------------------------------------------------------------------

-- Helper function to initialize the mover for a given element
local function initializeElementMover(element, config)
    -- Adjust width and height constraints if provided
    if config[2] then
        element:SetWidth(config[2])
    end
    if config[3] then
        element:SetHeight(config[3])
    end

    -- Retrieve the anchor information for the element
    local isValidAnchor, point, relativeTo, relativePoint, offsetX, offsetY, anchorConstraints = element:GetAnchor()
    if not isValidAnchor then
        return
    end

    -- Special handling for the Alert Text Notification element
    if element == ZO_AlertTextNotification then
        local frameName = element:GetName()
        if not LUIE.SV[frameName] then
            point = TOPRIGHT
            relativeTo = GuiRoot
            relativePoint = TOPRIGHT
            offsetX = 0
            offsetY = 0
            anchorConstraints = anchorConstraints or ANCHOR_CONSTRAINS_XY
        end
    end

    -- Create and configure the top-level window (mover) for the element
    local mover = createTopLevelWindow(element, config, point, relativePoint, offsetX, offsetY, relativeTo)
    mover:SetHandler("OnMoveStop", function (self)
        local left, top = self:GetLeft(), self:GetTop()

        -- Apply grid snapping if enabled
        if LUIE.SV.snapToGrid_default then
            left, top = ApplyGridSnap(left, top, "default")
            self:ClearAnchors()
            self:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
        end

        -- Save the new position and update the element positions
        LUIE.SV[self.customPositionAttr] = { left, top }
        LUIE.SetElementPosition()
    end)

    return mover
end

-- Helper function to register the scene callback for hiding movers
local function registerSceneCallback()
    local scene = sceneManager:GetScene("gameMenuInGame")
    scene:RegisterCallback("StateChange", sceneChange)
end

-- Main function to setup element movers based on the provided state
---
--- @param state boolean
function LUIE.SetupElementMover(state)
    g_framesUnlocked = state

    for element, config in pairs(defaultPanels) do
        if firstRun then
            local mover = initializeElementMover(element, config)
            if mover then
                g_LUIE_Movers[mover.customPositionAttr] = mover
            end
        end

        local mover = g_LUIE_Movers[element:GetName()]
        --- @cast mover userdata
        if mover then
            mover:SetMouseEnabled(state)
            mover:SetMovable(state)
            mover:SetHidden(not state)
        end
    end

    if firstRun then
        registerSceneCallback()
        firstRun = false
    end
end

-- -----------------------------------------------------------------------------
--- Reset the position of windows. Called from the Settings Menu
function LUIE.ResetElementPosition()
    for k, v in pairs(defaultPanels) do
        local frameName = k:GetName()
        LUIE.SV[frameName] = nil
    end
    ReloadUI("ingame")
end

-- -----------------------------------------------------------------------------
