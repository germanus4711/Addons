local LoreBooks = _G["LoreBooks"]
local internal = _G["LoreBooks_Internal"]

local LAM = LibAddonMenu2
local LMP = LibMapPins

function LoreBooks:CreateLamPanel()
  local panelData = {
    type = "panel",
    name = GetString(LBOOKS_TITLE),
    displayName = ZO_HIGHLIGHT_TEXT:Colorize(GetString(LBOOKS_TITLE)),
    author = internal.ADDON_AUTHOR,
    version = internal.ADDON_VERSION,
    slashCommand = "/lorebooks",
    registerForRefresh = true,
    registerForDefaults = true,
    website = internal.ADDON_WEBSITE,
  }
  LAM:RegisterAddonPanel(internal.ADDON_PANEL, panelData)

  local pinTexturesValues = {
    [1] = internal.PIN_ICON_REAL,
    [2] = internal.PIN_ICON_SET1,
    [3] = internal.PIN_ICON_SET2,
    [4] = internal.PIN_ICON_ESOHEAD,
  }
  local pinTexturesList = {
    [1] = GetString(LBOOKS_PIN_TEXTURE1),
    [2] = GetString(LBOOKS_PIN_TEXTURE2),
    [3] = GetString(LBOOKS_PIN_TEXTURE3),
    [4] = GetString(LBOOKS_PIN_TEXTURE4),
  }
  local pinTextures = internal.PIN_TEXTURES

  local CreateIcons, unknownIcon, collectedIcon, unknownIconEidetic, collectedIconEidetic
  CreateIcons = function(panel)
    if panel == LoreBooksPanel then
      unknownIcon = WINDOW_MANAGER:CreateControl(nil, panel.controlsToRefresh[1], CT_TEXTURE)
      unknownIcon:SetAnchor(RIGHT, panel.controlsToRefresh[1].combobox, LEFT, -10, 0)
      unknownIcon:SetTexture(pinTextures[LoreBooks.db.pinTexture.type][2])
      unknownIcon:SetDimensions(LoreBooks.db.pinTexture.size, LoreBooks.db.pinTexture.size)
      collectedIcon = WINDOW_MANAGER:CreateControl(nil, panel.controlsToRefresh[1], CT_TEXTURE)
      collectedIcon:SetAnchor(RIGHT, unknownIcon, LEFT, -5, 0)
      collectedIcon:SetTexture(pinTextures[LoreBooks.db.pinTexture.type][1])
      collectedIcon:SetDimensions(LoreBooks.db.pinTexture.size, LoreBooks.db.pinTexture.size)
      collectedIcon:SetDesaturation((LoreBooks.db.pinTexture.type == internal.PIN_ICON_REAL) and 1 or 0)

      unknownIconEidetic = WINDOW_MANAGER:CreateControl(nil, panel.controlsToRefresh[3], CT_TEXTURE)
      unknownIconEidetic:SetAnchor(RIGHT, panel.controlsToRefresh[3].combobox, LEFT, -10, 0)
      unknownIconEidetic:SetTexture(pinTextures[LoreBooks.db.pinTextureEidetic][2])
      unknownIconEidetic:SetDimensions(LoreBooks.db.pinTexture.size, LoreBooks.db.pinTexture.size)
      collectedIconEidetic = WINDOW_MANAGER:CreateControl(nil, panel.controlsToRefresh[3], CT_TEXTURE)
      collectedIconEidetic:SetAnchor(RIGHT, unknownIconEidetic, LEFT, -5, 0)
      collectedIconEidetic:SetTexture(pinTextures[LoreBooks.db.pinTextureEidetic][1])
      collectedIconEidetic:SetDimensions(LoreBooks.db.pinTexture.size, LoreBooks.db.pinTexture.size)
      collectedIconEidetic:SetDesaturation((LoreBooks.db.pinTextureEidetic == internal.PIN_ICON_REAL) and 1 or 0)

      CALLBACK_MANAGER:UnregisterCallback("LAM-PanelControlsCreated", CreateIcons)
    end
  end
  CALLBACK_MANAGER:RegisterCallback("LAM-PanelControlsCreated", CreateIcons)

  local immersiveChoices = {
    [1] = GetString(LBOOKS_IMMERSIVE_CHOICE1),
    [2] = GetString(LBOOKS_IMMERSIVE_CHOICE2),
    [3] = GetString(LBOOKS_IMMERSIVE_CHOICE3),
    [4] = GetString(LBOOKS_IMMERSIVE_CHOICE4),
    [5] = GetString(LBOOKS_IMMERSIVE_CHOICE5),
  }

  local function SetLayoutKeyAndRefresh(pin, key, value)
    LMP:SetLayoutKey(pin, key, value)
    LMP:RefreshPins(pin)
  end

  local optionsTable = { }
  optionsTable[#optionsTable + 1] = {
    type = "dropdown",
    name = GetString(LBOOKS_PIN_TEXTURE),
    tooltip = GetString(LBOOKS_PIN_TEXTURE_DESC),
    choices = pinTexturesList,
    choicesValues = pinTexturesValues,
    getFunc = function() return LoreBooks.db.pinTexture.type end,
    setFunc = function(value)
      LoreBooks.db.pinTexture.type = value
      unknownIcon:SetTexture(pinTextures[value][2])
      collectedIcon:SetDesaturation(value == LoreBooks.defaults.pinTexture.type and 1 or 0)
      collectedIcon:SetTexture(pinTextures[value][1])
      LMP:RefreshPins(internal.PINS_UNKNOWN)
      LMP:RefreshPins(internal.PINS_COLLECTED)
      COMPASS_PINS.pinLayouts[internal.PINS_COMPASS].texture = pinTextures[value][2]
      COMPASS_PINS:RefreshPins(internal.PINS_COMPASS)
    end,
    default = LoreBooks.defaults.pinTexture.type,
  }
  optionsTable[#optionsTable + 1] = {
    type = "checkbox",
    name = GetString(LBOOKS_PIN_GRAYSCALE),
    tooltip = GetString(LBOOKS_PIN_GRAYSCALE_DESC),
    getFunc = function() return LoreBooks.db.pinGrayscale end,
    setFunc = function(value) LoreBooks.db.pinGrayscale = value end,
    disabled = function() return LoreBooks.db.pinTexture.type ~= internal.PIN_ICON_REAL end,
    default = LoreBooks.defaults.pinGrayscale,
  }
  optionsTable[#optionsTable + 1] = {
    type = "dropdown",
    name = zo_strformat(LBOOKS_PIN_TEXTURE_EIDETIC, GetLoreCategoryInfo(3)),
    tooltip = GetString(LBOOKS_PIN_TEXTURE_DESC),
    choices = pinTexturesList,
    choicesValues = pinTexturesValues,
    getFunc = function() return LoreBooks.db.pinTextureEidetic end,
    setFunc = function(value)
      LoreBooks.db.pinTextureEidetic = value
      unknownIconEidetic:SetTexture(pinTextures[value][2])
      collectedIconEidetic:SetDesaturation(value == LoreBooks.defaults.pinTextureEidetic and 1 or 0)
      collectedIconEidetic:SetTexture(pinTextures[value][1])
      LMP:RefreshPins(internal.PINS_EIDETIC)
      LMP:RefreshPins(internal.PINS_EIDETIC_COLLECTED)
      COMPASS_PINS.pinLayouts[internal.PINS_COMPASS_EIDETIC].texture = pinTextures[value][2]
      COMPASS_PINS:RefreshPins(internal.PINS_COMPASS_EIDETIC)
    end,
    default = LoreBooks.defaults.pinTextureEidetic,
  }
  optionsTable[#optionsTable + 1] = {
    type = "checkbox",
    name = GetString(LBOOKS_PIN_GRAYSCALE),
    tooltip = GetString(LBOOKS_PIN_GRAYSCALE_EIDETIC_DESC),
    getFunc = function() return LoreBooks.db.pinGrayscaleEidetic end,
    setFunc = function(value) LoreBooks.db.pinGrayscaleEidetic = value end,
    disabled = function() return LoreBooks.db.pinTextureEidetic ~= internal.PIN_ICON_REAL end,
    default = LoreBooks.defaults.pinGrayscaleEidetic,
  }
  optionsTable[#optionsTable + 1] = {
    type = "slider",
    name = GetString(LBOOKS_PIN_SIZE),
    tooltip = GetString(LBOOKS_PIN_SIZE_DESC),
    min = 10,
    max = 70,
    step = 1,
    getFunc = function() return LoreBooks.db.pinTexture.size end,
    setFunc = function(size)
      LoreBooks.db.pinTexture.size = size
      unknownIcon:SetDimensions(size, size)
      collectedIcon:SetDimensions(size, size)
      SetLayoutKeyAndRefresh(internal.PINS_UNKNOWN, "size", size)
      SetLayoutKeyAndRefresh(internal.PINS_COLLECTED, "size", size)
      SetLayoutKeyAndRefresh(internal.PINS_EIDETIC, "size", size)
      SetLayoutKeyAndRefresh(internal.PINS_EIDETIC_COLLECTED, "size", size)
    end,
    disabled = function() return not (LoreBooks.db.filters[internal.PINS_UNKNOWN] or LoreBooks.db.filters[internal.PINS_COLLECTED] or LoreBooks.db.filters[internal.PINS_EIDETIC] or LoreBooks.db.filters[internal.PINS_EIDETIC_COLLECTED] or LoreBooks.db.filters[internal.PINS_BOOKSHELF]) end,
    default = LoreBooks.defaults.pinTexture.size
  }
  optionsTable[#optionsTable + 1] = {
    type = "slider",
    name = GetString(LBOOKS_PIN_LAYER),
    tooltip = GetString(LBOOKS_PIN_LAYER_DESC),
    min = 10,
    max = 200,
    step = 5,
    getFunc = function() return LoreBooks.db.pinTexture.level end,
    setFunc = function(level)
      LoreBooks.db.pinTexture.level = level
      SetLayoutKeyAndRefresh(internal.PINS_UNKNOWN, "level", level)
      SetLayoutKeyAndRefresh(internal.PINS_COLLECTED, "level", level)
      SetLayoutKeyAndRefresh(internal.PINS_EIDETIC, "level", level)
      SetLayoutKeyAndRefresh(internal.PINS_EIDETIC_COLLECTED, "level", level)
    end,
    disabled = function() return not (LoreBooks.db.filters[internal.PINS_UNKNOWN] or LoreBooks.db.filters[internal.PINS_COLLECTED] or LoreBooks.db.filters[internal.PINS_EIDETIC] or LoreBooks.db.filters[internal.PINS_EIDETIC_COLLECTED] or LoreBooks.db.filters[internal.PINS_BOOKSHELF]) end,
    default = LoreBooks.defaults.pinTexture.level,
  }
  -- add Dungeon tag or zonename
  optionsTable[#optionsTable + 1] = {
    type = "checkbox",
    name = GetString(LBOOKS_DUNGEON_TAG_MENU),
    tooltip = GetString(LBOOKS_DUNGEON_TAG_MENU_DESC),
    getFunc = function() return LoreBooks.db.showDungeonTag end,
    setFunc = function(state) LoreBooks.db.showDungeonTag = state end,
    default = LoreBooks.defaults.showDungeonTag,
  }
  -- add Quest Name and Location
  optionsTable[#optionsTable + 1] = {
    type = "checkbox",
    name = GetString(LBOOKS_QUESTINFO_MENU),
    tooltip = GetString(LBOOKS_QUESTINFO_MENU_DESC),
    getFunc = function() return LoreBooks.db.showQuestName end,
    setFunc = function(state) LoreBooks.db.showQuestName = state end,
    default = LoreBooks.defaults.showQuestName,
  }
  optionsTable[#optionsTable + 1] = { -- disable clicl menu
    type = "checkbox",
    name = GetString(LBOOKS_PIN_CLICK_MENU),
    tooltip = GetString(LBOOKS_PIN_CLICK_MENU_DESC),
    getFunc = function() return LoreBooks.db.showClickMenu end,
    setFunc = function(state)
      LoreBooks.db.showClickMenu = state
    end,
    default = LoreBooks.defaults.showClickMenu,
  }
  optionsTable[#optionsTable + 1] = {
    type = "checkbox",
    name = GetString(LBOOKS_UNKNOWN),
    tooltip = GetString(LBOOKS_UNKNOWN_DESC),
    getFunc = function() return LoreBooks.db.filters[internal.PINS_UNKNOWN] end,
    setFunc = function(state)
      LoreBooks.db.filters[internal.PINS_UNKNOWN] = state
      LMP:SetEnabled(internal.PINS_UNKNOWN, state)
    end,
    default = LoreBooks.defaults.filters[internal.PINS_UNKNOWN],
  }
  optionsTable[#optionsTable + 1] = {
    type = "checkbox",
    name = GetString(LBOOKS_COLLECTED),
    tooltip = GetString(LBOOKS_COLLECTED_DESC),
    getFunc = function() return LoreBooks.db.filters[internal.PINS_COLLECTED] end,
    setFunc = function(state)
      LoreBooks.db.filters[internal.PINS_COLLECTED] = state
      LMP:SetEnabled(internal.PINS_COLLECTED, state)
    end,
    default = LoreBooks.defaults.filters[internal.PINS_COLLECTED]
  }
  optionsTable[#optionsTable + 1] = {
    type = "checkbox",
    name = GetString(LBOOKS_EIDETIC),
    tooltip = GetString(LBOOKS_EIDETIC_DESC),
    getFunc = function() return LoreBooks.db.filters[internal.PINS_EIDETIC] end,
    setFunc = function(state)
      LoreBooks.db.filters[internal.PINS_EIDETIC] = state
      LMP:SetEnabled(internal.PINS_EIDETIC, state)
    end,
    default = LoreBooks.defaults.filters[internal.PINS_EIDETIC]
  }
  optionsTable[#optionsTable + 1] = {
    type = "checkbox",
    name = GetString(LBOOKS_EIDETIC_COLLECTED),
    tooltip = GetString(LBOOKS_EIDETIC_COLLECTED_DESC),
    getFunc = function() return LoreBooks.db.filters[internal.PINS_EIDETIC_COLLECTED] end,
    setFunc = function(state)
      LoreBooks.db.filters[internal.PINS_EIDETIC_COLLECTED] = state
      LMP:SetEnabled(internal.PINS_EIDETIC_COLLECTED, state)
    end,
    default = LoreBooks.defaults.filters[internal.PINS_EIDETIC_COLLECTED]
  }
  optionsTable[#optionsTable + 1] = { -- Bookshelf
    type = "checkbox",
    name = GetString(LBOOKS_BOOKSHELF_NAME),
    tooltip = GetString(LBOOKS_BOOKSHELF_DESC),
    getFunc = function() return LoreBooks.db.filters[internal.PINS_BOOKSHELF] end,
    setFunc = function(state)
      LoreBooks.db.filters[internal.PINS_BOOKSHELF] = state
      LMP:SetEnabled(internal.PINS_BOOKSHELF, state)
    end,
    default = LoreBooks.defaults.filters[internal.PINS_BOOKSHELF]
  }
  optionsTable[#optionsTable + 1] = {
    type = "checkbox",
    name = GetString(LBOOKS_COMPASS_UNKNOWN),
    tooltip = GetString(LBOOKS_COMPASS_UNKNOWN_DESC),
    getFunc = function() return LoreBooks.db.filters[internal.PINS_COMPASS] end,
    setFunc = function(state)
      LoreBooks.db.filters[internal.PINS_COMPASS] = state
      COMPASS_PINS:RefreshPins(internal.PINS_COMPASS)
    end,
    default = LoreBooks.defaults.filters[internal.PINS_COMPASS],
  }
  optionsTable[#optionsTable + 1] = {
    type = "checkbox",
    name = GetString(LBOOKS_COMPASS_EIDETIC),
    tooltip = GetString(LBOOKS_COMPASS_EIDETIC_DESC),
    getFunc = function() return LoreBooks.db.filters[internal.PINS_COMPASS_EIDETIC] end,
    setFunc = function(state)
      LoreBooks.db.filters[internal.PINS_COMPASS_EIDETIC] = state
      COMPASS_PINS:RefreshPins(internal.PINS_COMPASS_EIDETIC)
    end,
    default = LoreBooks.defaults.filters[internal.PINS_COMPASS_EIDETIC],
  }
  optionsTable[#optionsTable + 1] = { -- Bookshelf
    type = "checkbox",
    name = GetString(LBOOKS_COMPASS_BOOKSHELF_NAME),
    tooltip = GetString(LBOOKS_COMPASS_BOOKSHELF_DESC),
    getFunc = function() return LoreBooks.db.filters[internal.PINS_COMPASS_BOOKSHELF] end,
    setFunc = function(state)
      LoreBooks.db.filters[internal.PINS_COMPASS_BOOKSHELF] = state
      COMPASS_PINS:RefreshPins(internal.PINS_COMPASS_BOOKSHELF)
    end,
    default = LoreBooks.defaults.filters[internal.PINS_COMPASS_BOOKSHELF],
  }
  optionsTable[#optionsTable + 1] = {
    type = "slider",
    name = GetString(LBOOKS_COMPASS_DIST),
    tooltip = GetString(LBOOKS_COMPASS_DIST_DESC),
    min = 1,
    max = 100,
    step = 1,
    getFunc = function() return LoreBooks.db.compassMaxDistance * 1000 end,
    setFunc = function(maxDistance)
      LoreBooks.db.compassMaxDistance = maxDistance / 1000
      COMPASS_PINS.pinLayouts[internal.PINS_COMPASS].maxDistance = maxDistance / 1000
      COMPASS_PINS:RefreshPins(internal.PINS_COMPASS)
      COMPASS_PINS.pinLayouts[internal.PINS_COMPASS_EIDETIC].maxDistance = maxDistance / 1000
      COMPASS_PINS:RefreshPins(internal.PINS_COMPASS_EIDETIC)
      COMPASS_PINS.pinLayouts[internal.PINS_COMPASS_BOOKSHELF].maxDistance = maxDistance / 1000
      COMPASS_PINS:RefreshPins(internal.PINS_COMPASS_BOOKSHELF)
    end,
    disabled = function() return not (LoreBooks.db.filters[internal.PINS_COMPASS] or LoreBooks.db.filters[internal.PINS_COMPASS_EIDETIC] or LoreBooks.db.filters[internal.PINS_COMPASS_BOOKSHELF]) end,
    default = LoreBooks.defaults.compassMaxDistance * 1000,
  }
  optionsTable[#optionsTable + 1] = {
    type = "dropdown",
    name = GetString(LBOOKS_IMMERSIVE),
    tooltip = GetString(LBOOKS_IMMERSIVE_DESC),
    choices = immersiveChoices,
    getFunc = function() return immersiveChoices[LoreBooks.db.immersiveMode] end,
    setFunc = function(selected)
      for index, name in ipairs(immersiveChoices) do
        if name == selected then
          LoreBooks.db.immersiveMode = index
          break
        end
      end
    end,
    default = immersiveChoices[LoreBooks.defaults.immersiveMode],
  }
  --[[
  {
    type = "checkbox",
    name = GetString(LBOOKS_UNLOCK_EIDETIC),
    tooltip = function()
      if LoreBooks.CanEmulateLibrary() then
        return GetString(LBOOKS_UNLOCK_EIDETIC_DESC)
      else
        return GetString(LBOOKS_UNLOCK_EIDETIC_WARNING)
      end
    end,
    getFunc = function() return LoreBooks.db.unlockEidetic end,
    setFunc = function(state)
      LoreBooks.db.unlockEidetic = state
      LORE_LIBRARY:BuildCategoryList()
    end,
    default = LoreBooks.defaults.unlockEidetic,
    disabled = function() return not LoreBooks.CanEmulateLibrary() end,
  },
  {
    type = "checkbox",
    name = GetString(LBOOKS_USE_QUEST_BOOKS),
    tooltip = GetString(LBOOKS_USE_QUEST_BOOKS_DESC),
    getFunc = function() return LoreBooks.db.useQuestBooks end,
    setFunc = function(state)
      LoreBooks.db.useQuestBooks = state
      LoreBooks.ToggleUseQuestBooks()
    end,
    default = LoreBooks.defaults.useQuestBooks,
  },
  {
    type = "checkbox",
    name = GetString(LBOOKS_SHARE_DATA),
    tooltip = GetString(LBOOKS_SHARE_DATA_DESC),
    getFunc = function() return LoreBooks.db.shareData end,
    setFunc = function(state)
      LoreBooks.db.shareData = state
      LoreBooks.ToggleShareData()
    end,
    default = LoreBooks.defaults.shareData,
    disabled = GetWorldName() ~= "EU Megaserver" or not internal.SUPPORTED_LANG[lang],
  },
  --]]
  LAM:RegisterOptionControls(internal.ADDON_PANEL, optionsTable)

end