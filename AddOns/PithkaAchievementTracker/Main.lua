
PITHKA = PITHKA or {}
 
PITHKA.name = "PithkaAchievementTracker"


---------------------------------------------------------------------------------------------------------
-- Initialize
---------------------------------------------------------------------------------------------------------

function PITHKA:Initialize()
  -- Register saved variables
  PITHKA.SV = ZO_SavedVars:NewAccountWide("PithkaSavedVariables", 1, nil, {
    options        = {
      enableTeleport = true,
    },
    state          = {
                      showExtra = true,
                      showWatermark = true,
                      currentScreen = 'dungeon',
                      title = '',

                      },

    scores         = {},
    runOnce        = {},
    })

  -- Register Keybinding Menu
  ZO_CreateStringId("SI_BINDING_NAME_TOGGLE_PITHKA", "Toggle Achievement Tracker")

  -- Register slash command
  SLASH_COMMANDS["/4m"] = function(keyWord, argument) PITHKA.UI.Layout.toggleWindow() end  
  SLASH_COMMANDS["/pat"] = function(keyWord, argument) PITHKA.UI.Layout.toggleWindow() end  
  SLASH_COMMANDS["/pledges"] = function(keyWord, argument) PITHKA.Data.Pledges.DailyPledges() end  
  SLASH_COMMANDS["/pledge"] = function(keyWord, argument) PITHKA.Data.Pledges.DailyPledges() end
  if PITHKA.SV.options.enableTeleport then
    SLASH_COMMANDS["/tp"] = PITHKA.Utils.Teleport -- Oct 30, 2023
  end



  -- create screens
  PITHKA.Screens.BaseDungeons.initialize()
  PITHKA.Screens.Dungeons.initialize()
  PITHKA.Screens.Trials.initialize()
  PITHKA.Screens.Trifectas.initialize()
  PITHKA.Screens.Nav.initialize()




  PITHKA.UI.Layout.refresh()

  -- Clean up toon renames 
  if GetDisplayName() ~= "@Pithka" then  -- for debugging
    PITHKA.Data.Scores.checkForToonRenames() -- needed just for scores
  end

  -- Register Options Panel
  PITHKA.LAM = LibAddonMenu2
  PITHKA.LAM:RegisterAddonPanel("PithkaAchievementTracker", PITHKA.Options.panelData)
  PITHKA.LAM:RegisterOptionControls("PithkaAchievementTracker", PITHKA.Options.optionsTable)
  
  
  SCENE_MANAGER:RegisterTopLevel(PITHKA_GUI, locksUIMode)

  -- fix bugs
  PITHKA.arenaBug()
end

---------------------------------------------------------------------------------------------------------
-- Fixes
---------------------------------------------------------------------------------------------------------

-- MSA was misrecorded under VSA
function PITHKA.arenaBug()
  if not PITHKA.SV.runOnce.arenaBug then
    local MSA_score = PITHKA.Data.Scores.getBestScoreString('MSA')
    local VSA_score = PITHKA.Data.Scores.getBestScoreString('VSA')
    if MSA_score == VSA_score then
      PITHKA.Data.Scores.resetScore('VSA', true)
      PITHKA.SV.runOnce.arenaBug = true
    end
  end
end



---------------------------------------------------------------------------------------------------------
-- Addon Callbacks Updater (on trial complete)
---------------------------------------------------------------------------------------------------------


-- On Toon Load ----------------------
function PITHKA.OnToonLoaded()
  -- -- initializing here breaks on subsequent character loads, only use for debugging
  -- d('late initialization so printing to chat works')
  -- PITHKA:Initialize() 
  -- PITHKA.UI.Layout.toggleWindow()
  -- PITHKA.Data.Scores.lbQuery()
end

EVENT_MANAGER:RegisterForEvent(PITHKA.name, EVENT_PLAYER_ACTIVATED, PITHKA.OnToonLoaded)


-- On Addon Load ----------------------
function PITHKA.OnAddOnLoaded(event, addonName)
  if addonName == PITHKA.name then
    PITHKA:Initialize()
    PITHKA.Data.Scores.lbQuery()
  end
end
 
EVENT_MANAGER:RegisterForEvent(PITHKA.name, EVENT_ADD_ON_LOADED, PITHKA.OnAddOnLoaded)


-- On Journal Search Result ----------------------
PITHKA.ACHIEVEMENTAID = 0
function PITHKA.achievementSearchCallback()
  -- limit to just searches trigged by addon
	if ACHIEVEMENTS.contentSearchEditBox:GetText() == GetAchievementName(PITHKA.ACHIEVEMENTAID) then
		-- navigate to category
		local categoryIndex, subCategoryIndex, achievementIndex = GetCategoryInfoFromAchievementId(PITHKA.ACHIEVEMENTAID)
		ACHIEVEMENTS:OpenCategory(categoryIndex, subCategoryIndex)
		-- expand achievement
		if ACHIEVEMENTS.achievementsById[PITHKA.ACHIEVEMENTAID] then
			ACHIEVEMENTS.achievementsById[PITHKA.ACHIEVEMENTAID]:Expand()
		end
	end
end

EVENT_MANAGER:RegisterForEvent(PITHKA.name, EVENT_ACHIEVEMENTS_SEARCH_RESULTS_READY, PITHKA.achievementSearchCallback)     

