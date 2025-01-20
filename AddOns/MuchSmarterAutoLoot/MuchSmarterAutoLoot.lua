local MuchSmarterAutoLoot = ZO_Object:Subclass()
local MuchSmarterAutoLootSettings = ZO_Object:Subclass()

local startupInfoPrinted = false
local addonVersion = "5.0.1"
local settingPanel = {}
local MSAL_NEVER_3RD_PARTY_WARNING = "msal_never_3rd_party_warning"
local templateItemlink = "|H1:item:%s:123:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h"
local WM = GetWindowManager()
local SV_NAME = 'MSAL_VARS'
local SV_VER = 1
local db

-- local gearLooted = false
local lastExceed

local lastUpdated = 0
local lastFoolUpdated = 0
local lastDefault = 0

local setItemRegister = {}
local isRepetitiveGear = false

local lastUnlockTime = 0
local isResourceNode = false
local isLockedChest = false
local lootingBagContainer = false
local unwantedLootIdList = {}
local unwantedNameList = {}
local lastNotLootedNameList = {}
local currentNotLootedNameList = {}

local TOKEN_BLIST = 0
local TOKEN_WLIST = 1
local tempBlist = {}

local defaults = {
    latestMajorUpdateVersion = "",
    never3rdPartyWaining = false,
    initPlusCheck = false,
    enabled = true,
    debugMode = false,
    printItems = false,
    printItemThreshold = true,
    closeLootWindow = false,
    closeLootWindowSmarter = true,
    considerateMode = false,
    considerateModePrint = false,
    greedyMode = false,
    lootStolen = false,
    loginReminder = true,
    stolenRule = "never loot",
    minimumQuality = 1,
    minimumValue = 0,
    autoBind = false,
    blacklist = {},
    whitelist = {},
    -- filters, use plural for key and value by default
    filters = {
        set = "always loot",
        uncollected = "always loot",
        unresearched = "always loot",
        ornate = "always loot",
        intricate = "always loot",
        clothingIntricate = "always loot",
        blacksmithingIntricate = "always loot",
        woodworkingIntricate = "always loot",
        jewelryIntricate = "always loot",
        companionGears = "always loot",
        weapons = "never loot",
        armors = "never loot",
        jewelry = "never loot",

        craftingMaterials = "never loot",
        traitMaterials = "never loot",
        styleMaterials = "never loot",
        runes = "never loot",
        alchemy = "never loot",
        ingredients = "only gold ingredients",
        furnishingMaterials = "never loot",

        uncapped = true,
        crystals = "always loot",

        thirdPartyMinValue = 10000,
        lootThirdPartyNoPrice = true,
        alwaysLootUnknown = true,
        onlyLootAccountwideUnknown = false,

        questItems = "always loot",
        crownItems = "always loot",
        containers = "always loot",
        leads = "always loot",
        soulGems = "only filled",
        recipes = "never loot",
        writs = "never loot",
        treasureMaps = "only non-base-zone",
        glyphs = "never loot",
        treasures = "never loot",
        potions = "never loot",
        -- collectibles = "never loot",
        foodAndDrink = "only exp booster",
        poisons = "never loot",
        costumes = "never loot",
        fishingBaits = "never loot",
        lockpicks = "never loot",
        tools = "never loot",
        allianceWarConsumables = "never loot",
        furniture = "never loot",
        trash = "never loot",
        scribing = "always loot"
    }
}

local basezoneTreasureMapID = {
    -- khenarthisroost
    43695,43696,43697,43698,44939,45010,
    -- bleakrock
    43699,43700,44931, 
    -- balfoyen
    43701,43702,44928, 
    -- strosmkai
    43691,43692,44946, 
    -- betnihk
    43693,43694,44930, 
    -- auridon
    43625,43626,43627,43628,43629,43630,44927, 
    -- grahtwood
    43631,43632,43633,43634,43635,43636,44937, 
    -- greenshade
    43637,43638,43639,43640,43641,43642,44938, 
    -- malabaltor
    43643,43644,43645,43646,43647,43648,44940, 
    -- reapersmarch
    43649,43650,43651,43652,43653,43654,44941, 
    -- stonefalls
    43655,43656,43657,43658,43659,43660,44944, 
    -- deshaan
    43661,43662,43663,43664,43665,43666,44934, 
    -- shadowfen
    43667,43668,43669,43670,43671,43672,44943, 
    -- eastmarch
    43673,43674,43675,43676,43677,43678,44935, 
    -- therift
    43679,43680,43681,43682,43683,43684,44947, 
    -- glenumbra
    43507,43525,43527,43600,43509,43526,44936, 
    -- stormhaven
    43601,43602,43603,43604,43605,43606,44945, 
    -- rivenspire
    43607,43608,43609,43610,43611,43612,44942, 
    -- alikr
    43613,43614,43615,43616,43617,43618,44926, 
    -- bangkorai
    43619,43620,43621,43622,43623,43624,44929, 
    -- coldharbour
    43685,43686,43687,43688,43689,43690,44932, 
    -- craglorn
    43721,43722,43723,43724,43725,43726
}

local jewelryTraits = {
    [ITEM_TRAIT_TYPE_JEWELRY_ARCANE] = true,
    [ITEM_TRAIT_TYPE_JEWELRY_BLOODTHIRSTY] = true,
    [ITEM_TRAIT_TYPE_JEWELRY_HARMONY] = true,
    [ITEM_TRAIT_TYPE_JEWELRY_HEALTHY] = true,
    [ITEM_TRAIT_TYPE_JEWELRY_INFUSED] = true,
    [ITEM_TRAIT_TYPE_JEWELRY_PROTECTIVE] = true,
    [ITEM_TRAIT_TYPE_JEWELRY_ROBUST] = true,
    [ITEM_TRAIT_TYPE_JEWELRY_SWIFT] = true,
    [ITEM_TRAIT_TYPE_JEWELRY_TRIUNE] = true,
    [ITEM_TRAIT_TYPE_JEWELRY_INTRICATE] = true,
    [ITEM_TRAIT_TYPE_JEWELRY_ORNATE] = true
}

local matItemType = {
    [ITEMTYPE_BLACKSMITHING_BOOSTER] = true,
    [ITEMTYPE_BLACKSMITHING_MATERIAL] = true,
    [ITEMTYPE_BLACKSMITHING_RAW_MATERIAL] = true,
    [ITEMTYPE_CLOTHIER_BOOSTER] = true,
    [ITEMTYPE_CLOTHIER_MATERIAL] = true,
    [ITEMTYPE_CLOTHIER_RAW_MATERIAL] = true,
    [ITEMTYPE_WOODWORKING_BOOSTER] = true,
    [ITEMTYPE_WOODWORKING_MATERIAL] = true,
    [ITEMTYPE_WOODWORKING_RAW_MATERIAL] = true,
    [ITEMTYPE_JEWELRYCRAFTING_BOOSTER] = true,
    [ITEMTYPE_JEWELRYCRAFTING_MATERIAL] = true,
    [ITEMTYPE_JEWELRYCRAFTING_RAW_BOOSTER] = true,
    [ITEMTYPE_JEWELRYCRAFTING_RAW_MATERIAL] = true,
    [ITEMTYPE_RAW_MATERIAL] = true,
    [ITEMTYPE_STYLE_MATERIAL] = true,
    [ITEMTYPE_WEAPON_TRAIT] = true,
    [ITEMTYPE_ARMOR_TRAIT] = true,
    [ITEMTYPE_JEWELRY_RAW_TRAIT] = true,
    [ITEMTYPE_JEWELRY_TRAIT] = true,
    [ITEMTYPE_INGREDIENT] = true,
    [ITEMTYPE_POTION_BASE] = true,
    [ITEMTYPE_POISON_BASE] = true,
    [ITEMTYPE_REAGENT] = true,
    [ITEMTYPE_ENCHANTING_RUNE_ASPECT] = true,
    [ITEMTYPE_ENCHANTING_RUNE_ESSENCE] = true,
    [ITEMTYPE_ENCHANTING_RUNE_POTENCY] = true,
    [ITEMTYPE_ENCHANTMENT_BOOSTER] = true,
    [ITEMTYPE_FURNISHING_MATERIAL] = true,
    [ITEMTYPE_LURE] = true
}

local nodeMatItemType = {
    [ITEMTYPE_BLACKSMITHING_RAW_MATERIAL] = true,
    [ITEMTYPE_CLOTHIER_RAW_MATERIAL] = true,
    [ITEMTYPE_WOODWORKING_RAW_MATERIAL] = true,
    [ITEMTYPE_JEWELRYCRAFTING_RAW_MATERIAL] = true,
    [ITEMTYPE_JEWELRY_RAW_TRAIT] = true,
    [ITEMTYPE_RAW_MATERIAL] = true,
    [ITEMTYPE_REAGENT] = true,
    [ITEMTYPE_ENCHANTING_RUNE_ASPECT] = true,
    [ITEMTYPE_ENCHANTING_RUNE_ESSENCE] = true,
    [ITEMTYPE_ENCHANTING_RUNE_POTENCY] = true,
    [ITEMTYPE_ENCHANTMENT_BOOSTER] = true,
    [ITEMTYPE_FURNISHING_MATERIAL] = true,
    [ITEMTYPE_LURE] = true,
    [ITEMTYPE_SCRIBING_INK] = true,
}

local portalName = {
    ["de"] = "Psijik-Portal",
    ["en"] = "Psijic Portal",
    ["es"] = "Portal psijic",
    ["fr"] = "Portail psijique",
    ["jp"] = "サイジックのポータル",
    ["ru"] = "Портал Псиджиков",
    ["ze"] = "赛伊克传送门",
    ["zh"] = "赛伊克传送门",
}

local curtType = {
    CURT_ALLIANCE_POINTS,
    CURT_ENDLESS_DUNGEON,
    CURT_CROWNS,
    CURT_CROWN_GEMS,
    CURT_ENDEAVOR_SEALS,
    CURT_EVENT_TICKETS,
    CURT_STYLE_STONES,
    CURT_TELVAR_STONES,
    CURT_UNDAUNTED_KEYS,
    CURT_WRIT_VOUCHERS,
    CURT_IMPERIAL_FRAGMENTS,
    CURT_CHAOTIC_CREATIA
}

local function OnLockpickSuccess()
    lastUnlockTime = GetGameTimeMilliseconds()
end

local function OnLootClosed()
    lootingBagContainer = false
end

local function OnUnwantedLootClosed()
    -- d("triggered")
    -- isResourceNode = false
    -- isLockedChest = false
    unwantedLootIdList = {}
    unwantedNameList = {}

    EVENT_MANAGER:UnregisterForEvent("MSAL_UNWANTED_UPDATE", EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
    EVENT_MANAGER:UnregisterForEvent("MSAL_LOOT_CLOSED", EVENT_LOOT_CLOSED)
end

local function OnUnwantedUpdated(_, bagId, slotId, isNewItem, _, _, _)
    -- d("OnUnwantedUpdated")
    if bagId ~= BAG_BACKPACK then
        return
    end
    local itemName = string.lower(GetItemName(bagId, slotId))
    local link = GetItemLink(bagId, slotId)
    local unwanted = false
    for i = 1, #unwantedNameList, 1 do
        if unwantedNameList[i] ~= nil and unwantedNameList[i] == itemName then
            unwanted = true
        end
    end
    -- d("unwanted: "..tostring(unwanted))
    if unwanted then
        if db.considerateModePrint then
            d(GetString(SI_ITEM_ACTION_DESTROY) .. " " .. link)
        end
        DestroyItem(bagId, slotId)
    end
end

local function ArrayHasItem(arr, item)
    for i = 1, #arr do
        if arr[i] ~= nil and arr[i] == item then
            return true
        end
    end
    return false
end

local function IsSameArray(a, b)
    if #a ~= #b then
        return false
    end

    for i = 1, #a do
        if a[i] ~= b[i] then
            return false
        end
    end

    return true
end

local function AddDynamicThirdPartyPriceSupport(choice, value)
    -- d("ArrayHasItem length "..#arr)
    local resultChoice, resultValue = {}, {}
    
    for k, v in pairs(choice) do
        resultChoice[k] = v
    end
    for k, v in pairs(value) do
        resultValue[k] = v
    end

    if TamrielTradeCentre then
        table.insert(resultChoice, GetString(MSAL_PER_TTC))
        table.insert(resultValue, "per ttc")
    end

    if MasterMerchant then
        table.insert(resultChoice, GetString(MSAL_PER_MM))
        table.insert(resultValue, "per mm")
    end

    if ArkadiusTradeTools then
        table.insert(resultChoice, GetString(MSAL_PER_ATT))
        table.insert(resultValue, "per att")
    end
    return resultChoice, resultValue
end

local function HandleChatboxClick(link, button, text, linkStyle, linkType, dataString)
    if button ~= MOUSE_BUTTON_INDEX_LEFT then return end
    if linkType == MSAL_NEVER_3RD_PARTY_WARNING then
        db.never3rdPartyWaining = true
        return true
    end
end
LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_CLICKED_EVENT, HandleChatboxClick)
LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_MOUSE_UP_EVENT, HandleChatboxClick)

local function IsValidFilterType(filterType)
    if (filterType == nil) then
        return false
    end
    if ( not MasterMerchant and filterType == "per mm") then
        local currentTime = GetGameTimeMilliseconds()
        if currentTime - lastDefault > 600000 and not db.never3rdPartyWaining then
            local printLink = ZO_LinkHandler_CreateLinkWithoutBrackets(GetString(MSAL_THIRD_PARTY_DAFAULT_WARNING_NEVER_SHOW), nil, MSAL_NEVER_3RD_PARTY_WARNING)
            CHAT_ROUTER:AddSystemMessage(zo_strformat(GetString(MSAL_THIRD_PARTY_DAFAULT_WARNING), "MasterMerchant") .. " " .. printLink)
            lastDefault = currentTime
        end
        return false
    end
    
    if ( not TamrielTradeCentre and filterType == "per ttc") then
        local currentTime = GetGameTimeMilliseconds()
        if currentTime - lastDefault > 600000 and not db.never3rdPartyWaining then
            local printLink = ZO_LinkHandler_CreateLinkWithoutBrackets(GetString(MSAL_THIRD_PARTY_DAFAULT_WARNING_NEVER_SHOW), nil, MSAL_NEVER_3RD_PARTY_WARNING)
            CHAT_ROUTER:AddSystemMessage(zo_strformat(GetString(MSAL_THIRD_PARTY_DAFAULT_WARNING), "TamrielTradeCentre") .. " " .. printLink)
            lastDefault = currentTime
        end
        return false
    end
    
    if ( not ArkadiusTradeTools and filterType == "per att") then
        local currentTime = GetGameTimeMilliseconds()
        if currentTime - lastDefault > 600000 and not db.never3rdPartyWaining then
            local printLink = ZO_LinkHandler_CreateLinkWithoutBrackets(GetString(MSAL_THIRD_PARTY_DAFAULT_WARNING_NEVER_SHOW), nil, MSAL_NEVER_3RD_PARTY_WARNING)
            CHAT_ROUTER:AddSystemMessage(zo_strformat(GetString(MSAL_THIRD_PARTY_DAFAULT_WARNING), "ArkadiusTradeTools") .. " " .. printLink)
            lastDefault = currentTime
        end
        return false
    end
    return true
end

local function IsItemKnownByAnyCharacter(item, server, includedCharIds)
    local LCK = LibCharacterKnowledge
    -- Assume you have access to LCK.GetItemKnowledgeList function
    local knowledgeList = LCK.GetItemKnowledgeList(item, server, includedCharIds)

    -- Iterate through the list of characters
    for _, charInfo in pairs(knowledgeList) do
        -- d(charInfo.name.." : "..charInfo.knowledge)
        if charInfo.knowledge == LCK.KNOWLEDGE_KNOWN then
            return true -- Item is known by at least one character
        end
    end

    return false -- Item is not known by any character
end

local function ShouldLootGear(filterType, quality, value)
    if not IsValidFilterType(filterType) then
        return false
    end

    -- d("checking ShouldLootGear for "..filterType)
    if (filterType == "always loot") then
        -- gearLooted = true
        return true
    end
    if (filterType == "never loot") then
        return false
    end

    if (filterType == "per quality threshold" and quality >= db.minimumQuality) then
        -- gearLooted = true
        return true
    end

    if (filterType == "per value threshold" and value >= db.minimumValue) then
        -- gearLooted = true
        return true
    end

    return false
end

local function ShouldLootSet(filterType, isUncollected, isJewelry, isWeapon)
    if not IsValidFilterType(filterType) then
        return false
    end

    -- d("checking ShouldLootGear for "..filterType)
    if (filterType == "always loot") then
        return true
    end
    if (filterType == "never loot") then
        return false
    end

    if (filterType == "only uncollected" and isUncollected) then
        return true
    end

    if (filterType == "uncollected and jewelry" and (isUncollected or isJewelry)) then
        return true
    end

    if (filterType == "uncollected and non-jewelry" and isUncollected and not isJewelry) then
        return true
    end

    if (filterType == "weapon and jewelry" and (isJewelry or isWeapon)) then
        return true
    end

    if (filterType == "only collected" and not isUncollected) then
        return true
    end

    return false
end

local function ShouldLootIngredient(filterType, quality)
    if (IsESOPlusSubscriber()) then
        return true
    end

    if not IsValidFilterType(filterType) then
        return false
    end

    if (filterType == "always loot") then
        return true
    end
    if (filterType == "only gold ingredients" and (quality == 5)) then
        return true
    end
    if (filterType == "never loot") then
        return false
    end
    return false
end

local function ShouldLootEnchanting(filterType, link)
    if (IsESOPlusSubscriber()) then
        return true
    end

    if (filterType == "always loot") then
        return true
    end
    local itemId = GetItemLinkItemId(link)

    if (filterType == "never loot") then
        return false
    end
    return false
end

local function ShouldLootScribing(filterType, itemType)
    if (IsESOPlusSubscriber() and itemType == ITEMTYPE_SCRIBING_INK) then
        return true
    end
    if (filterType == "always loot") then
        return true
    end

    if (filterType == "never loot") then
        return false
    end
    return false
end

local function ShouldLootTrait(filterType, link)
    if (IsESOPlusSubscriber()) then
        return true
    end

    if (filterType == "always loot") then
        return true
    end
    local itemId = GetItemLinkItemId(link)
    if (filterType == "only nirnhoned" and (itemId == 56863 or itemId == 56862)) then
        return true
    end
    if (filterType == "never loot") then
        return false
    end
    return false
end

local function ShouldLootPotion(filterType, link)
    if not IsValidFilterType(filterType) then
        return false
    end

    if (filterType == "always loot") then
        return true
    end
    local itemId = GetItemLinkItemId(link)
    if (filterType == "only bastian" and (itemId == 176040 or itemId == 176041 or itemId == 176042)) then
        return true
    end
    if (filterType == "only non-bastian" and itemId ~= 176040 and itemId ~= 176041 and itemId ~= 176042) then
        return true
    end
    if (filterType == "never loot") then
        return false
    end
    return false
end

local function ShouldLootThirdPartyWorthyItem(filterType, link)
    if filterType == "per ttc" then
        local itemInfo = TamrielTradeCentre_ItemInfo:New(link)
        local priceInfo = TamrielTradeCentrePrice:GetPriceInfo(itemInfo)
        if priceInfo and priceInfo.SaleAvg then
            if priceInfo.SaleAvg >= db.filters.thirdPartyMinValue then
                return true
            end
        end
        if (priceInfo == nil or priceInfo.SaleAvg == nil) and db.filters.lootThirdPartyNoPrice then
            return true
        end
        return false
    end

    if filterType == "per mm" then
        local itemStats = MasterMerchant:itemStats(link)
        if itemStats and itemStats.avgPrice then
            if itemStats.avgPrice >= db.filters.thirdPartyMinValue then
                return true
            end
        end
        if (itemStats == nil or itemStats.avgPrice == nil) and db.filters.lootThirdPartyNoPrice then
            return true
        end
        return false
    end

    if filterType == "per att" then
        local days = GetTimeStamp() - (24 * 60 * 60 * 3)
        local avgPrice = ArkadiusTradeTools.Modules.Sales:GetAveragePricePerItem(link, days)
        if avgPrice then
            if avgPrice >= db.filters.thirdPartyMinValue then
                return true
            end
        end
        if (avgPrice == nil) and db.filters.lootThirdPartyNoPrice then
            return true
        end
        return false
    end
end

local function ShouldLootMisc(filterType, link)
    if not IsValidFilterType(filterType) then
        return false
    end

    if (filterType == "always loot") then
        return true
    end
    if (filterType == "never loot") then
        return false
    end

    if (filterType == "per ttc" or filterType == "per mm" or filterType == "per att") then
        return ShouldLootThirdPartyWorthyItem(filterType, link)
    end

    return false
end

local function ShouldLootIntricate(filterType, link, quality, value, isJewelry)
    if not IsValidFilterType(filterType) then
        return false
    end

    if (filterType == "always loot") then
        -- gearLooted = true
        return true
    end
    if (filterType == "never loot") then
        return false
    end
    if (filterType == "type based") then
        local itemType = GetItemLinkItemType(link)

        -- if jewelry
        if (isJewelry) then
            return ShouldLootGear(db.filters.jewelryIntricate, quality, value)
        end
        if (not isJewelry and itemType == ITEMTYPE_ARMOR) then
            local weight = GetItemLinkArmorType(link)
            -- if clothing
            if (weight == ARMORTYPE_LIGHT or weight == ARMORTYPE_MEDIUM) then
                return ShouldLootGear(db.filters.clothingIntricate, quality, value)
            end
            -- if blacksmithing
            if (weight == ARMORTYPE_HEAVY) then
                return ShouldLootGear(db.filters.blacksmithingIntricate, quality, value)
            end
        end
        if (not isJewelry and itemType == ITEMTYPE_WEAPON) then
            local weaponType = GetItemLinkWeaponType(link)
            -- if woodworking
            if (weaponType == WEAPONTYPE_BOW or weaponType == WEAPONTYPE_FIRE_STAFF or weaponType ==
                WEAPONTYPE_FROST_STAFF or weaponType == WEAPONTYPE_LIGHTNING_STAFF or weaponType ==
                WEAPONTYPE_HEALING_STAFF or weaponType == WEAPONTYPE_SHIELD) then
                return ShouldLootGear(db.filters.woodworkingIntricate, quality, value)
            end
            -- if blacksmithing
            if (weaponType == WEAPONTYPE_AXE or weaponType == WEAPONTYPE_DAGGER or weaponType == WEAPONTYPE_HAMMER or
                weaponType == WEAPONTYPE_SWORD or weaponType == WEAPONTYPE_TWO_HANDED_AXE or weaponType ==
                WEAPONTYPE_TWO_HANDED_HAMMER or weaponType == WEAPONTYPE_TWO_HANDED_SWORD) then
                return ShouldLootGear(db.filters.blacksmithingIntricate, quality, value)
            end
        end
    end
    return false
end

local function ShouldLootFoodAndDrink(filterType, link)
    if not IsValidFilterType(filterType) then
        return false
    end

    if (filterType == "always loot") then
        return true
    end
    local itemId = GetItemLinkItemId(link)
    if (filterType == "only exp booster" and (itemId == 64221 or itemId == 120076 or itemId == 115027)) then
        return true
    end
    if (filterType == "never loot") then
        return false
    end
    return false
end

local function ShouldLootMaterial(filterType)
    if (IsESOPlusSubscriber()) then
        return true
    end

    if not IsValidFilterType(filterType) then
        return false
    end

    if (filterType == "always loot") then
        return true
    end
    if (filterType == "never loot") then
        return false
    end

    return false
end

local function ShouldLootStyleMaterial(filterType, link)
    if (IsESOPlusSubscriber()) then
        return true
    end

    if not IsValidFilterType(filterType) then
        return false
    end

    if (filterType == "always loot") then
        return true
    end
    if (filterType == "never loot") then
        return false
    end

    if (filterType == "only non-racial") then
        local itemType = GetItemLinkItemType(link)

        if (itemType == ITEMTYPE_RAW_MATERIAL) then
            return true
        else
            local styleId = GetItemLinkItemStyle(link)
            if ((styleId >= 1 and styleId <= 35) or styleId == GetImperialStyleId()) and styleId ~= 10 then
                return false
            else
                return true
            end
        end
    end

    return false
end

local function ShouldLootGem(filterType, value)
    if not IsValidFilterType(filterType) then
        return false
    end

    if (filterType == "always loot") then
        return true
    end
    if (filterType == "never loot") then
        return false
    end

    if (filterType == "only filled" and value > 5) then
        return true
    end

    return false
end

local function ShouldLootRecipe(filterType, link)
    if not IsValidFilterType(filterType) then
        return false
    end

    if (filterType == "always loot") then
        return true
    end
    if (filterType == "never loot") then
        return false
    end

    -- if the recipe is not tradeable then loot it directly
    local tradeable = GetItemLinkBindType(link) == BIND_TYPE_NONE or GetItemLinkBindType(link) == BIND_TYPE_ON_EQUIP or GetItemLinkBindType(link) == BIND_TYPE_UNSET
    if not tradeable then
        return true
    end

    local tempResult = false
    local itemType = GetItemLinkItemType(link)
    if (db.filters.alwaysLootUnknown and ((itemType == ITEMTYPE_RECIPE and not IsItemLinkRecipeKnown(link)) or (itemType == ITEMTYPE_RACIAL_STYLE_MOTIF and not IsItemLinkBookKnown(link)))) then
        if (db.filters.onlyLootAccountwideUnknown) then
            tempResult = tempResult or IsItemKnownByAnyCharacter(link, _, _)
        else
            return true
        end
        
    end

    if (filterType == "per ttc" or filterType == "per mm" or filterType == "per att") then
        tempResult = tempResult or ShouldLootThirdPartyWorthyItem(filterType, link)
    end

    return tempResult
end

local function ShouldLootTreasureMap(filterType, link)
    if not IsValidFilterType(filterType) then
        return false
    end

    if (filterType == "always loot") then
        return true
    end
    if (filterType == "only non-base-zone") then
        if ArrayHasItem(basezoneTreasureMapID, GetItemLinkItemId(link)) then
            return false
        else
            return true
        end
    end
    if (filterType == "never loot") then
        return false
    end

    if (filterType == "per ttc" or filterType == "per mm" or filterType == "per att") then
        return ShouldLootThirdPartyWorthyItem(filterType, link)
    end

    return false
end

local function ExceedWarning(curt)
    local firstExceed = 0
    if lastExceed == nil or lastExceed == 0 then
        lastExceed = GetGameTimeMilliseconds()
        firstExceed = 1
    end

    if GetGameTimeMilliseconds() - lastExceed > 20000 or firstExceed == 1 then
        d(zo_strformat(GetString(MSAL_EXCEED_WARNING), GetCurrencyName(curt, false, false)))
        lastExceed = GetGameTimeMilliseconds()
    end
    return
end

-- function MuchSmarterAutoLoot:OnLootUpdatedAF()
--     local randomItemSentence = {
--         SI_ARMORYBUILDOPERATIONTYPE_DIALOGMESSAGE2, -- Equipping <<1>> ...
--         SI_QUEST_REWARD_MAX_CURRENCY_ERROR, -- You cannot carry any more <<1>>
--         SI_LOOTITEMRESULT8, -- You are unable to loot the Unique <<1>> because you already have one.
--         SI_TRADEACTIONRESULT45, -- You are unable to trade for <<1>> because it is unique and you already have one
--         SI_INTERACT_OPTION_KEEP_GUILD_CLAIM, -- Claim ownership of <<1>>
--         SI_MARKET_PURCHASE_ALREADY_HAVE_GIFT_TEXT, -- You have <<1>> in your Gift Inventory. Claim it for yourself before purchasing it again.
--         SI_ANTIQUITY_LEAD_ACQUIRED_TEXT, -- <<1>> is now available to Scry.
--         -- SI_COMPANIONSUMMONRESULT8, -- <<1>> is not responding to your summon. Try again later when they're less angry with you.
--         -- SI_COMPANIONSUMMONRESULT6, -- <<1>> tried to join you but forgot to bring their gear.
--         -- SI_PLAYER_TO_PLAYER_INCOMING_RITUAL_OF_MARA, -- <<1>> wants to join with you in the Ritual of Mara
--     }

--     local randomItem = {
--         "|H0:item:62283:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Fusozay Cushion
--         "|H0:item:62140:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Khajiit Windowsill Sun Reflector
--         "|H0:item:198163:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Scrap of Skooma-Inspired Poetry
--         "|H0:item:62240:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Sheet Music Folio
--         "|H0:item:71369:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Stainless Dueling Jock
--         "|H0:item:150535:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Sweetwater Mouthwash
--         "|H0:item:61213:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Book of Erotic Stories
--         "|H0:item:187968:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- "Erotica for Werewolves"
--         "|H0:item:61211:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Guide to Approved Methods of Procreation
--         "|H0:item:150486:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Khajiiti Gravity Verification Gadget
--         "|H0:item:138857:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- "Barbas" Dog Collar
--         "|H0:item:138940:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Visual Guide to Skooma
--         "|H0:item:63095:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Eyes of the Queen Disguise Kit
--         "|H0:item:183100:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Ogrim Nipple Caps
--         "|H0:item:198162:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Skooma Cat Medallion
--         "|H0:item:63009:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- "Amorous Giantess" Royal Ensemble
--         "|H0:item:61256:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Pamphlet of Erotic Engravings
--         "|H0:item:166501:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Conquest of the Falmer
--         "|H0:item:73820:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Pacrooti's Mole Asses
--         "|H1:item:62039:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Invitation: Drinks with the Neighbors
--         "|H1:item:126291:4:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h"
--     }

--     local random_number = math.random()
--     local currentTime = GetGameTimeMilliseconds()
--     if random_number < 0.2 and currentTime - lastFoolUpdated > 300 then
--         local randomSentenceIndex = math.random(1, #randomItemSentence)
--         local randomItemIndex = math.random(1, #randomItem)
--         d(zo_strformat(GetString(randomItemSentence[randomSentenceIndex]), randomItem[randomItemIndex]))
--         lastFoolUpdated = currentTime
--     end
-- end

local function trimString(str)
    local index = string.find(str, "%^")
    if index then
        local partBefore = string.sub(str, 1, index - 1)
        return partBefore
    else
        return str
    end
end

local function getStandardizeName(str)
    str = trimString(str)
    local result = string.gsub(str, "%s+", "")
    result = string.lower(result)
    return result
end

local function itemOnList(itemid, name, token)
    local list
    if token == TOKEN_BLIST then
        list = db.blacklist
    elseif token == TOKEN_WLIST then
        list = db.whitelist
    else
        d("MSAL Error: Invalid list token")
    end

    if #list == 0 then
        return false
    end
    name = string.lower(name)
    for i = 1, #list, 1 do
        local savedName = string.lower(GetItemLinkName(string.format(templateItemlink, list[i])))
        if list[i] == itemid or getStandardizeName(savedName) == getStandardizeName(name) then
            return true
        end
    end
    return false
end

local function OnInventoryUpdate(_, bagId, slotIndex, isNewItem, itemSoundCategory, updateReason,
    stackCountChange)
    local link = GetItemLink(bagId, slotIndex)
    local isCrafted = IsItemLinkCrafted(link)
    local isUncollected = not IsItemSetCollectionPieceUnlocked(GetItemLinkItemId(link))
    local isCompanionGear = GetItemLinkActorCategory(link) == GAMEPLAY_ACTOR_CATEGORY_COMPANION
    local itemid = GetItemLinkItemId(link)
    local name = GetItemLinkName(link)
    if (db.autoBind and isUncollected and not isCompanionGear and not isCrafted and not isRepetitiveGear and not itemOnList(itemid, name, TOKEN_BLIST)) then
        BindItem(bagId, slotIndex)
    end
end

local function OnLootUpdated()
    if (db.enabled == false) then
        return
    end

    if (db.debugMode) then
        d("[MSAL Debug Log]")
    end
    local num = GetNumLootItems()
    if num == 0 then
        isResourceNode = false
    else
        isResourceNode = true
    end

    local isShiftKeyDown = IsShiftKeyDown()

    -- wipe at loot beginning other than ending, to avoid server-end latency
    currentNotLootedNameList = {}
    unwantedLootIdList = {}
    unwantedNameList = {}
    setItemRegister = {}
    isRepetitiveGear = false

    -- if the loot start within 3 sec after lockpick successfully, then regard it's a locked chest loot
    if GetGameTimeMilliseconds() - lastUnlockTime < 3000 then
        isLockedChest = true
    else
        isLockedChest = false
    end

    local noCurtLeft = true
    local noBListItem = true

    local currencyInfo = LOOT_SHARED:GetLootCurrencyInformation()
    for curt, info in ipairs(currencyInfo) do
        if curt == CURT_MONEY then
            if (info.currencyAmount > 0 or info.stolenCurrencyAmount > 0) then
                if (db.filters.uncapped == true) then
                    isResourceNode = false
                    if db.printItems then
                        d(GetString(SI_ITEM_ACTION_LOOT_TAKE) .. " " .. GetCurrencyName(curt, false, true) .. ": " ..
                        info.currencyAmount)
                    end
                    LootMoney()
                else
                    noCurtLeft = false
                end
            end
        end
    end

    for _, curt in ipairs(curtType) do
        local lootCurt = GetLootCurrency(curt)

        if curt == CURT_CHAOTIC_CREATIA then
            local currencyAmount = GetCurrencyAmount(CURT_CHAOTIC_CREATIA, CURRENCY_LOCATION_ACCOUNT)
            local maxCurrency = GetMaxPossibleCurrency(CURT_CHAOTIC_CREATIA, CURRENCY_LOCATION_ACCOUNT)
            if (lootCurt > 0) then
                if (db.filters.crystals == "always loot") then
                    if (currencyAmount + lootCurt <= maxCurrency) then
                        if ( db.printItems) then
                            d(GetString(SI_ITEM_ACTION_LOOT_TAKE) .. " " .. GetCurrencyName(curt, false, true) ..
                                ": " .. lootCurt)
                        end
                        LootCurrency(curt)
                    else
                        ExceedWarning(curt)
                        noCurtLeft = false
                    end
                else
                    noCurtLeft = false
                end
            end
        else
            if (lootCurt > 0) then
                if (db.filters.uncapped == true) then
                    isResourceNode = false
                    if db.printItems then
                        d(GetString(SI_ITEM_ACTION_LOOT_TAKE) .. " " .. GetCurrencyName(curt, false, true) .. ": " ..
                        lootCurt)
                    end
                    LootCurrency(curt)
                else
                    noCurtLeft = false
                end
            end
        end
    end

    -- d("Loot items number : "..num)
    for i = 1, num, 1 do
        local lootId, name, icon, quantity, quality, value, isQuest, isStolen, lootType = GetLootItemInfo(i)
        local link = GetLootItemLink(lootId)
        local trait = GetItemLinkTraitInfo(link)
        local itemType = GetItemLinkItemType(link)
        local isCompanionGear = GetItemLinkActorCategory(link) == GAMEPLAY_ACTOR_CATEGORY_COMPANION
        local isGear = itemType == ITEMTYPE_WEAPON or itemType == ITEMTYPE_ARMOR
        local isSetItem = IsItemLinkSetCollectionPiece(link)
        local isUnresearched = isGear and CanItemLinkBeTraitResearched(link)
        local isUncollected = not IsItemSetCollectionPieceUnlocked(GetItemLinkItemId(link))
        local isOrnate = trait == ITEM_TRAIT_TYPE_ARMOR_ORNATE or trait == ITEM_TRAIT_TYPE_WEAPON_ORNATE or trait ==
                             ITEM_TRAIT_TYPE_JEWELRY_ORNATE
        local isIntricate = trait == ITEM_TRAIT_TYPE_ARMOR_INTRICATE or trait == ITEM_TRAIT_TYPE_WEAPON_INTRICATE or
                                trait == ITEM_TRAIT_TYPE_JEWELRY_INTRICATE
        local isWeapon = itemType == ITEMTYPE_WEAPON
        local isJewelry = jewelryTraits[trait] and itemType == ITEMTYPE_ARMOR
        local isMat = matItemType[itemType] or false
        local isNodeMat = nodeMatItemType[itemType] or false
        local _, targetType, _, _ = GetLootTargetInfo()
        isResourceNode = isResourceNode and isNodeMat and targetType ~= INTERACT_TARGET_TYPE_ITEM

        local looted = false
        if (db.debugMode) then
            
            -- d("targetType: "..targetType)
            -- d("lootId: "..lootId)
            -- d("link: " .. link)
            d("name: "..name)
            d("itemType: " .. itemType)
            -- d("lootType: " .. lootType)
            -- d("filterType"..filterType)
            -- d("itemId: " .. GetItemLinkItemId(link))
            -- d(GetItemLinkActorCategory(link))
            -- d(GetItemLinkActorCategory(link) == GAMEPLAY_ACTOR_CATEGORY_COMPANION)
            -- d("have function: ")
            -- d(tostring(IsItemSetCollectionPieceUnlocked))
            -- Seems this function returns to opposite result of locked/unlocked
            -- true when owned, false when new
            -- d("is set item: "..tostring(isSetItem))
            -- d("is collected: "..tostring(alreadyCollectedItem))
            -- d("isGear : "..tostring(isGear))
            -- d("isUnresearched : "..tostring(isUnresearched))
            -- d("isJewelry : " .. tostring(isJewelry))
            -- d("alreadyCollectedRecipe : "..tostring(IsItemLinkRecipeKnown(link)))
        end

        -- If this one is stolen AND looting stolen is not allowed, don't continue and do nothing. 
        if not isShiftKeyDown and (isStolen and (db.stolenRule == "never loot")) then
        -- do nothing
        elseif itemOnList(GetItemLinkItemId(link), name, TOKEN_BLIST) or itemOnList(GetItemLinkItemId(link), name, TOKEN_WLIST) then
            if itemOnList(GetItemLinkItemId(link), name, TOKEN_BLIST) then
                noBListItem = false
            end
            if itemOnList(GetItemLinkItemId(link), name, TOKEN_WLIST) then
                LootItemById(lootId)
                looted = true
            end
        -- Unfortunately Lua doesn't support a continue or switch statement, so this logic is MUCH UGLIER than it should be. Lua sucks.
        -- One day I'll replace it with a more elegant implementation, but not today
        else
            if (isQuest or itemType == ITEMTYPE_NONE) then
                -- d("Looting quest item")
                if (ShouldLootMisc(db.filters.questItems, link)) then
                    LootItemById(lootId)
                    looted = true
                end
            end
            if (isGear) then
                if (isCompanionGear) then
                    if (ShouldLootGear(db.filters.companionGears, quality, value)) then
                        LootItemById(lootId)
                        looted = true
                    end
                end
                if (isSetItem) then
                    isRepetitiveGear = ArrayHasItem(setItemRegister, name)
                    table.insert(setItemRegister, name)

                    if (ShouldLootSet(db.filters.set, isUncollected, isJewelry, isWeapon)) then
                        LootItemById(lootId)
                        looted = true
                    end
                    if not isUncollected then
                        if (isUnresearched) then
                            if (ShouldLootGear(db.filters.unresearched, quality, value)) then
                                LootItemById(lootId)
                                looted = true
                            end
                        end
                        if (isOrnate) then
                            if (ShouldLootGear(db.filters.ornate, quality, value)) then
                                LootItemById(lootId)
                                looted = true
                            end
                        end
                        if (isIntricate) then
                            if (ShouldLootIntricate(db.filters.intricate, link, quality, value, isJewelry)) then
                                LootItemById(lootId)
                                looted = true
                            end
                        end
                        if (isJewelry) then
                            if (ShouldLootGear(db.filters.jewelry, quality, value)) then
                                LootItemById(lootId)
                                looted = true
                            end
                        end
                        if (itemType == ITEMTYPE_ARMOR and not isJewelry) then
                            if (ShouldLootGear(db.filters.armors, quality, value)) then
                                LootItemById(lootId)
                                looted = true
                            end
                        end
                        if (itemType == ITEMTYPE_WEAPON) then
                            if (ShouldLootGear(db.filters.weapons, quality, value)) then
                                LootItemById(lootId)
                                looted = true
                            end
                        end
                    end
                else
                    if (isUnresearched) then
                        if (ShouldLootGear(db.filters.unresearched, quality, value)) then
                            LootItemById(lootId)
                            looted = true
                        end
                    end
                    if (isOrnate) then
                        if (ShouldLootGear(db.filters.ornate, quality, value)) then
                            LootItemById(lootId)
                            looted = true
                        end
                    end
                    if (isIntricate) then
                        if (ShouldLootIntricate(db.filters.intricate, link, quality, value, isJewelry)) then
                            LootItemById(lootId)
                            looted = true
                        end
                    end
                    if (isJewelry) then
                        if (ShouldLootGear(db.filters.jewelry, quality, value)) then
                            LootItemById(lootId)
                            looted = true
                        end
                    end
                    if (itemType == ITEMTYPE_ARMOR and not isJewelry) then
                        if (ShouldLootGear(db.filters.armors, quality, value)) then
                            LootItemById(lootId)
                            looted = true
                        end
                    end
                    if (itemType == ITEMTYPE_WEAPON) then
                        if (ShouldLootGear(db.filters.weapons, quality, value)) then
                            LootItemById(lootId)
                            looted = true
                        end
                    end
                    -- if (not gearLooted and value >= db.minimumValue) then
                    --     LootItemById(lootId)
                    --     looted = true
                    -- end
                    -- if (not gearLooted and quality >= db.minimumQuality) then
                    --     LootItemById(lootId)
                    --     looted = true
                    -- end
                end
            elseif (itemType == ITEMTYPE_BLACKSMITHING_BOOSTER or itemType == ITEMTYPE_BLACKSMITHING_MATERIAL or
                itemType == ITEMTYPE_BLACKSMITHING_RAW_MATERIAL) then
                if (ShouldLootMaterial(db.filters.craftingMaterials)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_CLOTHIER_BOOSTER or itemType == ITEMTYPE_CLOTHIER_MATERIAL or itemType ==
                ITEMTYPE_CLOTHIER_RAW_MATERIAL) then
                if (ShouldLootMaterial(db.filters.craftingMaterials)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_WOODWORKING_BOOSTER or itemType == ITEMTYPE_WOODWORKING_MATERIAL or itemType ==
                ITEMTYPE_WOODWORKING_RAW_MATERIAL) then
                if (ShouldLootMaterial(db.filters.craftingMaterials)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_JEWELRYCRAFTING_BOOSTER or itemType == ITEMTYPE_JEWELRYCRAFTING_MATERIAL or
                itemType == ITEMTYPE_JEWELRYCRAFTING_RAW_BOOSTER or itemType == ITEMTYPE_JEWELRYCRAFTING_RAW_MATERIAL) then
                if (ShouldLootMaterial(db.filters.craftingMaterials)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_RAW_MATERIAL or itemType == ITEMTYPE_STYLE_MATERIAL) then
                if (ShouldLootStyleMaterial(db.filters.styleMaterials, link)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_WEAPON_TRAIT or itemType == ITEMTYPE_ARMOR_TRAIT or itemType ==
                ITEMTYPE_JEWELRY_RAW_TRAIT or itemType == ITEMTYPE_JEWELRY_TRAIT) then
                if (ShouldLootTrait(db.filters.traitMaterials, link)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_INGREDIENT) then
                if (ShouldLootIngredient(db.filters.ingredients, quality)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_POTION_BASE or itemType == ITEMTYPE_POISON_BASE or itemType == ITEMTYPE_REAGENT) then
                if (ShouldLootMaterial(db.filters.alchemy)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_ENCHANTING_RUNE_ASPECT or itemType == ITEMTYPE_ENCHANTING_RUNE_ESSENCE or
                itemType == ITEMTYPE_ENCHANTING_RUNE_POTENCY or itemType == ITEMTYPE_ENCHANTMENT_BOOSTER) then
                if (ShouldLootEnchanting(db.filters.runes, link)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_FURNISHING_MATERIAL) then
                -- 114889 Regulus (Blacksmithing)
                -- 114890 Bast (Clothier, cloth)
                -- 114891 Clean Pelt (Clothier, leather)
                -- 114892 Mundane Rune (Enchanting)
                -- 114893 Alchemical Resin (Alchemy)
                -- 114894 Decorative Wax (Provisioning)
                -- 114895 Heartwood (Woodworking)
                if (ShouldLootMaterial(db.filters.furnishingMaterials)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_GLYPH_ARMOR or itemType == ITEMTYPE_GLYPH_JEWELRY or itemType ==
                ITEMTYPE_GLYPH_WEAPON) then
                if (ShouldLootMisc(db.filters.glyphs, link)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_CONTAINER or itemType == ITEMTYPE_CONTAINER_CURRENCY or itemType ==
                ITEMTYPE_FISH) then
                if (ShouldLootMisc(db.filters.containers, link)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_FURNISHING) then
                if (ShouldLootRecipe(db.filters.furniture, link)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_CROWN_ITEM or itemType == ITEMTYPE_CROWN_REPAIR) then
                if (ShouldLootMisc(db.filters.crownItems, link)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_MASTER_WRIT) then
                if (ShouldLootMisc(db.filters.writs, link)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_CRAFTED_ABILITY or itemType == ITEMTYPE_CRAFTED_ABILITY_SCRIPT or itemType == ITEMTYPE_SCRIBING_INK) then
                if (ShouldLootScribing(db.filters.scribing, itemType)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_RACIAL_STYLE_MOTIF or itemType == ITEMTYPE_RECIPE or itemType == ITEMTYPE_COLLECTIBLE) then
                if (ShouldLootRecipe(db.filters.recipes, link)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_SOUL_GEM) then
                if (ShouldLootGem(db.filters.soulGems, value)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (lootType == LOOT_TYPE_ANTIQUITY_LEAD) then
                if (ShouldLootMisc(db.filters.leads, link)) then
                    local antiquityId = GetLootAntiquityLeadId(lootId)
                    LootItemById(lootId)
                    looted = true
                    if (GetNumAntiquitiesRecovered(antiquityId) == 0) then
                        d(GetString(SI_ITEM_ACTION_LOOT_TAKE) .. " " .. name .. " (" ..
                              GetString(SI_GAMEPAD_GUILD_LIST_NEW_HEADER) .. ")")
                    end
                end
            elseif (itemType == ITEMTYPE_AVA_REPAIR or itemType == ITEMTYPE_SIEGE) then
                if (ShouldLootMisc(db.filters.allianceWarConsumables, link)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_LOCKPICK) then
                if (ShouldLootMisc(db.filters.lockpicks, link)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_TOOL) then
                if (ShouldLootMisc(db.filters.tools, link)) then
                    LootItemById(lootId)
                    looted = true
                end
            -- elseif (lootType == LOOT_TYPE_COLLECTIBLE) then
            --     if (ShouldLootMisc(db.filters.collectibles, link)) then
            --         LootItemById(lootId)
            --         looted = true
            --     end
            elseif (itemType == ITEMTYPE_TROPHY) then
                if (ShouldLootTreasureMap(db.filters.treasureMaps, link)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_FOOD or itemType == ITEMTYPE_DRINK) then
                if (ShouldLootFoodAndDrink(db.filters.foodAndDrink, link)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_POTION) then
                if (ShouldLootPotion(db.filters.potions, link)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_POISON) then
                if (ShouldLootMisc(db.filters.poisons, link)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_TREASURE) then
                if (ShouldLootGear(db.filters.treasures, quality, value)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_COSTUME or itemType == ITEMTYPE_DISGUISE) then
                if (ShouldLootMisc(db.filters.costumes, link)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_LURE) then
                if (ShouldLootMaterial(db.filters.fishingBaits)) then
                    LootItemById(lootId)
                    looted = true
                end
            elseif (itemType == ITEMTYPE_TRASH) then
                if (ShouldLootMisc(db.filters.trash, link)) then
                    LootItemById(lootId)
                    looted = true
                end
            else
                -- d("ItemType: Unknown Item")
                -- d("ItemType: "..tostring(itemType))
            end
        end

        if db.greedyMode and IsItemLinkStackable(link) and not looted then
            local inventoryCount, _, _ = GetItemLinkStacks(link)
            if inventoryCount > 0 then
                for bagSlot = 1, GetBagSize(BAG_BACKPACK) do
                    local itemLink = GetItemLink(BAG_BACKPACK, bagSlot)
                    if itemLink == link then
                        local _, maxStack = GetSlotStackSize(BAG_BACKPACK, bagSlot)
                        if math.ceil((inventoryCount + quantity) / maxStack) - math.ceil(inventoryCount / maxStack) == 0 then
                            LootItemById(lootId)
                            looted = true
                            StackBag(BAG_BACKPACK)
                        end
                        break
                    end
                end
            end
        end

        if (db.printItems and looted) then 
            if (not db.printItemThreshold or (db.printItemThreshold and quality >= 4)) then   
                if (isUnresearched) then
                    d(GetString(SI_ITEM_ACTION_LOOT_TAKE) .. " " .. link .. " (" .. GetString(SI_ITEMTRAITINFORMATION3) .. ")")
                elseif (isOrnate) then
                    d(GetString(SI_ITEM_ACTION_LOOT_TAKE) .. " " .. link .. " (" .. GetString(SI_ITEMTRAITTYPE10) .. ")")
                elseif (isIntricate) then
                    d(GetString(SI_ITEM_ACTION_LOOT_TAKE) .. " " .. link .. " (" .. GetString(SI_ITEMTRAITTYPE9) .. ")")
                elseif (isSetItem and isUncollected) then
                    d(GetString(SI_ITEM_ACTION_LOOT_TAKE) .. " " .. link .. " (" ..
                        GetString(SI_ITEM_FORMAT_STR_SET_COLLECTION_PIECE_LOCKED) .. ")")
                else
                    d(GetString(SI_ITEM_ACTION_LOOT_TAKE) .. " " .. link)
                end
            end
        end
        
        if (looted == false and not itemOnList(GetItemLinkItemId(link), name, TOKEN_BLIST)) then
            table.insert(currentNotLootedNameList, string.lower(name))
            table.insert(unwantedLootIdList, lootId)
            table.insert(unwantedNameList, string.lower(name))
        end

        -- gearLooted = false
    end

    local isPsijicPortal = false
    local targetName, _, _, _ =  GetLootTargetInfo()
    if portalName[GetCVar("language.2")] == targetName then
        isPsijicPortal = true
    end

    if (db.debugMode) then
        d("isLockedChest: " .. tostring(isLockedChest))
        d("isResourceNode: " .. tostring(isResourceNode))
        d("isPsijicPortal: " .. tostring(isPsijicPortal))
        d("currentNotLootedNameList length: " .. tostring(#currentNotLootedNameList))
        -- d("unwantedLootIdList: " .. tostring(#unwantedLootIdList))
        -- d("length of id list: " .. #unwantedLootIdList)
        -- for i = 1, #unwantedLootIdList, 1 do
        --     d("unwantedLootIdList" .. i .. ": " .. unwantedLootIdList[i])
        -- end
        -- d("length of name list: " .. #unwantedNameList)
        -- for i = 1, #unwantedNameList, 1 do
        --     d("unwantedNameList" .. i .. ": " .. unwantedNameList[i])
        -- end
    end

    -- Performed after looting has been completed for the wanted items
    local considerateLoot = false
    local currentScene = SCENE_MANAGER:GetCurrentScene().name
    if (db.debugMode) then
        d("currentScene :"..currentScene)
        d("noCurtLeft :"..tostring(noCurtLeft))
    end

    if db.considerateMode and ((isLockedChest or isResourceNode or isPsijicPortal) and #unwantedLootIdList > 0 and tostring(currentScene) ~= "lootInventoryGamepad" and tostring(currentScene) ~= "inventory") then
        if (db.debugMode) then
            d("is considerateLoot")
        end
        considerateLoot = true
        EVENT_MANAGER:RegisterForEvent("MSAL_UNWANTED_UPDATE", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, OnUnwantedUpdated)
        EVENT_MANAGER:AddFilterForEvent("MSAL_UNWANTED_UPDATE", EVENT_INVENTORY_SINGLE_SLOT_UPDATE,
            REGISTER_FILTER_IS_NEW_ITEM, true)
        EVENT_MANAGER:AddFilterForEvent("MSAL_UNWANTED_UPDATE", EVENT_INVENTORY_SINGLE_SLOT_UPDATE,
            REGISTER_FILTER_BAG_ID, BAG_BACKPACK)
        zo_callLater(function() EVENT_MANAGER:RegisterForEvent("MSAL_UNWANTED_LOOT_CLOSED", EVENT_LOOT_CLOSED, OnUnwantedLootClosed) end, GetLatency())

        if not noCurtLeft then
            LootMoney()
            for _, curt in ipairs(curtType) do
                LootCurrency(curt)         
            end
            noCurtLeft = true
        end

        for i = 1, #unwantedLootIdList, 1 do
            LootItemById(unwantedLootIdList[i])
        end

        -- Force close the chest looting window to avoid picking up the blacklisted item
        if isLockedChest and not noBListItem then
            EndLooting()
            SCENE_MANAGER:HideCurrentScene()
            d(string.format(GetString(MSAL_LIST_CONSIDERATE_CONFLICT), 
                GetString(MSAL_CONSIDERATE_MODE)))
        end
    end

    if (db.closeLootWindow and not considerateLoot) then
        if (db.debugMode) then
            if (IsSameArray(currentNotLootedNameList, lastNotLootedNameList) and #currentNotLootedNameList ~= 0 ) then
                d("is Succession loot")
            end
        end

        -- If Smarter Close is disabled or enabled but it is not a succession loot ------ then it need to be closed unless its a bag container
        if not db.closeLootWindowSmarter or (db.closeLootWindowSmarter and not (IsSameArray(currentNotLootedNameList, lastNotLootedNameList))) and noBListItem then
            -- if the case is bag container
            if (IsInGamepadPreferredMode() and tostring(currentScene) == "lootInventoryGamepad") or (not IsInGamepadPreferredMode() and tostring(currentScene) == "inventory") then
                lootingBagContainer = true
                if (db.debugMode) then
                    d("isBagContainer")
                end
                if #currentNotLootedNameList == 0 and noCurtLeft then -- if it is a bag container and everything is looted then close it, otherwise do nothing
                    if (db.debugMode) then
                        d("closing bag container loot window")
                    end
                    
                    EndLooting()
                    SCENE_MANAGER:Show(currentScene)
                    lootingBagContainer = false
                end
            else
                if not lootingBagContainer and noCurtLeft then
                    if (db.debugMode) then
                        d("closing loot window")
                    end
                    EndLooting()
                    SCENE_MANAGER:HideCurrentScene()
                    -- SCENE_MANAGER:ShowBaseScene()
                end
            end
        end
        lastNotLootedNameList = currentNotLootedNameList
    end

    if #currentNotLootedNameList == 0 and noCurtLeft and noBListItem then
        if (db.debugMode) then
            d("secured closing loot window, showing: "..currentScene)
        end
        if not IsInGamepadPreferredMode() then
            EndLooting()
            SCENE_MANAGER:Show(currentScene)
        -- else
        --     EndLooting()
        --     SCENE_MANAGER:HideCurrentScene()
        end

    end
end

local function OnLootUpdatedThrottled()
    -- EVENT_MANAGER:UnregisterForEvent("MSAL_LOOT_UPDATED", EVENT_LOOT_UPDATED)
    local currentTime = GetGameTimeMilliseconds()
    if currentTime - lastUpdated > 300 then
        OnLootUpdated()
        lastUpdated = currentTime
    end
end

local LAM2 = LibAddonMenu2

local function SettingInitialize(db)
    local panelData = {
        type = "panel",
        name = GetString(MSAL_PANEL_NAME),
        displayName = GetString(MSAL_PANEL_DISPLAYNAME),
        author = "|c215895Lykeion|r",
        version = "|ccc922f" .. addonVersion .. "|r",
        slashCommand = "/msal",
        registerForRefresh = true,
        registerForDefaults = true
    }
    local defaultChoices = {
        GetString(MSAL_ALWAYS_LOOT),
        GetString(MSAL_NEVER_LOOT),
        GetString(MSAL_PER_QUALITY_THRESHOLD),
        GetString(MSAL_PER_VALUE_THRESHOLD)
    }
    local defaultChoicesValues = {
        "always loot",
        "never loot",
        "per quality threshold",
        "per value threshold"
    }

    local valueChoices = {
        GetString(MSAL_ALWAYS_LOOT),
        GetString(MSAL_PER_VALUE_THRESHOLD),
        GetString(MSAL_NEVER_LOOT)
    }
    local valueChoicesValues = {
        "always loot",
        "per value threshold",
        "never loot"
    }

    local qualityChoices = {
        GetString(MSAL_ALWAYS_LOOT),
        GetString(MSAL_PER_QUALITY_THRESHOLD),
        GetString(MSAL_NEVER_LOOT)
    }
    local qualityChoicesValues = {
        "always loot",
        "per quality threshold",
        "never loot"
    }

    local booleanChoices = {
        GetString(MSAL_ALWAYS_LOOT),
        GetString(MSAL_NEVER_LOOT)
    }
    local booleanChoicesValues = {
        "always loot",
        "never loot"
    }

    local stolenChoices = {
        GetString(MSAL_NEVER_LOOT),
        -- GetString(MSAL_FOLLOW_WITHOUT_MATS),
        GetString(MSAL_FOLLOW)
    }
    local stolenChoicesValues = {
        "never loot",
        -- "follow without mats",
        "follow"
    }

    local setChoices = {
        GetString(MSAL_ALWAYS_LOOT),
        GetString(MSAL_ONLY_UNCOLLECTED),
        GetString(MSAL_WEAPON_AND_JEWELRY),
        GetString(MSAL_UNCOLLECTED_AND_JEWELRY),
        GetString(MSAL_UNCOLLECTED_AND_NON_JEWELRY),
        GetString(MSAL_ONLY_COLLECTED),
        GetString(MSAL_NEVER_LOOT)
    }
    local setChoicesValues = {
        "always loot",
        "only uncollected",
        "weapon and jewelry",
        "uncollected and jewelry",
        "uncollected and non-jewelry",
        "only collected",
        "never loot"
    }

    local intricateChoices = {
        GetString(MSAL_ALWAYS_LOOT),
        GetString(MSAL_TYPE_BASED),
        GetString(MSAL_NEVER_LOOT)
    }
    local intricateChoicesValues = {
        "always loot",
        "type based",
        "never loot"
    }

    local treasureMapsChoices = {
        GetString(MSAL_ALWAYS_LOOT),
        GetString(MSAL_ONLY_NON_BASE_ZONE),
        GetString(MSAL_NEVER_LOOT)
    }
    local treasureMapsChoicesValues = {
        "always loot",
        "only non-base-zone",
        "never loot"
    }

    local styleMaterialsChoices = {
        GetString(MSAL_ALWAYS_LOOT),
        GetString(MSAL_ONLY_NON_RACIAL),
        GetString(MSAL_NEVER_LOOT)
    }
    local styleMaterialsChoicesValues = {
        "always loot",
        "only non-racial",
        "never loot"
    }

    local traitMaterialsChoices = {
        GetString(MSAL_ALWAYS_LOOT),
        GetString(MSAL_ONLY_NIRNHONED),
        GetString(MSAL_NEVER_LOOT)
    }
    local traitMaterialsChoicesValues = {
        "always loot",
        "only nirnhoned",
        "never loot"
    }

    local soulGemsChoices = {
        GetString(MSAL_ALWAYS_LOOT),
        GetString(MSAL_ONLY_FILLED),
        GetString(MSAL_NEVER_LOOT)
    }
    local soulGemsChoicesValues = {
        "always loot",
        "only filled",
        "never loot"
    }

    local foodChoices = {
        GetString(MSAL_ALWAYS_LOOT),
        GetString(MSAL_ONLY_EXP_BOOSTER),
        GetString(MSAL_NEVER_LOOT)
    }
    local foodChoicesValues = {
        "always loot",
        "only exp booster",
        "never loot"
    }

    local ingredientChoices = {
        GetString(MSAL_ALWAYS_LOOT),
        GetString(MSAL_ONLY_GOLD_INGREDIENTS),
        GetString(MSAL_NEVER_LOOT)
    }
    local ingredientChoicesValues = {
        "always loot",
        "only gold ingredients",
        "never loot"
    }

    local enchantingChoices = {
        GetString(MSAL_ALWAYS_LOOT),
        GetString(MSAL_ONLY_KUTA_HAKEIJO),
        GetString(MSAL_NEVER_LOOT)
    }
    local enchantingChoicesValues = {
        "always loot",
        "only kuta hakeijo",
        "never loot"
    }

    local potionsChoices = {
        GetString(MSAL_ALWAYS_LOOT),
        GetString(MSAL_ONLY_BASTIAN),
        GetString(MSAL_ONLY_NON_BASTIAN),
        GetString(MSAL_NEVER_LOOT)
    }
    local potionsChoicesValues = {
        "always loot",
        "only bastian",
        "only non-bastian",
        "never loot"
    }

    local recipesChoices = {
        GetString(MSAL_ALWAYS_LOOT),
        -- GetString(MSAL_ONLY_UNKNOWN),
        GetString(MSAL_NEVER_LOOT)
    }
    local recipesChoicesValues = {
        "always loot",
        -- "only unknown",
        "never loot"
    }

    local dynamicRecipesChoices, dynamicRecipesChoicesValues =
        AddDynamicThirdPartyPriceSupport(recipesChoices, recipesChoicesValues)
    local dynamicTreasureMapsChoices, dynamicTreasureMapsChoicesValues =
        AddDynamicThirdPartyPriceSupport(treasureMapsChoices, treasureMapsChoicesValues)
    local dynamicBooleanChoices, dynamicBooleanChoicesValues =
        AddDynamicThirdPartyPriceSupport(booleanChoices, booleanChoicesValues)


    local function getListChoices(token)
        local list, title
        if token == TOKEN_BLIST then
            list = db.blacklist
            title = GetString(MSAL_BLIST)
        elseif token == TOKEN_WLIST then
            list = db.whitelist
            title = GetString(MSAL_WLIST)
        end

        local temp = {}
        table.insert(temp, "-------- " .. title .. " --------")
        for _, itemid in pairs(list) do
            table.insert(temp,
                trimString(GetItemLinkName(string.format(templateItemlink, itemid)) .. " (" .. itemid .. ")"))
        end
        return temp
    end

    local function addListItem(link, token)
        if link == nil or link == "" then
            return
        end

        local controlName, removeControlName, listName, list, otherList
        if token == TOKEN_BLIST then
            controlName = "MSAL_AddBList"
            removeControlName = "MSAL_RemoveBList"
            listName = GetString(MSAL_BLIST)
            list = db.blacklist
            otherList = db.whitelist
        elseif token == TOKEN_WLIST then
            controlName = "MSAL_AddWList"
            removeControlName = "MSAL_RemoveWList"
            listName = GetString(MSAL_WLIST)
            list = db.whitelist
            otherList = db.blacklist
        end

        if GetItemLinkItemId(link) == 0 then
            d(GetString(SI_STOREITEMRESULT1))
            WM:GetControlByName(controlName).editbox:SetText("")
            return
        end

        for _, v in pairs(otherList) do
            if v == GetItemLinkItemId(link) then
                d(string.format(GetString(MSAL_LIST_CONFLICT),
                    trimString(GetItemLinkName(string.format(templateItemlink, GetItemLinkItemId(link))))))
                WM:GetControlByName(controlName).editbox:SetText("")
                return
            end
        end

        for _, v in pairs(list) do
            if v == GetItemLinkItemId(link) then
                d(string.format(GetString(MSAL_LIST_ALREADY_EXIST),
                    trimString(GetItemLinkName(string.format(templateItemlink, GetItemLinkItemId(link)))),
                    listName))
                WM:GetControlByName(controlName).editbox:SetText("")
                return
            end
        end
        table.insert(list, GetItemLinkItemId(link))
        d(string.format(GetString(MSAL_LIST_ADD),
            trimString(GetItemLinkName(string.format(templateItemlink, GetItemLinkItemId(link)))), listName))

        WM:GetControlByName(controlName).editbox:SetText("")
        WM:GetControlByName(removeControlName):UpdateChoices(getListChoices(token))
    end

    local function removeListItem(itemStr, token)
        local controlName, removeControlName, listName, list, otherList
        if token == TOKEN_BLIST then
            removeControlName = "MSAL_RemoveBList"
            listName = GetString(MSAL_BLIST)
            list = db.blacklist
        elseif token == TOKEN_WLIST then
            removeControlName = "MSAL_RemoveWList"
            listName = GetString(MSAL_WLIST)
            list = db.whitelist
        end

        if itemStr == nil or itemStr == "-------- " .. listName .. " --------" then
            WM:GetControlByName(removeControlName).dropdown:SetSelectedItem(nil)
            return
        else
            local startIndex, endIndex = string.find(itemStr, "%(%d+%)$")
            local itemid = string.sub(itemStr, startIndex + 1, endIndex - 1)

            for i = #list, 1, -1 do
                if tostring(list[i]) == itemid then
                    d(string.format(GetString(MSAL_LIST_REMOVE),
                        trimString(GetItemLinkName(string.format(templateItemlink, list[i]))),
                        listName))
                    table.remove(list, i)
                end
            end
        end

        WM:GetControlByName(removeControlName).dropdown:SetSelectedItem(nil)
        WM:GetControlByName(removeControlName):UpdateChoices(getListChoices(token))
    end

    local optionsData = {
        {
            type = "description",
            text = GetString(MSAL_HELP_TITLE),
            width = "full"
        },
        {
            type = "checkbox",
            name = GetString(MSAL_ENABLE_MSAL),
            tooltip = GetString(MSAL_ENABLE_MSAL_TOOLTIP),
            keybind = "UI_SHORTCUT_PRIMARY",
            getFunc = function()
                return db.enabled
            end,
            setFunc = function(value)
                db.enabled = value
                if (value) then
                    SetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_AUTO_LOOT, 0)
                    SetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_AOE_LOOT, 1)
                    SetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_AUTO_ADD_TO_CRAFT_BAG, 1)
                    EVENT_MANAGER:RegisterForEvent("MSAL_LOOT_UPDATED", EVENT_LOOT_UPDATED, OnLootUpdatedThrottled)
                else
                    EVENT_MANAGER:UnregisterForEvent("MSAL_LOOT_UPDATED", EVENT_LOOT_UPDATED)
                end
            end,
            default = true
        },
        {
            type = "submenu",
            name = GetString(MSAL_GENERAL_SETTINGS),
            controls = {
                {
                    type = "checkbox",
                    name = GetString(MSAL_LOGIN_REMINDER),
                    tooltip = GetString(MSAL_LOGIN_REMINDER_TOOLTIP),
                    getFunc = function()
                        return db.loginReminder
                    end,
                    setFunc = function(value)
                        db.loginReminder = value
                    end,
                    default = true
                },
                {
                    type = "checkbox",
                    name = GetString(MSAL_SHOW_ITEM_LINKS),
                    tooltip = GetString(MSAL_SHOW_ITEM_LINKS_TOOLTIP),
                    getFunc = function()
                        return db.printItems
                    end,
                    setFunc = function(value)
                        db.printItems = value
                    end,
                    default = false
                },
                {
                    type = "checkbox",
                    name = GetString(MSAL_SHOW_ITEM_LINKS_THRESHOLD),
                    tooltip = GetString(MSAL_SHOW_ITEM_LINKS_THRESHOLD_TOOLTIP),
                    getFunc = function()
                        return db.printItemThreshold
                    end,
                    setFunc = function(value)
                        db.printItemThreshold = value
                    end,
                    default = true,
                    disabled = function()
                        return db.printItems == false
                    end
                },
                {
                    type = "checkbox",
                    name = GetString(MSAL_CLOSE_LOOT_WINDOW),
                    tooltip = GetString(MSAL_CLOSE_LOOT_WINDOW_TOOLTIP),
                    getFunc = function()
                        return db.closeLootWindow
                    end,
                    setFunc = function(value)
                        db.closeLootWindow = value
                    end,
                    default = false
                },
                {
                    type = "checkbox",
                    name = GetString(MSAL_SMARTER_CLOSE_LOOT_WINDOW),
                    tooltip = GetString(MSAL_SMARTER_CLOSE_LOOT_WINDOW_TOOLTIP),
                    getFunc = function()
                        return db.closeLootWindowSmarter
                    end,
                    setFunc = function(value)
                        db.closeLootWindowSmarter = value
                    end,
                    default = true,
                    disabled = function()
                        return db.closeLootWindow == false
                    end
                },
                {
                    type = "dropdown",
                    name = GetString(MSAL_STOLEN_ITEMS_RULE),
                    tooltip = GetString(MSAL_STOLEN_ITEMS_RULE_TOOLTIP),
                    choices = stolenChoices,
                    choicesValues = stolenChoicesValues,
                    getFunc = function()
                        return db.stolenRule
                    end,
                    setFunc = function(value)
                        db.stolenRule = value
                    end,
                    default = "never loot"
                },
                {
                    type = "divider",
                    height = 1,
                    alpha = 0.5,
                    width = "half"
                },
                {
                    type = "checkbox",
                    name = GetString(MSAL_GREEDY_MODE),
                    tooltip = GetString(MSAL_GREEDY_MODE_TOOLTIP),
                    getFunc = function()
                        return db.greedyMode
                    end,
                    setFunc = function(value)
                        db.greedyMode = value
                    end,
                    default = false
                },
                {
                    type = "checkbox",
                    name = GetString(MSAL_CONSIDERATE_MODE),
                    tooltip = GetString(MSAL_CONSIDERATE_MODE_TOOLTIP),
                    getFunc = function()
                        return db.considerateMode
                    end,
                    setFunc = function(value)
                        db.considerateMode = value
                    end,
                    default = false
                },
                {
                    type = "checkbox",
                    name = GetString(MSAL_CONSIDERATE_MODE_PRINT),
                    getFunc = function()
                        return db.considerateModePrint
                    end,
                    setFunc = function(value)
                        db.considerateModePrint = value
                    end,
                    default = false,
                    disabled = function()
                        return db.considerateMode == false
                    end
                },
                {
                    type = "divider",
                    height = 1,
                    alpha = 0.5,
                    width = "half"
                },
                {
                    type = "checkbox",
                    name = GetString(MSAL_DEBUG),
                    tooltip = GetString(MSAL_DEBUG_TOOLTIP),
                    getFunc = function()
                        return db.debugMode
                    end,
                    setFunc = function(value)
                        db.debugMode = value
                    end,
                    default = false
                }
            }
        },
        {
            type = "submenu",
            name = GetString(MSAL_GEAR_FILTERS),
            controls = {
                {
                    type = "description",
                    text = GetString(MSAL_HELP_GEAR),
                    width = "full"
                },
                {
                    type = "slider",
                    name = GetString(MSAL_QUALITY_THRESHOLD),
                    tooltip = GetString(MSAL_QUALITY_THRESHOLD_TOOLTIP),
                    min = 1,
                    max = 5,
                    step = 1,
                    getFunc = function()
                        return db.minimumQuality
                    end,
                    setFunc = function(value)
                        db.minimumQuality = value
                    end,
                    default = 1
                },
                {
                    type = "slider",
                    name = GetString(MSAL_VALUE_THRESHOLD),
                    tooltip = GetString(MSAL_VALUE_THRESHOLD_TOOLTIP),
                    min = 0,
                    max = 300,
                    getFunc = function()
                        return db.minimumValue
                    end,
                    setFunc = function(value)
                        db.minimumValue = value
                    end,
                    default = 0
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEM_FORMAT_STR_COMPANION),
                    choices = qualityChoices,
                    choicesValues = qualityChoicesValues,
                    getFunc = function()
                        return db.filters.companionGears
                    end,
                    setFunc = function(value)
                        db.filters.companionGears = value
                    end,
                    default = "always loot"
                },
                {
                    type = "divider",
                    height = 1,
                    alpha = 0.5,
                    width = "half"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEM_SETS_BOOK_TITLE),
                    choices = setChoices,
                    choicesValues = setChoicesValues,
                    getFunc = function()
                        return db.filters.set
                    end,
                    setFunc = function(value)
                        db.filters.set = value
                    end,
                    default = "always loot"
                },
                {
                    type = "checkbox",
                    name = GetString(MSAL_AUTOBIND),
                    tooltip = GetString(MSAL_AUTOBIND_TOOLTIP),
                    getFunc = function()
                        return db.autoBind
                    end,
                    setFunc = function(value)
                        db.autoBind = value
                    end,
                    default = false
                },
                {
                    type = "divider",
                    height = 1,
                    alpha = 0.5,
                    width = "half"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_SMITHING_RESEARCH_RESEARCHABLE),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.unresearched
                    end,
                    setFunc = function(value)
                        db.filters.unresearched = value
                    end,
                    default = "always loot"
                },
                {
                    type = "dropdown",
                    name = GetString(MSAL_ORNATE_ITEMS),
                    choices = valueChoices,
                    choicesValues = valueChoicesValues,
                    getFunc = function()
                        return db.filters.ornate
                    end,
                    setFunc = function(value)
                        db.filters.ornate = value
                    end,
                    default = "always loot"
                },
                {
                    type = "dropdown",
                    name = GetString(MSAL_INTRICATE_ITEMS),
                    choices = intricateChoices,
                    choicesValues = intricateChoicesValues,
                    getFunc = function()
                        return db.filters.intricate
                    end,
                    setFunc = function(value)
                        db.filters.intricate = value
                    end,
                    default = "always loot"
                },
                {
                    type = "dropdown",
                    name = GetString(MSAL_CLOTHING_INTRICATE_ITEMS),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.clothingIntricate
                    end,
                    setFunc = function(value)
                        db.filters.clothingIntricate = value
                    end,
                    default = "always loot",
                    disabled = function()
                        return not (db.filters.intricate == "type based")
                    end
                },
                {
                    type = "dropdown",
                    name = GetString(MSAL_BLACKSMITHING_INTRICATE_ITEMS),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.blacksmithingIntricate
                    end,
                    setFunc = function(value)
                        db.filters.blacksmithingIntricate = value
                    end,
                    default = "always loot",
                    disabled = function()
                        return not (db.filters.intricate == "type based")
                    end
                },
                {
                    type = "dropdown",
                    name = GetString(MSAL_WOODWORKING_INTRICATE_ITEMS),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.woodworkingIntricate
                    end,
                    setFunc = function(value)
                        db.filters.woodworkingIntricate = value
                    end,
                    default = "always loot",
                    disabled = function()
                        return not (db.filters.intricate == "type based")
                    end
                },
                {
                    type = "dropdown",
                    name = GetString(MSAL_JEWELRY_INTRICATE_ITEMS),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.jewelryIntricate
                    end,
                    setFunc = function(value)
                        db.filters.jewelryIntricate = value
                    end,
                    default = "always loot",
                    disabled = function()
                        return not (db.filters.intricate == "type based")
                    end
                },
                {
                    type = "divider",
                    height = 1,
                    alpha = 0.5,
                    width = "half"
                },
                {
                    type = "dropdown",
                    name = GetString(MSAL_WEAPONS),
                    choices = defaultChoices,
                    choicesValues = defaultChoicesValues,
                    getFunc = function()
                        return db.filters.weapons
                    end,
                    setFunc = function(value)
                        db.filters.weapons = value
                    end,
                    default = "never loot"
                },
                {
                    type = "dropdown",
                    name = GetString(MSAL_ARMORS),
                    choices = defaultChoices,
                    choicesValues = defaultChoicesValues,
                    getFunc = function()
                        return db.filters.armors
                    end,
                    setFunc = function(value)
                        db.filters.armors = value
                    end,
                    default = "never loot"
                },
                {
                    type = "dropdown",
                    name = GetString(MSAL_JEWELRY),
                    choices = defaultChoices,
                    choicesValues = defaultChoicesValues,
                    getFunc = function()
                        return db.filters.jewelry
                    end,
                    setFunc = function(value)
                        db.filters.jewelry = value
                    end,
                    default = "never loot"
                }
            }
        },
        {
            type = "submenu",
            name = GetString(MSAL_MATERIAL_FILTERS),
            controls = {
                {
                    type = "description",
                    text = GetString(MSAL_HELP_MATERIAL),
                    width = "full"
                },
                {
                    type = "dropdown",
                    name = GetString(MSAL_CRAFTING_MATERIALS),
                    tooltip = GetString(MSAL_CRAFTING_MATERIALS_TOOLTIP),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.craftingMaterials
                    end,
                    setFunc = function(value)
                        db.filters.craftingMaterials = value
                    end,
                    default = "never loot"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEMTYPE44),
                    choices = styleMaterialsChoices,
                    choicesValues = styleMaterialsChoicesValues,
                    getFunc = function()
                        return db.filters.styleMaterials
                    end,
                    setFunc = function(value)
                        db.filters.styleMaterials = value
                    end,
                    default = "never loot"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_GAMEPADITEMCATEGORY30),
                    choices = traitMaterialsChoices,
                    choicesValues = traitMaterialsChoicesValues,
                    getFunc = function()
                        return db.filters.traitMaterials
                    end,
                    setFunc = function(value)
                        db.filters.traitMaterials = value
                    end,
                    default = "never loot"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEMTYPEDISPLAYCATEGORY14),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.alchemy
                    end,
                    setFunc = function(value)
                        db.filters.alchemy = value
                    end,
                    default = "never loot"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEMTYPEDISPLAYCATEGORY16),
                    choices = ingredientChoices,
                    choicesValues = ingredientChoicesValues,
                    getFunc = function()
                        return db.filters.ingredients
                    end,
                    setFunc = function(value)
                        db.filters.ingredients = value
                    end,
                    default = "only gold ingredients"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEMTYPEDISPLAYCATEGORY15),
                    choices = enchantingChoices,
                    choicesValues = enchantingChoicesValues,
                    getFunc = function()
                        return db.filters.runes
                    end,
                    setFunc = function(value)
                        db.filters.runes = value
                    end,
                    default = "only kuta hakeijo"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEMTYPE62),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.furnishingMaterials
                    end,
                    setFunc = function(value)
                        db.filters.furnishingMaterials = value
                    end,
                    default = "never loot"
                }
            }
        },
        {
            type = "submenu",
            name = GetString(MSAL_CURRENCY_FILTERS),
            controls = {
                {
                    type = "description",
                    text = GetString(MSAL_HELP_CURRENCY),
                    width = "full"
                },
                {
                    type = "checkbox",
                    name = GetString(MSAL_UNCAPPED_CURRENCY),
                    getFunc = function()
                        return db.filters.uncapped
                    end,
                    setFunc = function(value)
                        db.filters.uncapped = value
                    end,
                    default = true
                },
                {
                    type = "dropdown",
                    name = GetCurrencyName(CURT_CHAOTIC_CREATIA, false, false),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.crystals
                    end,
                    setFunc = function(value)
                        db.filters.crystals = value
                    end,
                    default = "always loot"
                }
            }
        },
        {
            type = "submenu",
            name = GetString(MSAL_MISC_FILTERS),
            controls = {
                {
                    type = "description",
                    text = GetString(MSAL_HELP_MISC),
                    width = "full"
                },
                {
                    type = "checkbox",
                    name = GetString(MSAL_LOOT_UNKNOWN_ITEM),
                    tooltip = GetString(MSAL_LOOT_UNKNOWN_ITEM_TOOLTIP),
                    getFunc = function()
                        return db.filters.alwaysLootUnknown
                    end,
                    setFunc = function(value)
                        db.filters.alwaysLootUnknown = value
                    end,
                    default = true
                },
                {
                    type = "checkbox",
                    name = GetString(MSAL_ONLY_ACCOUNTWIDE_UNKNOWN),
                    tooltip = GetString(MSAL_ONLY_ACCOUNTWIDE_UNKNOWN_TOOLTIP),
                    getFunc = function()
                        return db.filters.onlyLootAccountwideUnknown
                    end,
                    setFunc = function(value)
                        db.filters.onlyLootAccountwideUnknown = value
                    end,
                    default = false,
                    disabled = function()
                        return not LibCharacterKnowledge or not db.filters.alwaysLootUnknown
                    end
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEM_FORMAT_STR_COLLECTIBLE),
                    tooltip = GetString(SI_ITEMTYPEDISPLAYCATEGORY24) .. " & " ..
                        GetString(SI_ITEMTYPEDISPLAYCATEGORY21) .. " & " ..
                        GetString(SI_PROVISIONERSPECIALINGREDIENTTYPE_TRADINGHOUSERECIPECATEGORY3),
                    choices = dynamicRecipesChoices,
                    choicesValues = dynamicRecipesChoicesValues,
                    getFunc = function()
                        return db.filters.recipes
                    end,
                    setFunc = function(value)
                        db.filters.recipes = value
                    end,
                    default = "never loot"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_SPECIALIZEDITEMTYPE100),
                    tooltip = GetString(SI_SPECIALIZEDITEMTYPE100) .. " & " .. GetString(SI_SPECIALIZEDITEMTYPE101) ..
                        " & " .. GetString(SI_COLLECTIBLECATEGORYTYPE26),
                    choices = dynamicTreasureMapsChoices,
                    choicesValues = dynamicTreasureMapsChoicesValues,
                    getFunc = function()
                        return db.filters.treasureMaps
                    end,
                    setFunc = function(value)
                        db.filters.treasureMaps = value
                    end,
                    default = "only non-base-zone"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEMTYPE61),
                    choices = dynamicBooleanChoices,
                    choicesValues = dynamicBooleanChoicesValues,
                    getFunc = function()
                        return db.filters.furniture
                    end,
                    setFunc = function(value)
                        db.filters.furniture = value
                    end,
                    default = "never loot"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEM_FORMAT_STR_QUEST_ITEM),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.questItems
                    end,
                    setFunc = function(value)
                        db.filters.questItems = value
                    end,
                    default = "always loot"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEMTYPE57),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.crownItems
                    end,
                    setFunc = function(value)
                        db.filters.crownItems = value
                    end,
                    default = "always loot"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_NOTIFICATIONTYPE20),
                    tooltip = GetString(SI_ITEMTYPE72) .. " & " .. GetString(SI_ITEMTYPE73) .. " & " ..
                        GetString(SI_ITEMTYPE74),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.scribing
                    end,
                    setFunc = function(value)
                        db.filters.scribing = value
                    end,
                    default = "always loot"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_SPECIALIZEDITEMTYPE900),
                    choices = soulGemsChoices,
                    choicesValues = soulGemsChoicesValues,
                    getFunc = function()
                        return db.filters.soulGems
                    end,
                    setFunc = function(value)
                        db.filters.soulGems = value
                    end,
                    default = "only filled"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_GAMEPAD_VENDOR_ANTIQUITY_LEAD_GROUP_HEADER),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.leads
                    end,
                    setFunc = function(value)
                        db.filters.leads = value
                    end,
                    default = "always loot"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEMTYPEDISPLAYCATEGORY30),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.glyphs
                    end,
                    setFunc = function(value)
                        db.filters.glyphs = value
                    end,
                    default = "never loot"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEMTYPE4) .. " & " .. GetString(SI_ITEMTYPE12),
                    choices = foodChoices,
                    choicesValues = foodChoicesValues,
                    getFunc = function()
                        return db.filters.foodAndDrink
                    end,
                    setFunc = function(value)
                        db.filters.foodAndDrink = value
                    end,
                    default = "only exp booster"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEMTYPEDISPLAYCATEGORY23),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.poisons
                    end,
                    setFunc = function(value)
                        db.filters.poisons = value
                    end,
                    default = "never loot"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEMTYPEDISPLAYCATEGORY22),
                    choices = potionsChoices,
                    choicesValues = potionsChoicesValues,
                    getFunc = function()
                        return db.filters.potions
                    end,
                    setFunc = function(value)
                        db.filters.potions = value
                    end,
                    default = "never loot"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEMTYPE18),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.containers
                    end,
                    setFunc = function(value)
                        db.filters.containers = value
                    end,
                    default = "always loot"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEMTYPE60),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.writs
                    end,
                    setFunc = function(value)
                        db.filters.writs = value
                    end,
                    default = "never loot"
                },
                -- {
                --     type = "dropdown",
                --     -- name = GetString(SI_ITEMFILTERTYPE12),
                --     name = GetString(SI_MAIN_MENU_COLLECTIONS),
                --     choices = booleanChoices,
                --     choicesValues = booleanChoicesValues,
                --     getFunc = function()
                --         return db.filters.collectibles
                --     end,
                --     setFunc = function(value)
                --         db.filters.collectibles = value
                --     end,
                --     default = "never loot"
                -- },
                {
                    type = "dropdown",
                    name = GetString(SI_SPECIALIZEDITEMTYPE2550),
                    choices = defaultChoices,
                    choicesValues = defaultChoicesValues,
                    getFunc = function()
                        return db.filters.treasures
                    end,
                    setFunc = function(value)
                        db.filters.treasures = value
                    end,
                    default = "never loot"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEMTYPE6) .. " & " .. GetString(SI_ITEMTYPE47),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.allianceWarConsumables
                    end,
                    setFunc = function(value)
                        db.filters.allianceWarConsumables = value
                    end,
                    default = "never loot"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEMTYPE22),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.lockpicks
                    end,
                    setFunc = function(value)
                        db.filters.lockpicks = value
                    end,
                    default = "never loot"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEMTYPE9),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.tools
                    end,
                    setFunc = function(value)
                        db.filters.tools = value
                    end,
                    default = "never loot"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_SPECIALIZEDITEMTYPE600) .. " & " .. GetString(SI_SPECIALIZEDITEMTYPE650),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.costumes
                    end,
                    setFunc = function(value)
                        db.filters.costumes = value
                    end,
                    default = "never loot"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEMTYPEDISPLAYCATEGORY35),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.fishingBaits
                    end,
                    setFunc = function(value)
                        db.filters.fishingBaits = value
                    end,
                    default = "never loot"
                },
                {
                    type = "dropdown",
                    name = GetString(SI_ITEMTYPE48),
                    choices = booleanChoices,
                    choicesValues = booleanChoicesValues,
                    getFunc = function()
                        return db.filters.trash
                    end,
                    setFunc = function(value)
                        db.filters.trash = value
                    end,
                    default = "never loot"
                }
            }
        },
        {
            type = "submenu",
            name = GetString(MSAL_BLIST) .. " / " .. GetString(MSAL_WLIST),
            -- MAIN_MENU_KEYBOARD:ShowScene("itemSetsBook")
            controls = {
                {
                    type = "description",
                    text = string.format(GetString(MSAL_HELP_LIST), GetString(MSAL_BLIST), GetString(MSAL_WLIST),
                        GetItemLinkName("|H0:item:127531:362:50:0:0:0:0:0:0:0:0:0:0:0:2048:62:0:0:0:0:0|h|h"), -- Nirn Dagger
                        GetString(MSAL_BLIST), GetItemLinkName(
                            "|H1:item:45854:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"), -- kuta
                        GetString(SI_ITEMTYPE52), -- rune
                        GetString(MSAL_WLIST)),
                    width = "full"
                },
                {
                    type = "header",
                    name = GetString(MSAL_BLIST),
                    width = "full"
                },
                {
                    type = "editbox",
                    name = string.format(GetString(MSAL_ADD_ITEM), GetString(MSAL_BLIST)),
                    default = "",
                    reference = "MSAL_AddBList",
                    getFunc = function()
                        return
                    end,
                    setFunc = function(value)
                        addListItem(value, TOKEN_BLIST)
                    end
                },
                {
                    type = "dropdown",
                    name = string.format(GetString(MSAL_REMOVE_ITEM), GetString(MSAL_BLIST)),
                    choices = getListChoices(TOKEN_BLIST),
                    reference = "MSAL_RemoveBList",
                    getFunc = function()
                        return
                    end,
                    setFunc = function(value)
                        removeListItem(value, TOKEN_BLIST)
                    end
                },
                {
                    type = "header",
                    name = GetString(MSAL_WLIST),
                    width = "full"
                },
                {
                    type = "editbox",
                    name = string.format(GetString(MSAL_ADD_ITEM), GetString(MSAL_WLIST)),
                    default = "",
                    reference = "MSAL_AddWList",
                    getFunc = function()
                        return
                    end,
                    setFunc = function(value)
                        addListItem(value, TOKEN_WLIST)
                    end
                },
                {
                    type = "dropdown",
                    name = string.format(GetString(MSAL_REMOVE_ITEM), GetString(MSAL_WLIST)),
                    choices = getListChoices(TOKEN_WLIST),
                    reference = "MSAL_RemoveWList",
                    getFunc = function()
                        return
                    end,
                    setFunc = function(value)
                        removeListItem(value, TOKEN_WLIST)
                    end
                }
            }
        }
    }

    -- Dynamically inserted functions based on optional dependencies
    local dynamicOptionIndex = 7
    if (LibSavedVars) then
        table.insert(optionsData, 3, db:GetLibAddonMenuAccountCheckbox())
        dynamicOptionIndex = dynamicOptionIndex + 1
    end

    if (MasterMerchant or TamrielTradeCentre or ArkadiusTradeTools) then
        optionsData[dynamicOptionIndex].controls[1].text = GetString(MSAL_HELP_MISC_TRIMED)

        local dynamicCheckboxNoPrice = {
            type = "checkbox",
            name = GetString(MSAL_LOOT_NO_PRICE_ITEM),
            tooltip = GetString(MSAL_LOOT_NO_PRICE_ITEM_TOOLTIP),
            getFunc = function()
                return db.filters.lootThirdPartyNoPrice
            end,
            setFunc = function(value)
                db.filters.lootThirdPartyNoPrice = value
            end,
            default = true
        }
        table.insert(optionsData[dynamicOptionIndex].controls, 2, dynamicCheckboxNoPrice)

        local dynamicSlider = {
            type = "slider",
            name = GetString(MSAL_THIRD_PARTY_AVG_THRESHOLD),
            tooltip = GetString(MSAL_THIRD_PARTY_AVG_THRESHOLD_TOOLTIP),
            min = 0,
            max = 100000,
            getFunc = function()
                return db.filters.thirdPartyMinValue
            end,
            setFunc = function(value)
                db.filters.thirdPartyMinValue = value
            end,
            default = 10000
        }
        table.insert(optionsData[dynamicOptionIndex].controls, 2, dynamicSlider)

        local divider = {
            type = "divider",
            height = 1,
            alpha = 0.5,
            width = "half"
        }
        table.insert(optionsData[dynamicOptionIndex].controls, 4, divider)

        local divider = {
            type = "divider",
            height = 1,
            alpha = 0.5,
            width = "half"
        }
        table.insert(optionsData[dynamicOptionIndex].controls, 10, divider)

    end

    settingPanel = LAM2:RegisterAddonPanel("MuchSmarterAutoLootOptions", panelData)
    LAM2:RegisterOptionControls("MuchSmarterAutoLootOptions", optionsData)
end


local function OnLoaded(_, addon)
    if addon ~= "MuchSmarterAutoLoot" then
        return
    end

    if LibSavedVars ~= nil then
        db = LibSavedVars:NewAccountWide(SV_NAME, "Account", defaults):AddCharacterSettingsToggle(SV_NAME, "Character")
    else
        db = ZO_SavedVars:New(SV_NAME, 1, nil, defaults)
    end
    SettingInitialize(db)

    SLASH_COMMANDS["/msalt"] = function(keyWord, argument)
        if db.enabled == false then
            SetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_AUTO_LOOT, 0)
            db.enabled = true
            EVENT_MANAGER:RegisterForEvent("MSAL_LOOT_UPDATED", EVENT_LOOT_UPDATED, OnLootUpdatedThrottled)
            d("Much Smarter AutoLoot |c68be3e" .. GetString(SI_SCREEN_NARRATION_TOGGLE_ON) .. "|r")
        else
            db.enabled = false
            EVENT_MANAGER:UnregisterForEvent("MSAL_LOOT_UPDATED", EVENT_LOOT_UPDATED)
            d("Much Smarter AutoLoot |cd06756" .. GetString(SI_SCREEN_NARRATION_TOGGLE_OFF) .. "|r")
        end
    end

    if GetUnitDisplayName("player") == "@Lykeion" then
        SLASH_COMMANDS["/msaltest"] = function(keyWord, argument)
            if db.enabled == true then
                MuchSmarterAutoLoot:test()
            end
        end
    end

    local currentDate = os.date("*t")
    if currentDate.month == 4 and currentDate.day == 1 then
        -- EVENT_MANAGER:RegisterForEvent("MSAL_LOOT_UPDATED_FOOL", EVENT_LOOT_UPDATED, MuchSmarterAutoLoot.OnLootUpdatedFool)
        local bigTitle = {}
        local bigAchievement = {1838, 2075, 2139, 2467, 2746, 3003, 3249, 3564, 4019, 2368}
        for i = 1, #bigAchievement do
            local _, title = GetAchievementRewardTitle(bigAchievement[i])
            table.insert(bigTitle, title.."...?")
        end

        GetUnitTitle = function(unitTag)
            return bigTitle[math.random(1, #bigTitle)]
        end
    else
        if LibCustomTitles then
            LibCustomTitles:RegisterTitle("@Lykeion", false, true, {en="|c275a91P|r|c2e5d8di|r|c365f88p|r|c3d6284e|r|c446480r|r |c4b677ca|r|c526977t|r |c596b73t|r|c616e6fh|r|c68706be|r |c6f7366G|r|c767562a|r|c7d775et|r|c847a5ae|r|c8c7c55s|r |c937f51o|r|c9a814df|r |ca18449D|r|ca88644a|r|caf8840w|r|cb78b3cn|r |cbe8d38E|r|cc59033r|r|ccc922fa|r",})
        else
            local GetUnitTitle_original = GetUnitTitle
            GetUnitTitle = function(unitTag)
                if not (GetUnitDisplayName(unitTag) == "@Lykeion") then
                    return GetUnitTitle_original(unitTag)
                else
                    if GetUnitName(unitTag) == "This One Adores Inigo" then
                        if GetCVar("language.2") == "zh" then
                            return "|c9d1112鲜|r|c8b1011血|r|c790e0f铸|r|c670d0e就|r"
                        else
                            return "|cab1213A|r|ca61112g|r|ca21112e|r|c9d1112d|r |c991011T|r|c941011h|r|c901011r|r|c8b1011o|r|c870f10u|r|c820f10g|r|c7e0f10h|r |c790e0fB|r|c750e0fl|r|c700e0fo|r|c6c0d0eo|r|c670d0ed|r"
                        end
                    elseif GetUnitName(unitTag) == "This One Might Have Wares" then
                        if GetCVar("language.2") == "zh" then
                            return "|c365f88黎|r|c4b677c明|r|c616e6f纪|r|c767562元|r|c8c7c55的|r|ca18449风|r|cb78b3c笛|r|ccc922f手|r"
                        else
                            return "|c275a91P|r|c2e5d8di|r|c365f88p|r|c3d6284e|r|c446480r|r |c4b677ca|r|c526977t|r |c596b73t|r|c616e6fh|r|c68706be|r |c6f7366G|r|c767562a|r|c7d775et|r|c847a5ae|r|c8c7c55s|r |c937f51o|r|c9a814df|r |ca18449D|r|ca88644a|r|caf8840w|r|cb78b3cn|r |cbe8d38E|r|cc59033r|r|ccc922fa|r"
                        end
                    elseif GetUnitName(unitTag) == "This One Smuggles Skooma" then
                        if GetCVar("language.2") == "zh" then
                            return "|c694d91月|r|c5c4a8c亮|r|c4f4688糖|r|c424284之|r|c353f7f暗|r|c283b7b面|r"
                        else
                            return "|c725094D|r|c6f4f93a|r|c6b4e91r|r|c684d90k|r |c644c8fS|r|c614b8ei|r|c5d4a8dd|r|c5a498ce|r |c56488ao|r|c534789f|r |c4f4688t|r|c4b4587h|r|c484486e|r |c444384M|r|c414283o|r|c3d4182o|r|c3a4081n|r |c363f80S|r|c333e7fu|r|c2f3d7dg|r|c2c3c7ca|r|c283b7br|r"
                        end
                    elseif GetUnitName(unitTag) == "This One Bears With You" then
                        if GetCVar("language.2") == "zh" then
                            return "|cbed768生|r|cd4cb61吞|r|ce9be5b活|r|cffb254剥|r"
                        else
                            return "|cb1de6bE|r|cb9d969a|r|cc2d466t|r|ccbcf64e|r|cd4cb61n|r |cdcc65eA|r|ce5c15cl|r|ceebc59i|r|cf6b757v|r|cffb254e|r"
                        end
                    elseif GetUnitName(unitTag) == "This One Needs Moonsugar" then
                        if GetCVar("language.2") == "zh" then
                            return  "|cd4353e湮|r|cdf656b灭|r|ce99697大|r|cf4c6c4镖|r|cfff6f1客|r"
                        else
                            return "|ccc111cR|r|cce1d27e|r|cd12933d|r |cd4353eD|r|cd74149a|r|cd94d54e|r|cdc595fd|r|cdf656br|r|ce17176i|r|ce47e81c|r |ce78a8cR|r|ce99697e|r|ceca2a3d|r|cefaeaee|r|cf2bab9m|r|cf4c6c4p|r|cf7d2cft|r|cfadedbi|r|cfceae6o|r|cfff6f1n|r"
                        end
                    elseif GetUnitName(unitTag) == "This One Steals Nothing" then
                        if GetCVar("language.2") == "zh" then
                            return "|c7ee1ca晶|r|c5ec9b0体|r|c3db196管|r"
                        else
                            return "|c95f2dcT|r|c8bebd4r|r|c82e3cda|r|c78dcc5n|r|c6ed5bds|r|c64ceb5i|r|c5ac7ads|r|c51bfa6t|r|c47b89eo|r|c3db196r|r"
                        end
                    elseif GetUnitName(unitTag) == "This One Tells No Lie" then
                        if GetCVar("language.2") == "zh" then
                            return  "|cf4e1a3超|r|cf2d470新|r|cf1c83c星|r"
                        else
                            return "|cf5e9c6S|r|cf4e5b5u|r|cf4e1a3p|r|cf3dd92e|r|cf3d881r|r|cf2d470S|r|cf2d05et|r|cf1cc4da|r|cf1c83cr|r"
                        end
                    else
                        if GetCVar("language.2") == "zh" then
                            return "|c3c6646沥|r|c3c6258青|r|c3d5e69世|r|c3d5a7b界|r"
                        else
                            return "|c3b693aA|r|c3b6740s|r|c3c6646p|r|c3c654ch|r|c3c6352a|r|c3c6258l|r|c3c615dt|r |c3c5f63W|r|c3d5e69o|r|c3d5d6fr|r|c3d5b75l|r|c3d5a7bd|r"
                        end
                    end
                    
                end
            end
        end
    end
    -- if (db.allowDestroy) then
    -- 	self.buttonDestroyRemaining = CreateControlFromVirtual("buttonDestroyRemaining", ZO_Loot, "BTN_DestroyRemaining")
    -- end

    EVENT_MANAGER:RegisterForEvent("MSAL_LOOT_UPDATED", EVENT_LOOT_UPDATED, OnLootUpdatedThrottled)

end

local function LoadScreen()
    -- d("initPlusChecking : "..tostring(db.initPlusCheck))
    -- d("userBuildInAutoLoot"..userBuildInAutoLoot)
    if ((db.initPlusCheck == nil or db.initPlusCheck == false)) then
        db.initPlusCheck = true
        -- d("initPlusChecking...")
        local userBuildInAutoLoot = GetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_AUTO_LOOT)
        if (IsESOPlusSubscriber() and userBuildInAutoLoot == 1) then
            db.enabled = false
        end
    end

    -- d("auto modify build-in autoloot")
    if (db.enabled) then
        SetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_AUTO_LOOT, 0)
        SetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_AOE_LOOT, 1)
        SetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_AUTO_ADD_TO_CRAFT_BAG, 1)
        EVENT_MANAGER:RegisterForEvent("MSAL_LOOT_UPDATED", EVENT_LOOT_UPDATED, OnLootUpdatedThrottled)
    end

    if (not startupInfoPrinted and db.loginReminder == true and db.enabled == true) then
        d("|c215895 Lykeion's|cdb8e0b Much Smarter AutoLoot " .. addonVersion .. " " ..
              GetString(SI_GAMEPAD_MARKET_FREE_TRIAL_TILE_ACTIVE_TEXT) .. "|r")
        -- d("IsESOPlusSubscriber() : "..tostring(IsESOPlusSubscriber()))
        if (db.closeLootWindow) then
            d(GetString(MSAL_CLOSE_LOOT_WINDOW_REMINDER))
        end
        if (db.debugMode) then
            d(GetString(MSAL_DEBUG_MODE_REMINDER))
        end
        EVENT_MANAGER:UnregisterForEvent("MuchSmarterAutoLoot", EVENT_PLAYER_ACTIVATED)
    end

    ZO_Dialogs_RegisterCustomDialog("MSAL_MAJOR_UPDATE", {
        title = {
            text = GetString(MSAL_PANEL_DISPLAYNAME)
        },
        mainText = {
            text = string.format(GetString(MSAL_UPDATE_IMFORM), 
                        GetString(MSAL_BLIST),
                        GetString(MSAL_WLIST))
        },
        buttons = {{
            text = SI_URL_DIALOG_OPEN,
            callback = function()
                LibAddonMenu2:OpenToPanel(settingPanel)
            end
        }, {
            text = SI_DIALOG_CANCEL
        }}
    })

    -- Version update info
    if db.latestMajorUpdateVersion ~= "5.0.0" then
        db.latestMajorUpdateVersion = "5.0.0"
        -- if db.filters.runes == "only kuta hakeijo" then
        --     table.insert(db.whitelist, 45854)
        --     table.insert(db.whitelist, 68342)
        --     table.insert(db.whitelist, 166045)
        --     db.filters.runes = "never loot"
        -- end

        if ( db.filters.recipes == "only unknown") then
            db.filters.recipes = "never loot"
            db.filters.alwaysLootUnknown = true
        end

        if db.stolenRule == "follow without mats" then
            db.stolenRule = "follow"
        end

        EVENT_MANAGER:RegisterForUpdate( "MuchSmarterAutoLoot", 1000, function()
            if not ZO_Dialogs_IsShowingDialog() then
                ZO_Dialogs_ShowDialog("MSAL_MAJOR_UPDATE", {
                }, {
                    mainTextParams = {functionName}
                })
                EVENT_MANAGER:UnregisterForUpdate("MuchSmarterAutoLoot")
            end
        end )
    end
    
    startupInfoPrinted = true
end

-- Initialize
EVENT_MANAGER:RegisterForEvent("MuchSmarterAutoLoot", EVENT_ADD_ON_LOADED, OnLoaded)
EVENT_MANAGER:RegisterForEvent("MuchSmarterAutoLoot", EVENT_PLAYER_ACTIVATED, LoadScreen)
EVENT_MANAGER:RegisterForEvent("MSAL_SLOT_UPDATE", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, OnInventoryUpdate)
EVENT_MANAGER:AddFilterForEvent("MSAL_SLOT_UPDATE", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_IS_NEW_ITEM, true)
EVENT_MANAGER:AddFilterForEvent("MSAL_SLOT_UPDATE", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_BACKPACK)
EVENT_MANAGER:RegisterForEvent("MSAL_LOOT_CLOSED", EVENT_LOOT_CLOSED, OnLootClosed)
EVENT_MANAGER:RegisterForEvent("MSAL_LOCKPICK_SUCCESS", EVENT_LOCKPICK_SUCCESS, OnLockpickSuccess)



---------------------- My Toolbox ----------------------

-- print all Style Items
-- for i = 1, GetNumValidItemStyles() do
--	local styleItemIndex = GetValidItemStyleId(i)
--	local  itemName = GetItemStyleName(styleItemIndex)
--	local styleItem = GetSmithingStyleItemInfo(styleItemIndex)
--	d("styleItemIndex"..styleItemIndex)
--	d("itemName"..itemName)
--	d("styleItem"..styleItem)
-- end

-- print all Skills

-- 遍历并打印所有技能线及其ID
-- skillType 大分类的技能, 比如职业, 武器, 世界等
-- skillLineIndex 大分类下的各个技能线索引, 比如世界线下的狼人, 吸血鬼
-- skillLineID skillLineIndex的ID (仅用于名称查找, 不要与skillLineIndex的ID相混淆)
-- skillIndex 技能线中某个技能的索引
function MuchSmarterAutoLoot:ListAllSkillLineIDs()

    d("Start Listing")
    -- 遍历所有技能类型
    for skillType = 1, GetNumSkillTypes() do
        -- 获取技能线数量
        local numSkillLines = GetNumSkillLines(skillType)

        -- 要看哪个就先查skillLineIndex, 然后在Step 2中手动指定skillType和skillLineIndex
        -- local skillLineIndex = 11
        for skillLineIndex = 1, numSkillLines do
            -- 获取技能线信息
            local skillLineName, _, _, _, _, _, _, _ = GetSkillLineInfo(skillType, skillLineIndex)
            d(string.format("SkillType:%s SkillLine index:%s SkillLine name:%s", skillType, skillLineIndex,
                GetSkillLineNameById(GetSkillLineId(skillType, skillLineIndex))))
        end
    end
end

-- 选择并查看具体某个技能线中技能的ID
-- 要看哪个就先查skillLineIndex, 然后手动指定skillType和skillLineIndex
function MuchSmarterAutoLoot:ListSkillIDs()
    local skillType = 2
    local skillLineIndex = 1
    local numSkills = GetNumSkillAbilities(skillType, skillLineIndex)
    local abilityId, abilityName, CAbilityId

    for skillIndex = 1, numSkills do
        CAbilityId = nil
        if (IsCraftedAbilitySkill(skillType, skillLineIndex, skillIndex)) then
            CAbilityId = GetCraftedAbilitySkillCraftedAbilityId(skillType, skillLineIndex, skillIndex)
            abilityId = GetCraftedAbilityRepresentativeAbilityId(CAbilityId)
            abilityName = GetCraftedAbilityDisplayName(CAbilityId)
        else
            abilityId = GetSkillAbilityId(skillType, skillLineIndex, skillIndex)
            abilityName, _, _, _, _, _, _, _ = GetSkillAbilityInfo(skillType, skillLineIndex, skillIndex)
        end
        -- local skillMorph1Id, _ = GetSpecificSkillAbilityInfo(skillType,  skillLineIndex,  skillIndex,  1,  2)
        -- local skillMorph2Id, _ = GetSpecificSkillAbilityInfo(skillType,  skillLineIndex,  skillIndex,  2,  2)
        -- local skillLineName =  GetSkillLineNameById(skillLineIndex)
        -- GetSlotBoundId(3, HOTBAR_CATEGORY_PRIMARY)遇到篆刻技能时返回的是_craftedAbilityId_而不是_abilityId_. 可能他们都属于actionId?
        if (CAbilityId ~= nil) then
            d("Crafted Skill ID: " .. CAbilityId)
        end
        d(string.format("Skill ID: %d - %s", abilityId, abilityName))
        -- d(string.format("Skill Morph ID: %d - %d", skillMorph1Id, skillMorph2Id))
    end
end

-- _Returns:_ *string* _name_, *textureName* _texture_, *luaindex* _earnedRank_, *bool* _passive_, *bool* _ultimate_, *bool* _purchased_, *luaindex:nilable* _progressionIndex_, *integer* _rank_, *bool* _isCrafted_
function MuchSmarterAutoLoot:GetSkillAbilityInfoSafe(skillType, skillLineIndex, abilityIndex)
    if IsCraftedAbilitySkill(skillType, skillLineIndex, abilityIndex) then
        local craftedAbilityId = GetCraftedAbilitySkillCraftedAbilityId(skillType, skillLineIndex, abilityIndex)
        -- local name = GetCraftedAbilityDisplayName(craftedAbilityId)
        local abilityId = GetAbilityIdForCraftedAbilityId(craftedAbilityId)
        local abilityName = GetAbilityName(abilityId)
        local icon = GetAbilityIcon(abilityId)
        return abilityName, icon, 0, false, false, false, nil, 0, true
    else
        return GetSkillAbilityInfo(skillType, skillLineIndex, abilityIndex), false
    end
end

function MuchSmarterAutoLoot:ListAllCraftedSkillInfo()
    -- 遍历所有技能类型
    for skillType = 1, GetNumSkillTypes() do
        -- 获取技能线数量
        for skillLineIndex = 1, GetNumSkillLines(skillType) do
            -- 获取技能线信息
            local skillLineName, _, _, _, _, _, _, _ = GetSkillLineInfo(skillType, skillLineIndex)
            for skillIndex = 1, GetNumSkillAbilities(skillType, skillLineIndex) do
                if (IsCraftedAbilitySkill(skillType, skillLineIndex, skillIndex)) then
                    local CAbilityId = GetCraftedAbilitySkillCraftedAbilityId(skillType, skillLineIndex, skillIndex)
                    local abilityId = GetCraftedAbilityRepresentativeAbilityId(CAbilityId)
                    local abilityName = GetCraftedAbilityDisplayName(CAbilityId)
                    local pri, sec, tri = GetCraftedAbilityActiveScriptIds(CAbilityId)
                    --     d("Crafted Ability Id: " .. CAbilityId .. " Ability Id: " .. abilityId .. "\nAbility Name: " .. abilityName .. " Skill Line Name: " .. skillLineName)
                    -- d("Crafted Ability Id: " .. CAbilityId .. "Ability Name: " .. abilityName)
                    -- d("Icon: " .. GetCraftedAbilityIcon(CAbilityId))
                    d("skillLineName: " .. skillLineName .. "Ability Name: " .. abilityName .. " Ability Id: " ..
                          abilityId)
                    d("pri: " .. pri .. " sec: " .. sec .. " pri: " .. tri)

                    -- local _, _, _, isPassive, isUltimate, isPurchased, progressionIndex, _, _ = self:GetSkillAbilityInfoSafe(skillType, skillLineIndex, skillIndex)
                    -- d("Ability Name: " .. abilityName .. " isPurchased: " .. tostring(isPurchased) .. " progressionIndex: " .. tostring(progressionIndex))
                end
            end
        end
    end
end

function MuchSmarterAutoLoot:ListAllScripts()
    local result = {}
    local slotArr = {
        SCRIBING_SLOT_PRIMARY,
        SCRIBING_SLOT_SECONDARY,
        SCRIBING_SLOT_TERTIARY
    }
    local charArr = {
        [SCRIBING_SLOT_PRIMARY] = {},
        [SCRIBING_SLOT_SECONDARY] = {},
        [SCRIBING_SLOT_TERTIARY] = {}
    }
    -- 遍历所有技能类型
    for i, slotType in ipairs(slotArr) do
        for caIndex = 1, GetNumCraftedAbilities() do
            local CAbilityId = GetCraftedAbilityIdAtIndex(caIndex)
            for index = 1, GetNumScriptsInSlotForCraftedAbility(CAbilityId, slotType) do
                local temp = {}
                local scriptId = GetScriptIdAtSlotIndexForCraftedAbility(CAbilityId, slotType, index)
                temp.id = scriptId
                temp.slotType = slotType
                temp.unlocked = IsCraftedAbilityScriptUnlocked(scriptId)
                if not result[scriptId] then
                    result[scriptId] = temp
                end
            end
        end
    end

    d("slot 1")
    for i, res in ipairs(result) do
        d("slot 1")
        if res.slotType == SCRIBING_SLOT_PRIMARY then
            d("id: " .. res.id .. "scriptName: " .. GetCraftedAbilityScriptDisplayName(res.id) .. ", unlocked: " ..
                  tostring(res.unlocked))
        end
    end

    for i, res in ipairs(result) do
        d("slot 2")
        if res.slotType == SCRIBING_SLOT_SECONDARY then
            d("id: " .. res.id .. "scriptName: " .. GetCraftedAbilityScriptDisplayName(res.id) .. ", unlocked: " ..
                  tostring(res.unlocked))
        end
    end

    for i, res in ipairs(result) do
        d("slot 3")
        if res.slotType == SCRIBING_SLOT_TERTIARY then
            d("id: " .. res.id .. "scriptName: " .. GetCraftedAbilityScriptDisplayName(res.id) .. ", unlocked: " ..
                  tostring(res.unlocked))
        end
    end

    -- for i, slotType in pairs(slotArr) do
    --     d("No." .. i .. " slot available scripts info:")
    --     for j, v in result do
    --         for index = 1, GetNumScriptsInSlotForCraftedAbility( craftedAbilityId, slotType) do
    --             local scriptId = GetScriptIdAtSlotIndexForCraftedAbility(craftedAbilityId, slotType, index)
    --             d("scriptName: ".. GetCraftedAbilityScriptDisplayName(scriptId)..", scriptId: "..scriptId)
    --             d("scriptIcon: "..GetCraftedAbilityScriptIcon(scriptId))
    --         end
    --     end
    -- end

    -- local craftedAbilityId = 1
    -- d("Listing "..GetCraftedAbilityDisplayName(craftedAbilityId).." scripts info: ")
    -- local slotArr = {SCRIBING_SLOT_PRIMARY, SCRIBING_SLOT_SECONDARY, SCRIBING_SLOT_TERTIARY}
    -- for i, slotType in pairs(slotArr) do
    --     d("No." ..i.. " slot available scripts info:")
    --     for index = 1, GetNumScriptsInSlotForCraftedAbility( craftedAbilityId, slotType) do
    --         local scriptId = GetScriptIdAtSlotIndexForCraftedAbility(craftedAbilityId, slotType, index)
    --         d("scriptName: ".. GetCraftedAbilityScriptDisplayName(scriptId)..", scriptId: "..scriptId)
    --         d("scriptIcon: "..GetCraftedAbilityScriptIcon(scriptId))
    --     end
    -- end

end

-- print all bag items
function MuchSmarterAutoLoot:ListAllBagItems()
    d("Start Listing")
    for bagSlot = 1, GetBagSize(BAG_BACKPACK) do
        local itemLink = GetItemLink(BAG_BACKPACK, bagSlot)
        local itemName = GetItemName(BAG_BACKPACK, bagSlot)
        if string.len(itemName) ~= 0 then
            d("item name: " .. GetItemName(BAG_BACKPACK, bagSlot) .. ", item Type: " ..
                  GetItemType(BAG_BACKPACK, bagSlot) .. ", is known book: " .. tostring(IsItemLinkBookKnown(itemLink)))
        end
    end
end

local function PrintControlNames(control, indent)
    indent = indent or 0
    local controlName = control:GetName()
    local w, h = control:GetDimensions()
    d(string.rep("--", indent) .. controlName .. " /  w:" .. math.floor(w) .. " h: " .. math.floor(h)) -- 打印控件名称

    -- 递归处理子控件
    for i = 1, control:GetNumChildren() do
        local childControl = control:GetChild(i)
        if childControl then
            PrintControlNames(childControl, indent + 1)
        end
    end
end

local base52 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

local function decToBase52WithLeadingZeros(decStr)
    if string.len(decStr) > 16 then
        d("decStr longer than 16")
        return nil
    end
    local num = tonumber(decStr)
    if not num then
        return nil
    end
    local result = ""
    while num > 0 do
        local remainder = (num - 1) % 52
        result = base52:sub(remainder + 1, remainder + 1) .. result
        num = math.floor((num - 1) / 52)
    end
    local base52Str = result
    local leadingZeros = decStr:match("^0+")
    if leadingZeros then
        base52Str = leadingZeros .. base52Str
    end
    return base52Str
end

local function base52ToDecWithLeadingZeros(base52Str)
    local leadingZeros = base52Str:match("^0+")
    local base52Part = base52Str:match("^[0]*(.*)")
    local num = 0
    for i = 1, #base52Part do
        local char = base52Part:sub(i, i)
        local value = base52:find(char)
        if not value then
            return nil
        end
        num = num * 52 + value
    end
    local decStr = tostring(num)
    if leadingZeros then
        decStr = leadingZeros .. decStr
    end
    return decStr
end

function MuchSmarterAutoLoot:testBase52()
    local decNumber = "004567891230"
    local base52Number = decToBase52WithLeadingZeros(decNumber)
    d("十进制:", decNumber, " 转换为52进制:", base52Number)
    d("52进制:", base52Number, " 转换回十进制:", base52ToDecWithLeadingZeros(base52Number))
end

local function doZip(former)
    local arr = {}
    local len = 0
    for i = 1, #former - 1, 2 do
        local tmp = string.char(tonumber(former:sub(i, i + 1)))
        len = len + 1
        arr[len] = tmp
    end
    if #former % 2 == 1 then
        len = len + 1
        arr[len] = "-" .. former:sub(#former)
    end
    return table.concat(arr)
end

-- 解压算法，将ASCII码转换成数字，如果字符个数为奇数时，返回最后一位的负数值
local function doUnZip(arr)
    local brr = {}
    local len = 0
    for i = 1, #arr do
        local tmp = string.byte(arr:sub(i, i))
        if tmp < 10 then
            tmp = "0" .. tmp
        end
        len = len + 1
        brr[len] = tostring(tmp)
    end
    local theLast = arr:sub(#arr)
    if #theLast > 1 then
        local tmp = tonumber(theLast)
        tmp = math.abs(tmp)
        len = len + 1
        brr[len] = tostring(tmp)
    else
        local tmp = string.byte(theLast)
        if tmp < 10 then
            tmp = "0" .. tmp
        end
        len = len + 1
        brr[len] = tostring(tmp)
    end
    return table.concat(brr)
end

function MuchSmarterAutoLoot:test()
    d("printing...")
    d(getStandardizeName("Woodworker's Case X"))
end

function MuchSmarterAutoLoot:ListChatWindowChildren()
    PrintControlNames(ZO_IMECandidates_TopLevelPane:GetParent())
end

