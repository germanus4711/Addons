-- -----------------------------------------------------------------------------
--  LuiExtended                                                               --
--  Distributed under The MIT License (MIT) (see LICENSE file)                --
-- -----------------------------------------------------------------------------

--- @class (partial) LuiExtended
local LUIE = LUIE
-- -----------------------------------------------------------------------------
local zo_strformat = zo_strformat
local table_concat = table.concat
-- -----------------------------------------------------------------------------
local changelogMessages =
{
    -- Version Header
    "|cFFA500LuiExtended Version 6.8.7.2|r",
    "",
    -- General Changes
    "|cFFFF00General:|r",
    "|t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t Fixed frame snapping calculations for edge cases",
    "|t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t Optimized grid snapping performance",
    "|t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t Adjusted UI elements for better visual alignment",
    "",
    -- Version Header
    "|cFFA500LuiExtended Version 6.8.7.1|r",
    "",
    -- General Changes
    "|cFFFF00General:|r",
    "|t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t Minor bug fix, default frames we not snapping. They are now...",
    "",
    -- Version Header
    "|cFFA500LuiExtended Version 6.8.7|r",
    "",
    -- General Changes
    "|cFFFF00General:|r",
    "|t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t Added a new grid snapping system. Currently only for default game frames, custom unit frames, and the buffs & debuffs module.",
    "|t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t Code cleanup and optimizations.",
}
-- -----------------------------------------------------------------------------
-- Hide toggle called by the menu or xml button
function LUIE.ToggleChangelog(option)
    LUIE_Changelog:ClearAnchors()
    LUIE_Changelog:SetAnchor(CENTER, GuiRoot, CENTER, 0, -120)
    LUIE_Changelog:SetHidden(option)
end

-- -----------------------------------------------------------------------------
-- Called on initialize
function LUIE.ChangelogScreen()
    -- concat messages into one string
    local changelog = table_concat(changelogMessages, "\n")
    -- If text start with '*' replace it with bullet texture
    changelog = zo_strgsub(changelog, "%[%*%]", "|t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t")
    -- Set the window title
    LUIE_Changelog_Title:SetText(zo_strformat("<<1>> Changelog", LUIE.name))
    -- Set the about string
    LUIE_Changelog_About:SetText(zo_strformat("v<<1>> by <<2>>", LUIE.version, LUIE.author))
    -- Set the changelog text
    LUIE_Changelog_Text:SetText(changelog)

    -- Display the changelog if version number < current version
    if LUIESV.Default[GetDisplayName()]["$AccountWide"].WelcomeVersion ~= LUIE.version then
        LUIE_Changelog:SetHidden(false)
    end

    -- Set version to current version
    LUIESV.Default[GetDisplayName()]["$AccountWide"].WelcomeVersion = LUIE.version
end

-- -----------------------------------------------------------------------------
