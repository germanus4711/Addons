-- Initialize File
PITHKA           = PITHKA or {}
PITHKA.UI        = PITHKA.UI or {}
PITHKA.UI.Layout = {}

------------------------------------------------------------------------------------------------------------------
-- Anchor Functions
------------------------------------------------------------------------------------------------------------------

-- anchor (a 1px label used to pin other controls to)
function PITHKA.UI.Layout.anchor(x, y, align, relativeObject)
	local control = WINDOW_MANAGER:CreateControl("$(parent)"..PITHKA.Utils.uid(), PITHKA_GUI, CT_LABEL)
	control:SetDimensions(1,1)
	control:SetAnchor(TOPLEFT, relativeObject or PITHKA_GUI, align or TOPLEFT, x, y)
	return control
end

function PITHKA.UI.Layout.anchorRow(row, anchor)
  for i, cell in ipairs(row) do
    if i==1 then
      cell:SetAnchor(TOPLEFT, anchor, BOTTOMLEFT, 0, 3)
    else
      cell:SetAnchor(LEFT, row[i-1], RIGHT, 3, 0)
    end
  end
end

function PITHKA.UI.Layout.anchorGrid(grid, anchor) 
  for i, row in ipairs(grid) do
    PITHKA.UI.Layout.anchorRow(row, (i==1) and anchor or grid[i-1][1])
  end
end

-- reverse row layout for building from right side
function PITHKA.UI.Layout.anchorRowReverse(row, anchor)
  for i=#row, 1, -1 do
    local cell = row[i]
    if i==#row then
      cell:SetAnchor(BOTTOMRIGHT, anchor, BOTTOMRIGHT, 0, 3)
    else
      cell:SetAnchor(RIGHT, row[i+1], LEFT, 3, 0)
    end
  end
end

------------------------------------------------------------------------------------------------------------------
-- Refresh
------------------------------------------------------------------------------------------------------------------
-- register refresh functions
PITHKA.UI.Layout.refreshFns = {}
function PITHKA.UI.Layout.registerRefreshFn(fn)
  table.insert(PITHKA.UI.Layout.refreshFns, fn)
end

function PITHKA.UI.Layout.updateScreenSize()
  local w, h
  if PITHKA.SV.state.currentScreen == 'dungeon' then
    w = 600 + (PITHKA.SV.state.showExtra and 210 or 0)
    h = 880+80
  elseif PITHKA.SV.state.currentScreen == 'trial' then
    w = 930 + (PITHKA.SV.state.showExtra and 225 or 0)
    h = 450
  elseif PITHKA.SV.state.currentScreen == 'trifecta' then
    w = 925 
    h = 685+80
  elseif PITHKA.SV.state.currentScreen == 'baseDungeon' then
    w = 1000 
    h = 350
  end
  PITHKA_GUI:SetDrawTier(DT_LOW)
  PITHKA_GUI:SetDimensions(w, h)
end

function PITHKA.UI.Layout.refresh()
  PITHKA.UI.Layout.updateScreenSize()
  -- run all refresh functions
  for _, fn in ipairs(PITHKA.UI.Layout.refreshFns) do fn() end
end

-- -- open and close window
function PITHKA.UI.Layout.toggleWindow()
  PITHKA.UI.Layout.refresh()
  SCENE_MANAGER:ToggleTopLevel(PITHKA_GUI)    
end