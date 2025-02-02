local Register = LibCodesCommonCode.RegisterString

Register("SI_LOOTLOG_TITLE"             , "Loot Log")

Register("SI_LOOTLOG_SUBTITLE_LIST"     , "Loot History")
Register("SI_LOOTLOG_SUBTITLE_MATS"     , "Materials")

Register("SI_LOOTLOG_SHOW_UNCOLLECTED"  , "Show only uncollected items")
Register("SI_LOOTLOG_TIME_LABEL"        , "Materials collected since: %s")

Register("SI_LOOTLOG_HEADER_TIME"       , "Time")
Register("SI_LOOTLOG_HEADER_ITEM"       , "Item")
Register("SI_LOOTLOG_HEADER_TRAIT"      , "Trait")
Register("SI_LOOTLOG_HEADER_COUNT"      , "Qty")
Register("SI_LOOTLOG_HEADER_RECIPIENT"  , "Recipient")
Register("SI_LOOTLOG_HEADER_CURTOTAL"   , "Current Total")

Register("SI_LOOTLOG_MODE0"             , "None")
Register("SI_LOOTLOG_MODE1"             , "Set Items (Personal)")
Register("SI_LOOTLOG_MODE2"             , "Set Items")
Register("SI_LOOTLOG_MODE3"             , "Notable Loot (Personal)")
Register("SI_LOOTLOG_MODE4"             , "Notable Loot")
Register("SI_LOOTLOG_MODE5"             , "All Loot (Personal)")
Register("SI_LOOTLOG_MODE6"             , "All Logged")

Register("SI_LOOTLOG_HISTORY_LABEL"     , "History Retention: %dh (|c336699|l0:1:1:1:1:336699|lChange/Clear|l|r)")
Register("SI_LOOTLOG_CHATCOMMANDS_LINK" , "Want to bind or share set items? |c336699|l0:1:1:1:1:336699|lChat Commands|l|r")

Register("SI_LOOTLOG_CHATCOMMANDS"      , "Chat Commands")
Register("SI_LOOTLOG_LINKTRADE"         , "Link Surplus Set Items")
Register("SI_LOOTLOG_BINDUNCOLLECTED"   , "Bind Uncollected Set Items")

Register("SI_LOOTLOG_TRADE_REQUEST"     , "Request")
Register("SI_LOOTLOG_TRADE_LINKRESET"   , "Relink cooldowns for |c00CCFF/linktrade|r have been reset.")
Register("SI_LOOTLOG_TRADE_NOLINKS"     , "No items to link.")
Register("SI_LOOTLOG_TRADE_NOLINKS_CD"  , "No new items to link; to relink the %d recently-linked item(s), use the |c00CCFF/linktrade reset|r command.")
Register("SI_LOOTLOG_TRADE_OVERFLOW"    , "Items remaining: %d")
Register("SI_LOOTLOG_BIND_COMPLETED"    , "Items bound: %d%s")
Register("SI_LOOTLOG_BIND_OVERFLOW"     , "Items remaining: %d; to avoid message rate limit errors, wait briefly and use the |c00CCFF/binduncollected|r command again to bind the remaining items.")
Register("SI_LOOTLOG_BIND_SHOW"         , "Show Items")
Register("SI_LOOTLOG_AUTOBIND_ON"       , "Uncollected set items will be automatically bound for the next %d minutes.")
Register("SI_LOOTLOG_AUTOBIND_OFF"      , "Uncollected set items will no longer be automatically bound.")

Register("SI_LOOTLOG_SECTION_HISTORY"   , "History Data")
Register("SI_LOOTLOG_SECTION_CHAT"      , "Loot Notifications in Chat")
Register("SI_LOOTLOG_SECTION_TRADE"     , "Trading Tools")
Register("SI_LOOTLOG_SECTION_UNCCOLORS" , "Uncollected Indicator Colors")
Register("SI_LOOTLOG_SECTION_LCK"       , "LibCharacterKnowledge Support")
Register("SI_LOOTLOG_SECTION_MULTI"     , "Multi-Account Support")

Register("SI_LOOTLOG_SETTING_HISTORY"   , "Minimum history retention (hours)")
Register("SI_LOOTLOG_SETTING_CLEAR"     , "Clear History")
Register("SI_LOOTLOG_SETTING_CHATMODE"  , "Notification level")
Register("SI_LOOTLOG_SETTING_CHATICONS" , "Show icons")
Register("SI_LOOTLOG_SETTING_CHATSTOCK" , "Show crafting material stock")
Register("SI_LOOTLOG_SETTING_CHATUNC"   , "Flag uncollected items")
Register("SI_LOOTLOG_SETTING_CHATUNCTT" , "Additionally, if the notification mode is set to personal, uncollected items looted by other players will ignore the personal filter.")
Register("SI_LOOTLOG_SETTING_CHATRCLR"  , "Use static recipient color")
Register("SI_LOOTLOG_SETTING_TRADEITLS" , "Flag uncollected items everywhere")
Register("SI_LOOTLOG_SETTING_TRADEILTT" , "This includes player inventory, banks, vendor inventory, and loot windows.")
Register("SI_LOOTLOG_SETTING_TRADELINK" , "Flag uncollected items linked by others")
Register("SI_LOOTLOG_SETTING_TRADEREQ"  , "Show request link")
Register("SI_LOOTLOG_SETTING_TRADEREQ0" , GetString(SI_CHECK_BUTTON_DISABLED))
Register("SI_LOOTLOG_SETTING_TRADEREQ1" , "Before message")
Register("SI_LOOTLOG_SETTING_TRADEREQ2" , "After message")
Register("SI_LOOTLOG_SETTING_TRADEREQM" , "Request message")
Register("SI_LOOTLOG_SETTING_TRADEBE"   , "Include bind-on-equip items when using /linktrade")
Register("SI_LOOTLOG_SETTING_TRADEBETT" , "The |c00CCFF/linktrade|r (or |c00CCFF/lt|r) chat command will link in chat the tradeable bind-on-pickup items that have already been collected, and if this option is enabled, it will include bind-on-equip items as well.")
Register("SI_LOOTLOG_SETTING_ANTIQUITY" , "Enable antiquities-related features")
Register("SI_LOOTLOG_SETTING_ONLYMOTIF" , "Only flag treasure maps with motif leads")
Register("SI_LOOTLOG_SETTING_ACLRFULL"  , "Completed codex")
Register("SI_LOOTLOG_SETTING_ACLRINC"   , "Incomplete codex")
Register("SI_LOOTLOG_SETTING_ACLRNEVER" , "Never found")
Register("SI_LOOTLOG_SETTING_UCLRPERS"  , "Looted by you")
Register("SI_LOOTLOG_SETTING_UCLRGRP"   , "Looted by others")
Register("SI_LOOTLOG_SETTING_UCLRCHAT"  , "Linked by others")
Register("SI_LOOTLOG_SETTING_UCLRITLS"  , "Other contexts")

Register("SI_LOOTLOG_LCK_DESCRIPTION"   , "If enabled, Loot Log will consider the knowledge state of other characters when flagging recipes, furnishing plans, and motifs as unknown.")
Register("SI_LOOTLOG_MULTI_DESCRIPTION" , "If enabled, Loot Log can flag items that are uncollected by and tradeable with other accounts.\n\nTo use this feature, you must use the Account Priorities section below to configure which accounts to flag for.\n\nThis feature requires LibMultiAccountSets or LibMultiAccountCollectibles.")
Register("SI_LOOTLOG_MULTI_ACCOUNTS"    , "Account Priorities")
Register("SI_LOOTLOG_MULTI_PRIORITY"    , "Shareable priority %d")

Register("SI_LOOTLOG_SELF_IDENTIFIER"   , "You")

Register("SI_LOOTLOG_WELCOME"           , "You have installed |cCC33FFLoot Log 4|r, featuring support for item set collections and a |c00FFCC|H0:lootlog|hsearchable loot history|h|r that can be accessed via the |c00CCFF/lootlog|r chat command or via keybind. Please consult the |c00FFCC|H0:llweb|hLoot Log addon page|h|r for additional details.")
