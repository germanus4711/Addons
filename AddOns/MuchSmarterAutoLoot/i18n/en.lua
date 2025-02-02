
ZO_CreateStringId("MSAL_PANEL_NAME", "Lykeion's Much Smarter AutoLoot")
ZO_CreateStringId("MSAL_PANEL_DISPLAYNAME", "|c265a91L|r|c2c5c8ey|r|c325e8ak|r|c396086e|r|c3f6283i|r|c45647fo|r|c4b677cn|r|c516978'|r|c576b74s|r |c5d6d71M|r|c646f6du|r|c6a7169c|r|c707366h|r |c767562S|r|c7c775em|r|c82795ba|r|c887b57r|r|c8f7d53t|r|c957f50e|r|c9b814cr|r |ca18449A|r|ca78645u|r|cad8841t|r|cb38a3eo|r|cba8c3aL|r|cc08e36o|r|cc69033o|r|ccc922ft|r")
-- descriptions and helps
ZO_CreateStringId("MSAL_HELP_TITLE","|c999999Much Smarter AutoLoot gives you full control over your looting, making it full automated by simply setting your preferences in the filters|r")
ZO_CreateStringId("MSAL_HELP_GEAR","|c999999For and only for |ceeeeeeCollected Set Gear that has not been looted|c999999, the addon will use subsequent filters to further determine whether or not to loot it|r")
ZO_CreateStringId("MSAL_HELP_MATERIAL","|c999999Materials will be looted automatically when sub ESO+, regardless of what their filters are set to, unless they are stolen|r")
ZO_CreateStringId("MSAL_HELP_CURRENCY","|c999999Even if the filter is set to Always Loot, lootings that would cause the total amount of currency to exceed the currency max cap will be blocked|r")
ZO_CreateStringId("MSAL_HELP_MISC","|c999999For some tradeable high-value items, MSAL supports price comparison via third-party addons (TTC, MM and ATT supported). \nFunctions related will be automatically added to this menu when you enable them|r")
ZO_CreateStringId("MSAL_HELP_MISC_TRIMED","|c999999For some tradeable high-value items, MSAL supports price comparison via third-party addons (TTC, MM and ATT supported) \nWhen set to reference a third-party addon, non-tradable items of this type will be looted directly|r")
ZO_CreateStringId("MSAL_HELP_LIST","|c999999%s / %s provide a more flexible way to customize rules, and they are prioritized over all other filters. Want to exclude %s from your collection for later sale? Add it to the %s! (You can still pick it up manually) Want %s but don't need any other %s? Add it to the %s! \n\nPaste an item link in Add Item edit box and press Enter to add it to the list; Click on the Remove Item drop-down menu to check the list, and click on any of the items to remove it.|r")
-- submenu titles
ZO_CreateStringId("MSAL_GENERAL_SETTINGS","General Settings")
ZO_CreateStringId("MSAL_GEAR_FILTERS","Gear Filters")
ZO_CreateStringId("MSAL_MISC_FILTERS","Misc Filters")
ZO_CreateStringId("MSAL_CURRENCY_FILTERS","Currency Filters")
ZO_CreateStringId("MSAL_MATERIAL_FILTERS","Material Filters")
ZO_CreateStringId("MSAL_BLIST","Blacklist")
ZO_CreateStringId("MSAL_WLIST","Whitelist")
-- general option
ZO_CreateStringId("MSAL_ENABLE_MSAL","Enable Much Smarter AutoLoot")
ZO_CreateStringId("MSAL_ENABLE_MSAL_TOOLTIP","The game's built-in AutoLoot would be turned off when enable MSAL. You can also use \'\/msalt\' or keybinding to switch addon quickly")
ZO_CreateStringId("MSAL_DEBUG","Debug Mode")
ZO_CreateStringId("MSAL_DEBUG_TOOLTIP","Enabling this option will print the information needed for debug to the chat box")
ZO_CreateStringId("MSAL_SHOW_ITEM_LINKS","Print Looted Item Links")
ZO_CreateStringId("MSAL_SHOW_ITEM_LINKS_TOOLTIP","When enabled, links to all looted items will be sent to the chat box. These links are only visible to you")
ZO_CreateStringId("MSAL_SHOW_ITEM_LINKS_THRESHOLD","- Print Only High Quality Items")
ZO_CreateStringId("MSAL_SHOW_ITEM_LINKS_THRESHOLD_TOOLTIP","When enabled, only |c9933ccPurple|r or higher quality items will be printed")
ZO_CreateStringId("MSAL_CLOSE_LOOT_WINDOW","Auto-Close Loot Window")
ZO_CreateStringId("MSAL_CLOSE_LOOT_WINDOW_TOOLTIP","When enabled, the loot window will automatically exit when the autoloot is complete, unless it's a container in the backpack")
ZO_CreateStringId("MSAL_SMARTER_CLOSE_LOOT_WINDOW","- Smarter Close")
ZO_CreateStringId("MSAL_SMARTER_CLOSE_LOOT_WINDOW_TOOLTIP","No longer automatically closes when the same target is opened repeatedly in succession")
ZO_CreateStringId("MSAL_CONSIDERATE_MODE","Considerate Mode")
ZO_CreateStringId("MSAL_CONSIDERATE_MODE_TOOLTIP","When enabled, looting resource nodes and opening locked chests will ignore the rules and loot all the stuff, thus leaving no remnants on the map. \n\nUnwanted items will be destroyed afterward")
ZO_CreateStringId("MSAL_CONSIDERATE_MODE_PRINT","- Print Destroyed Items")
ZO_CreateStringId("MSAL_GREEDY_MODE","Greedy Mode")
ZO_CreateStringId("MSAL_GREEDY_MODE_TOOLTIP","When enabled, you will always loot stackable items regardless of the rules, as long as they don't take up an extra backpack slot")
ZO_CreateStringId("MSAL_STOLEN_ITEMS_RULE","Stolen Items Rule")
ZO_CreateStringId("MSAL_STOLEN_ITEMS_RULE_TOOLTIP","Stolen Items will not be looted by default. You can set global settings for how the addon handles stolen items here.\n\nWhen looting stolen items you can also hold down |cdb8e0bSHIFT|r to temporarily ignore the rules set here and loot them up according to their respective rules")
ZO_CreateStringId("MSAL_LOGIN_REMINDER","Reminder at Login")
ZO_CreateStringId("MSAL_LOGIN_REMINDER_TOOLTIP","When enabled, it will prompt for addon related information in the chat box when logging in")
ZO_CreateStringId("MSAL_AUTOBIND_TOOLTIP","When enabled, the |cdb8e0bUncollected and Not-Blacklisted|r set items will be autobound when looted")
ZO_CreateStringId("MSAL_ADD_ITEM","Add %s Item")
ZO_CreateStringId("MSAL_REMOVE_ITEM","Remove %s Item")
-- crafting materials filters
ZO_CreateStringId("MSAL_CRAFTING_MATERIALS","Crafting Materials")
ZO_CreateStringId("MSAL_CRAFTING_MATERIALS_TOOLTIP","Including clothing, blacksmithing, woodworking and jewelry crafting")
-- gears filters
ZO_CreateStringId("MSAL_QUALITY_THRESHOLD","Quality Threshold")
ZO_CreateStringId("MSAL_QUALITY_THRESHOLD_TOOLTIP","The minimum quality of items to be looted. 1 represents for white, and so on")
ZO_CreateStringId("MSAL_VALUE_THRESHOLD","Value Threshold")
ZO_CreateStringId("MSAL_VALUE_THRESHOLD_TOOLTIP","The minimum value of items to be looted")
ZO_CreateStringId("MSAL_ORNATE_ITEMS","Ornate Items")
ZO_CreateStringId("MSAL_INTRICATE_ITEMS","Intricate Items")
ZO_CreateStringId("MSAL_CLOTHING_INTRICATE_ITEMS","- Clothing Intricate Items")
ZO_CreateStringId("MSAL_BLACKSMITHING_INTRICATE_ITEMS","- Blacksmithing Intricate Items")
ZO_CreateStringId("MSAL_WOODWORKING_INTRICATE_ITEMS","- Woodworking Intricate Items")
ZO_CreateStringId("MSAL_JEWELRY_INTRICATE_ITEMS","- Jewelry Intricate Items")
ZO_CreateStringId("MSAL_WEAPONS","General Weapons")
ZO_CreateStringId("MSAL_ARMORS","General Armors")
ZO_CreateStringId("MSAL_JEWELRY","General Jewelry")
ZO_CreateStringId("MSAL_AUTOBIND","AutoBind Uncollected Set Items")
ZO_CreateStringId("MSAL_UNCAPPED_CURRENCY","Autoloot Uncapped Currencies")
-- options
ZO_CreateStringId("MSAL_ALWAYS_LOOT","Always Loot")
ZO_CreateStringId("MSAL_NEVER_LOOT","Never Loot")
ZO_CreateStringId("MSAL_FOLLOW","Follow Respective Rules")
ZO_CreateStringId("MSAL_ONLY_UNCOLLECTED","Only Uncollected")
ZO_CreateStringId("MSAL_WEAPON_AND_JEWELRY","Weapon and Jewelry")
ZO_CreateStringId("MSAL_UNCOLLECTED_AND_JEWELRY","Uncollected and Jewelry")
ZO_CreateStringId("MSAL_UNCOLLECTED_AND_NON_JEWELRY","Uncollected and Non-Jewelry")
ZO_CreateStringId("MSAL_ONLY_COLLECTED","Only Collected")                                           
ZO_CreateStringId("MSAL_TYPE_BASED","Type-based")
ZO_CreateStringId("MSAL_ONLY_NON_RACIAL","Only DLC Styles")
ZO_CreateStringId("MSAL_ONLY_BASTIAN","Only Bastian Potions")
ZO_CreateStringId("MSAL_ONLY_NON_BASTIAN","Only Non-Bastian Potions")
ZO_CreateStringId("MSAL_ONLY_GOLD_INGREDIENTS","Only Gold Ingredients")
ZO_CreateStringId("MSAL_ONLY_NIRNHONED","Only Nirnhoned")
ZO_CreateStringId("MSAL_ONLY_EXP_BOOSTER","Only EXP Booster")
ZO_CreateStringId("MSAL_ONLY_FILLED","Only Filled")
ZO_CreateStringId("MSAL_ONLY_UNKNOWN","Only Unknown")
ZO_CreateStringId("MSAL_ONLY_NON_BASE_ZONE","Only DLC Zone Maps")
ZO_CreateStringId("MSAL_ONLY_KUTA_HAKEIJO","Only Kuta & Hakeijo & Indeko")
ZO_CreateStringId("MSAL_PER_QUALITY_THRESHOLD","Per Quality Threshold")
ZO_CreateStringId("MSAL_PER_VALUE_THRESHOLD","Per Value Threshold")
ZO_CreateStringId("MSAL_THIRD_PARTY_AVG_THRESHOLD","Third-party Avg Price Threshold")
ZO_CreateStringId("MSAL_THIRD_PARTY_AVG_THRESHOLD_TOOLTIP","On some of the filters, you can set the price threshold for looting items based on the |cdb8e0bAverage Sale Price|r information from third-party addons. Currently supports TTC, MM and ATT")
ZO_CreateStringId("MSAL_LOOT_NO_PRICE_ITEM","Loot Third-Party No Price Item")
ZO_CreateStringId("MSAL_LOOT_NO_PRICE_ITEM_TOOLTIP","When the filter is set to refer to a third-party price, loot items for which no average sale price information is available")
ZO_CreateStringId("MSAL_LOOT_UNKNOWN_ITEM","Always Loot Unknown Collectibles")
ZO_CreateStringId("MSAL_LOOT_UNKNOWN_ITEM_TOOLTIP","Always loot unknown collectibles regardless of filter settings")
ZO_CreateStringId("MSAL_ONLY_ACCOUNTWIDE_UNKNOWN","- Only Account-wide Unknown Collectibles")
ZO_CreateStringId("MSAL_ONLY_ACCOUNTWIDE_UNKNOWN_TOOLTIP","Don't loot if the collectibles has been learned by any character. Requires LibCharacterKnowledge")
ZO_CreateStringId("MSAL_PER_TTC","Per TTC")
ZO_CreateStringId("MSAL_PER_MM","Per MM")
ZO_CreateStringId("MSAL_PER_ATT","Per ATT")
-- chat box
ZO_CreateStringId("MSAL_CLOSE_LOOT_WINDOW_REMINDER","|cdb8e0b [Much Smarter AutoLoot] Close Loot Window is enabled. This will automatically close the looting window after looting the matching items|r")
ZO_CreateStringId("MSAL_DEBUG_MODE_REMINDER","|cdb8e0b [Much Smarter AutoLoot] Debug mode is enabled. This will print the looted item info in the chat box|r")
ZO_CreateStringId("MSAL_EXCEED_WARNING","|cdb8e0b [Much Smarter AutoLoot] |c215895<<1>>|cdb8e0b close to the cap, thus not looted|r")
ZO_CreateStringId("MSAL_UPDATE_IMFORM","With the new |c215895%s|r / |cdb8e0b%s|r feature in release 5.0.0, you can customize your autolooting even further! Learn more in the addon menu")
ZO_CreateStringId("MSAL_THIRD_PARTY_DAFAULT_WARNING","|c215895Some of |cdb8e0bMuch Smarter AutoLoot|c215895 filters do not work properly due to missing <<1>>. Please check if the corresponding addon has been activated, or change the corresponding filter settings.|r")
ZO_CreateStringId("MSAL_THIRD_PARTY_DAFAULT_WARNING_NEVER_SHOW","Don't show again")
ZO_CreateStringId("MSAL_LIST_CONFLICT","%s is on the other list, remove it first!")
ZO_CreateStringId("MSAL_LIST_ALREADY_EXIST","%s is already on %s")
ZO_CreateStringId("MSAL_LIST_ADD","%s added to %s")
ZO_CreateStringId("MSAL_LIST_REMOVE","%s removed from %s")
ZO_CreateStringId("MSAL_LIST_CONSIDERATE_CONFLICT","Attention! There is a blacklisted item in the chest, thus the %s is not fully executed")
-- keybinding
ZO_CreateStringId("SI_BINDING_NAME_MSAL_TOGGLE", "Toggle")
ZO_CreateStringId("SI_BINDING_NAME_MSAL_MENU", "Show Menu")