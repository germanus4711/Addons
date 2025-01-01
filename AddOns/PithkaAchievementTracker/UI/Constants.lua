-- Initialize file
PITHKA              = PITHKA or {}
PITHKA.UI           = PITHKA.UI or {}
PITHKA.UI.Constants = {
	-- fonts
	defaultFont     = "$(MEDIUM_FONT)|$(KB_18)|soft-shadow-thin",
	boldFont        = 'ZoFontGameBold',
	smallFont       = "ZoFontGameSmall",
	fixedWidthFont  = "$(PITHKA_CONSOLAS_FONT)|$(KB_15)|soft-shadow-thin",

	-- rgb colors
	rgbClear		= {1,1,1,0},
	rgbWhite        = {1,1,1,.9},
	rgbGray         = {1,1,1,.35},
	rgbBlue   		= {128/255, 128/255, 1, 1},
	rgbGold			= {230/225, 230/225, 180/225, 1},
	rgbGreen        = {0.2, 1, 0.2, 1},

	-- hex colors
	hexBlue         = 'c8080ff',
	hexYellow       = 'cFFFF00',
	hexGold			= 'cc5c29e',
	
	-- alpha
	whiteAlpha      = 1,
	grayAlpha       =.45,

	-- sizes
	labelHeight     = 23,
	iconSize        = 23,
	spacer          = 5,
	navIconSize     = 35,

	-- textures
	texture = {
		HM        = "esoui/art/campaign/gamepad/gp_bonusicon_scrolls.dds",
		SR        = "esoui/art/miscellaneous/gamepad/gp_icon_timer32.dds",
		ND        = "esoui/art/icons/mapkey/mapkey_groupboss.dds",
		TRI       = "esoui/art/icons/guildranks/guild_rankicon_misc11.dds",
		STAR      = "esoui/art/tutorial/ava_rankicon64_general.dds",
		LFG       = "esoui/art/lfg/lfg_tabicon_mygroup_over.dds",
		DUNGEON   = 'esoui/art/icons/poi/poi_dungeon_complete.dds',
		INSTANCE  = 'esoui/art/icons/poi/poi_groupinstance_complete.dds',
		--DUNGEON   = 'esoui/art/icons/mapkey/mapkey_dungeon.dds',
		TRIAL     = 'esoui/art/icons/mapkey/mapkey_solotrial.dds' ,
		CHECKOFF  = 'esoui/art/cadwell/checkboxicon_unchecked.dds',
		CHECKON   = 'esoui/art/cadwell/checkboxicon_checked.dds',
		PERSON    = 'esoui/art/tutorial/menubar_character_up.dds',
		TWOPEOPLE = 'esoui/art/tutorial/tutorial_idexicon_contacts_up.dds',
		GROUP     = 'esoui/art/treeicons/tutorial_idexicon_groups_up.dds',
		CHECK     = "esoui/art/buttons/accept_up.dds", 
		BOX       = "esoui/art/buttons/swatchframe_down.dds",
		X         = "esoui/art/buttons/decline_up.dds",
	  },
}
