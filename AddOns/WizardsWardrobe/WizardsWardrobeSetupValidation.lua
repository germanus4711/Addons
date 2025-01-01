WizardsWardrobe = WizardsWardrobe or {}
local WW = WizardsWardrobe
WW.validation = WW.validation or {}
local WWV = WW.validation
WW.name = "WizardsWardrobe"
WW.simpleName = "Wizard's Wardrobe"
WW.displayName =
"|c18bed8W|c26c2d1i|c35c6c9z|c43cac2a|c52cebar|c60d1b3d|c6fd5ab'|c7dd9a4s|c8cdd9d |c9ae195W|ca8e58ea|cb7e986r|cc5ed7fd|cd4f077r|ce2f470o|cf1f868b|cfffc61e|r"

local logger = LibDebugLogger( WW.name )
logger = logger:Create( "SetupValidation" )
local async = LibAsync
local validationTask = async:Create( WW.name .. "Validation" )
WW.validation.validationTask = validationTask
local setupName = ""
local validationDelay = 1500
local WORKAROUND_INITIAL_CALL = 0
local WORKAROUND_ONE = 1
local WORKAROUND_TWO = 2
local WORKAROUND_THREE = 3
local WORKAROUND_FOUR = 4
local lastSetup = nil


function WWV.CompareItemLinks( linkEquipped, linkSaved, uniqueIdEquipped, uniqueIdSaved )
    local traitEquipped = GetItemLinkTraitInfo( linkEquipped )
    local traitSaved = GetItemLinkTraitInfo( linkSaved )
    local weaponTypeEquipped = GetItemLinkWeaponType( linkEquipped )
    local weaponTypeSaved = GetItemLinkWeaponType( linkSaved )
    local nameEquipped = GetItemLinkName( linkEquipped )
    local nameSaved = GetItemLinkName( linkSaved )
    local _, _, _, _, _, setIdEquipped = GetItemLinkSetInfo( linkEquipped )
    local _, _, _, _, _, setIdSaved = GetItemLinkSetInfo( linkSaved )
    logger:Verbose( "CompareItemLinks: comparisonDepth: " .. WW.settings.comparisonDepth )

    logger:Verbose(
        "nameEquipped: %s, nameSaved: %s, linkEquipped: %s, linkSaved: %s, uniqueIdEquipped: %s, uniqueIdSaved: %s",
        nameSaved, nameEquipped, linkEquipped, linkSaved,
        uniqueIdEquipped, uniqueIdSaved
    )
    logger:Verbose(
        "traitEquipped: %d, traitSaved: %d, weaponTypeEquipped: %d, weaponTypeSaved: %d, setIdEquipped: %d, setIdSaved: %d",
        traitEquipped, traitSaved, weaponTypeEquipped, weaponTypeSaved, setIdEquipped, setIdSaved )
    --If unique Id matches all the other checks are redundant
    if uniqueIdEquipped == uniqueIdSaved then
        logger:Debug( "Default: UniqueId matched" )
        return true
    end
    --! All of this should be redundant, uniqueId should always match and if it doesnt something failed already
    --? Should we keep this for redundancy?
    if WW.settings.comparisonDepth == 1 then -- easy
        if (weaponTypeEquipped ~= weaponTypeSaved) or (setIdEquipped ~= setIdSaved) then
            logger:Warn( "Easy: Weapon Type or set Id did not match" )
            return false
        end
        logger:Debug( "Easy: Weapon Type or set Id matched" )
        return true
    end
    local qualityEquipped = GetItemLinkDisplayQuality( linkEquipped )
    local _, enchantEquipped = GetItemLinkEnchantInfo( linkEquipped )
    local qualitySaved = GetItemLinkDisplayQuality( linkSaved )
    local _, enchantSaved = GetItemLinkEnchantInfo( linkSaved )
    logger:Verbose( "qualityEquipped: %s, qualitySaved: %s, enchantEquipped: %s, enchantSaved: %s",
        tostring( qualityEquipped ),
        tostring( qualitySaved ), tostring( enchantEquipped ), tostring( enchantSaved ) )
    if WW.settings.comparisonDepth == 2 then -- detailed
        if (traitEquipped ~= traitSaved) or (weaponTypeEquipped ~= weaponTypeSaved) or (setIdEquipped ~= setIdSaved) or (qualityEquipped ~= qualitySaved) then
            logger:Warn( "Detailed: Trait / Weapon Type / Set Id / Quality did not match" )
            return false
        end
        logger:Debug( "Detailed: Trait / Weapon Type / Set Id / Quality matched" )
        return true
    end


    if WW.settings.comparisonDepth == 3 then -- thorough
        if (traitEquipped ~= traitSaved) or (weaponTypeEquipped ~= weaponTypeSaved) or (setIdEquipped ~= setIdSaved) or (qualityEquipped ~= qualitySaved) or (enchantEquipped ~= enchantSaved) then
            logger:Warn( "Thorough: Trait / Weapon Type / Set Id / Quality / Enchant did not match" )
            return false
        end
        logger:Debug( "Thorough: Trait / Weapon Type / Set Id / Quality / Enchant matched" )
        return true
    end
    --! Redundant check, uniqueId is checked first
    --[[ if WW.settings.comparisonDepth == 4 then -- Strict
        if uniqueIdEquipped ~= uniqueIdSaved then
            logger:Warn( "UniqueId did not match" )
            return false
        end
        logger:Debug( "UniqueId matched" )
        return true
    end ]]
end

--TODO: untangle this mess. should prob make a metamethod to compare setups instead of this
function WWV.DidSetupSwapCorrectly( workAround )
    logger:Info( "DidSetupSwapCorrectly has been called" )
    local zone = WW.selection.zone
    local tag = zone.tag
    local pageId = WW.selection.pageId
    local index = WW.currentIndex
    local setupTable = Setup:FromStorage( tag, pageId, index )
    local check = nil
    local t = {}
    local timeStamp = GetTimeStamp()
    local inCombat = IsUnitInCombat( "player" )
    local worldName = GetWorldName()
    local characterId = GetCurrentCharacterId()
    local pageName = zone.name
    local zoneName = GetPlayerActiveZoneName()
    local isBlocking = IsBlockActive()
    local subZone = GetPlayerActiveSubzoneName()
    local failedT = {}
    local db = WW.settings
    local key = GetWorldName() .. GetDisplayName() .. GetCurrentCharacterId() .. os.date( "%Y%m%d%H" ) .. index
    local skillSuccess = nil



    if not db.failedSwapLog then db.failedSwapLog = {} end
    db = db.failedSwapLog

    local isGearPresent = false
    if setupTable and setupTable.gear then
        logger:Info( "Gear is present" )
        setupName = setupTable.name
        for _, equipSlot in pairs( WW.GEARSLOTS ) do
            if setupTable.gear[ equipSlot ] then
                isGearPresent = true
                local equippedLink = GetItemLink( BAG_WORN, equipSlot, LINK_STYLE_DEFAULT )
                local savedLink = setupTable.gear[ equipSlot ].link
                local equippedUId = Id64ToString( GetItemUniqueId( BAG_WORN, equipSlot ) )
                local savedUId = setupTable.gear[ equipSlot ].id
                local success = nil
                logger:Debug( " equipSlot: %s, %s // %s", GetString( "SI_EQUIPSLOT", equipSlot ), equippedLink, savedLink )
                if WWV.CompareItemLinks( equippedLink, savedLink, equippedUId, savedUId ) then
                    success = true
                else
                    if equipSlot == EQUIP_SLOT_POISON or equipSlot == EQUIP_SLOT_BACKUP_POISON and success == true then
                        if WW.settings.setupValidation.ignorePoisons then
                            success = true
                        else
                            success = false
                        end
                    elseif equipSlot == EQUIP_SLOT_COSTUME then
                        if WW.settings.setupValidation.ignoreCostume then
                            success = true
                        else
                            success = false
                        end
                    elseif WW.settings.unequipEmpty and equippedLink == "" then
                        success = true
                    elseif not WW.settings.unequipEmpty and savedLink == "" then
                        success = true
                    else
                        failedT[ # failedT + 1 ] = GetString( "SI_EQUIPSLOT", equipSlot )
                        logger:Verbose( "Equipped %s // saved %s", equippedLink, savedLink )
                        success = false
                        if workAround > 2 then
                            if not db[ equipSlot ] then db[ equipSlot ] = {} end

                            --No need to log for each workaround, just log the last
                            EVENT_MANAGER:RegisterForUpdate( WW.name .. "Throttle" .. equipSlot, 5000, function()
                                if not db[ equipSlot ][ key ] then db[ equipSlot ][ key ] = {} end
                                db[ equipSlot ][ key ] = {
                                    timeStamp = timeStamp,
                                    inCombat = inCombat,
                                    worldName = worldName,
                                    characterId = characterId,
                                    pageName = pageName,
                                    zone = zoneName,
                                    subzone = subZone,
                                    pageId = pageId,
                                    setupName = setupName,
                                    equippedLink = equippedLink,
                                    savedLink = savedLink,
                                    settings = {
                                        gear = WW.settings.auto.gear,
                                        skills = WW.settings.auto.skills,
                                        cp = WW.settings.auto.cp,
                                        food = WW.settings.auto.food,
                                    },
                                    workAround = workAround,
                                    isBlocking = isBlocking

                                }
                                EVENT_MANAGER:UnregisterForUpdate( WW.name .. "Throttle" .. equipSlot )
                            end )
                        end
                    end
                end
                t[ equipSlot ] = success
            end
        end
        for eqSlot, success in pairs( t ) do
            if not success then
                logger:Verbose( GetString( "SI_EQUIPSLOT", eqSlot ) .. " -- " .. tostring( success ) )
                check = false
                break
            else
                check = true
            end
        end
    end
    if setupTable and setupTable.skills then
        logger:Info( "Skills are present" )
        skillSuccess = true
        local skillTable = setupTable.skills

        for hotbar = 0, 1 do
            for skill = 3, 8 do
                local hotbarData = ACTION_BAR_ASSIGNMENT_MANAGER:GetHotbar( hotbar )
                local slotData = hotbarData:GetSlotData( skill )
                local savedSkill = skillTable[ hotbar ][ skill ]
                local equippedSkill = 0
                local equippedBaseId = 0
                local savedBaseId = 0
                if slotData then
                    if slotData.abilityId == 195031 then
                        equippedSkill = slotData.abilityId
                    else
                        if slotData == ZO_EMPTY_SLOTTABLE_ACTION then

                        else
                            equippedSkill = slotData:GetEffectiveAbilityId()
                        end
                    end
                end
                local areSkillsEqual = WW.AreSkillsEqual( equippedSkill, savedSkill )
                if areSkillsEqual then
                    skillSuccess = true
                else
                    if WW.settings.unequipEmpty then
                        if equippedSkill == 0 then
                            skillSuccess = true
                        else
                            failedT[ # failedT + 1 ] = GetAbilityName( savedSkill )
                            skillSuccess = false
                            logger:Warn( "Skills did not swap correctly: %s // %s (empty skill)",
                                GetAbilityName( equippedSkill ),
                                GetAbilityName( savedSkill ) )
                        end
                    end
                end
                --[[   if equippedSkill ~= 0 and equippedSkill ~= 195031 then
                    equippedBaseId = WW.GetBaseAbilityId( equippedSkill )
                end
                if savedSkill ~= 195031 then
                    savedBaseId = WW.GetBaseAbilityId( savedSkill )
                end ]]

                logger:Verbose( "SavedBaseId = %s, name= %s, equippedBaseId = %s, name = %s", tostring( savedBaseId ),
                    GetAbilityName( savedBaseId ), tostring( equippedBaseId ),
                    GetAbilityName( equippedBaseId ) )
                --[[ logger:Debug( "SavedSkill = %s, equippedSkill = %s", GetAbilityName( savedSkill ),
                    GetAbilityName( equippedSkill ) ) ]]
                if savedBaseId ~= equippedBaseId and skillSuccess == true then
                    if savedBaseId == 0 then
                        if WW.settings.unequipEmpty then
                            if equippedBaseId == 0 then
                                skillSuccess = true
                            else
                                failedT[ # failedT + 1 ] = GetAbilityName( savedSkill )
                                skillSuccess = false
                                logger:Warn( "Skills did not swap correctly: %s // %s (empty skill)",
                                    GetAbilityName( equippedSkill ),
                                    GetAbilityName( savedSkill ) )
                            end
                        else
                            skillSuccess = true
                        end
                    elseif equippedBaseId == 0 then
                        if WW.settings.unequipEmpty then
                            skillSuccess = true
                        else
                            if equippedSkill == 195031 then
                                skillSuccess = true
                            else
                                failedT[ # failedT + 1 ] = GetAbilityName( savedSkill )
                                skillSuccess = false
                                logger:Warn( "Skills did not swap correctly: %s // %s (empty skill)",
                                    GetAbilityName( equippedSkill ),
                                    GetAbilityName( savedSkill ) )
                            end
                        end
                    elseif equippedSkill ~= 195031 then
                        failedT[ # failedT + 1 ] = GetAbilityName( savedSkill )
                        skillSuccess = false
                        logger:Warn( "Skills did not swap correctly: %s // %s, (initial)", GetAbilityName( equippedSkill ),
                            GetAbilityName( savedSkill ) )
                    else
                        failedT[ # failedT + 1 ] = GetAbilityName( savedSkill )
                        skillSuccess = false
                        logger:Warn( "Skills did not swap correctly: %s // %s (not crypt or empty skill )",
                            GetAbilityName( equippedSkill ),
                            GetAbilityName( savedSkill ) )
                    end
                end
            end
        end
        if skillSuccess then
            logger:Debug( "Skills swapped correctly" )
        else
            logger:Warn( "Skills did not swap correctly" )
        end
    end
    if check then
        logger:Debug( "Gear swapped correctly" )
    else
        logger:Warn( "Gear did not swap correctly" )
    end
    if not isGearPresent then check = true end
    if not skillSuccess then check = false end
    return check, failedT
end

local function failureFunction( workaround )
    validationTask:Cancel()
    EVENT_MANAGER:UnregisterForUpdate( WW.name .. "Throttle" )
    EVENT_MANAGER:UnregisterForUpdate( WW.name .. "Throttle2" )
    EVENT_MANAGER:UnregisterForEvent( WW.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE )
    EVENT_MANAGER:UnregisterForEvent( WW.name .. "workaroundOne", EVENT_INVENTORY_SINGLE_SLOT_UPDATE )
    EVENT_MANAGER:UnregisterForUpdate( WW.name .. "ThrottleWorkaroundOne" )
    EVENT_MANAGER:UnregisterForEvent( WW.name .. "workaroundTwo", EVENT_INVENTORY_SINGLE_SLOT_UPDATE )
    EVENT_MANAGER:UnregisterForUpdate( WW.name .. "ThrottleWorkaroundTwo" )
    EVENT_MANAGER:UnregisterForEvent( WW.name .. "workaroundThree", EVENT_INVENTORY_SINGLE_SLOT_UPDATE )
    EVENT_MANAGER:UnregisterForUpdate( WW.name .. "ThrottleWorkaroundThree" )
    EVENT_MANAGER:UnregisterForEvent( WW.name .. "workaroundFour", EVENT_INVENTORY_SINGLE_SLOT_UPDATE )
    EVENT_MANAGER:UnregisterForUpdate( WW.name .. "ThrottleWorkaroundTFour" )
    EVENT_MANAGER:UnregisterForUpdate( WW.name .. "Failure" )
    if workaround > 2 then
        WW.Log( GetString( WW_MSG_SWAP_FIX_FAIL ), WW.LOGTYPES.ERROR )
    end
end
local function successFunction()
    -- Cancel everything in case swap worked out sooner than expected to avoid having situations where some function gets called endlessly
    validationTask:Cancel()
    EVENT_MANAGER:UnregisterForUpdate( WW.name .. "Throttle" )
    EVENT_MANAGER:UnregisterForUpdate( WW.name .. "Throttle2" )
    EVENT_MANAGER:UnregisterForEvent( WW.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE )
    EVENT_MANAGER:UnregisterForEvent( WW.name, EVENT_ACTION_SLOT_UPDATED )
    EVENT_MANAGER:UnregisterForEvent( WW.name .. "workaroundOne", EVENT_INVENTORY_SINGLE_SLOT_UPDATE )
    EVENT_MANAGER:UnregisterForUpdate( WW.name .. "ThrottleWorkaroundOne" )
    EVENT_MANAGER:UnregisterForEvent( WW.name .. "workaroundTwo", EVENT_INVENTORY_SINGLE_SLOT_UPDATE )
    EVENT_MANAGER:UnregisterForUpdate( WW.name .. "ThrottleWorkaroundTwo" )
    EVENT_MANAGER:UnregisterForEvent( WW.name .. "workaroundThree", EVENT_INVENTORY_SINGLE_SLOT_UPDATE )
    EVENT_MANAGER:UnregisterForUpdate( WW.name .. "ThrottleWorkaroundThree" )
    EVENT_MANAGER:UnregisterForEvent( WW.name .. "workaroundFour", EVENT_INVENTORY_SINGLE_SLOT_UPDATE )
    EVENT_MANAGER:UnregisterForUpdate( WW.name .. "ThrottleWorkaroundTFour" )
    EVENT_MANAGER:UnregisterForUpdate( WW.name .. "Failure" )
    logger:Warn( "Swap success" )
    lastSetup = nil
    WW.Log( GetString( WW_MSG_SWAPSUCCESS ), WW.LOGTYPES.NORMAL )
    local middleText = string.format( "|c%s%s|r", WW.LOGTYPES.NORMAL, setupName )
    for lineStyle, lineStyleTable in pairs( CENTER_SCREEN_ANNOUNCE.activeLines ) do
        for _, line in ipairs( lineStyleTable ) do
            if line.messageParams.mainText == "CRITICAL ERROR" then
                CENTER_SCREEN_ANNOUNCE:RemoveActiveLine( line )
            end
        end
    end
    WizardsWardrobePanelBottomLabel:SetText( middleText )
    WW.callbackManager:FireCallbacks( "WW_OnSetupSwapSuccess" )
end


--[[ Last ditch effort, I have in all my testing never seen that anything other than weapons got stuck.
 So this should never happen, we still have it in case something odd is happening ]]

local function workaroundFour()
    logger:Info( "workaround four got called" )
    EVENT_MANAGER:UnregisterForUpdate( WW.name .. "ThrottleWorkaroundThree" )
    EVENT_MANAGER:UnregisterForEvent( WW.name .. "workaroundThree", EVENT_INVENTORY_SINGLE_SLOT_UPDATE )

    -- Redundancy in case everything is stuck and no event triggers. This will hopefully always be unregistered before it actually gets called
    EVENT_MANAGER:RegisterForUpdate( WW.name .. "Throttle2", 5000,
        function()
            failureFunction( 4 ) -- If all swaps have failed.
        end )

    if not WWV.DidSetupSwapCorrectly( WORKAROUND_FOUR ) then
        validationTask:Call( function()
            WW.Undress()
        end ):WaitUntil( function() -- Wait until every worn item is in the bag
            local isNotEmpty = nil
            for _, equipSlot in pairs( WW.GEARSLOTS ) do
                if Id64ToString( GetItemUniqueId( BAG_WORN, equipSlot ) ) ~= "0" then
                    isNotEmpty = true
                elseif Id64ToString( GetItemUniqueId( BAG_WORN, equipSlot ) ) == "0" and not isNotEmpty then
                    isNotEmpty = false
                end
            end
            return not isNotEmpty
        end ):Then( function()
            local DO_SKIP_VALIDATION = true               -- prevent endless looping
            WW.LoadSetupAdjacent( 0, DO_SKIP_VALIDATION ) -- reload current setup
        end ):Call( function()
            EVENT_MANAGER:RegisterForEvent( WW.name .. "workaroundThree", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, function()
                EVENT_MANAGER:RegisterForUpdate( WW.name .. "Throttle", validationDelay / 2, function()
                    if WWV.DidSetupSwapCorrectly( WORKAROUND_FOUR ) then
                        successFunction()
                    else
                        failureFunction( 4 )
                    end
                    EVENT_MANAGER:UnregisterForEvent( WW.name .. "workaroundThree", EVENT_INVENTORY_SINGLE_SLOT_UPDATE )
                    EVENT_MANAGER:UnregisterForUpdate( WW.name .. "Throttle" )
                end )
            end )
        end )
    else
        successFunction()
    end
end

-- Unequip weapons and reload setup
local function workaroundThree()
    logger:Info( "workaround three got called" )
    local t = {
        EQUIP_SLOT_MAIN_HAND,
        EQUIP_SLOT_OFF_HAND,
        EQUIP_SLOT_BACKUP_MAIN,
        EQUIP_SLOT_BACKUP_OFF
    }


    Setup:GetData()
    local moveTask = async:Create( WW.name .. "Move" )
    EVENT_MANAGER:UnregisterForUpdate( WW.name .. "ThrottleWorkaroundTwo" )
    EVENT_MANAGER:UnregisterForEvent( WW.name .. "workaroundTwo", EVENT_INVENTORY_SINGLE_SLOT_UPDATE )
    EVENT_MANAGER:RegisterForEvent( WW.name .. "workaroundThree", EVENT_INVENTORY_SINGLE_SLOT_UPDATE,
        function()
            moveTask:Resume() -- continue loop
            EVENT_MANAGER:RegisterForUpdate( WW.name .. "ThrottleWorkaroundThree",
                validationDelay / 2,
                function()
                    workaroundFour()
                end )
        end )
    EVENT_MANAGER:AddFilterForEvent( WW.name .. "workaroundThree", EVENT_INVENTORY_SINGLE_SLOT_UPDATE,
        REGISTER_FILTER_BAG_ID,
        BAG_WORN )

    EVENT_MANAGER:AddFilterForEvent( WW.name .. "workaroundThree", EVENT_INVENTORY_SINGLE_SLOT_UPDATE,
        REGISTER_FILTER_INVENTORY_UPDATE_REASON,
        INVENTORY_UPDATE_REASON_DEFAULT )



    moveTask:Call( function()
        if not WWV.DidSetupSwapCorrectly( WORKAROUND_THREE ) then
            moveTask:For( 1, #t ):Do( function( index )
                local emptySlot = FindFirstEmptySlotInBag( BAG_BACKPACK )
                local equipSlot = t[ index ]
                local weaponType = GetItemWeaponType( BAG_WORN, equipSlot )
                local link = GetItemLink( BAG_WORN, equipSlot, LINK_STYLE_DEFAULT )

                if weaponType ~= WEAPONTYPE_NONE then
                    CallSecureProtected( "RequestMoveItem", BAG_WORN, equipSlot, BAG_BACKPACK, emptySlot, 1 )
                    moveTask:Suspend() -- Suspend loop until item has actually moved
                end
            end ):Then( function()
                local DO_SKIP_VALIDATION = true
                WW.LoadSetupAdjacent( 0, DO_SKIP_VALIDATION )
            end )
        else
            successFunction()
        end
    end )
    EVENT_MANAGER:RegisterForUpdate( WW.name .. "ThrottleWorkaroundThree", validationDelay, workaroundFour ) -- If no item moved, move on to workaround four
end
WW.WorkAroundThree = workaroundThree
local function handleSettings()
    logger:Info( "handle settings has been called" )

    EVENT_MANAGER:UnregisterForUpdate( WW.name .. "ThrottleWorkaroundTwo" )
    EVENT_MANAGER:UnregisterForEvent( WW.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE )

    validationTask:Call( function()
        local success, failedT = WWV.DidSetupSwapCorrectly( WORKAROUND_INITIAL_CALL )

        local failedSlotNames = table.concat( failedT, ", " )
        if success then
            successFunction()
        else
            local middleText = string.format( "|c%s%s|r", WW.LOGTYPES.ERROR, setupName )
            WizardsWardrobePanelBottomLabel:SetText( middleText )

            WW.Log( GetString( WW_MSG_SWAPFAIL_DISABLED ), WW.LOGTYPES.ERROR, "FFFFFF", failedSlotNames )

            failureFunction( 1 )
        end
    end )
end
-- Reload setup
local function workaroundTwo( skipValidation )
    if skipValidation then
        logger:Warn( "Skipping validation" )
        return failureFunction( 4 )
    end

    logger:Info( "workaroundTwo got called" )
    EVENT_MANAGER:UnregisterForUpdate( WW.name .. "ThrottleWorkaroundOne" )
    EVENT_MANAGER:UnregisterForEvent( WW.name .. "workaroundOne", EVENT_INVENTORY_SINGLE_SLOT_UPDATE )
    validationTask:Call( function()
        EVENT_MANAGER:RegisterForEvent( WW.name .. "workaroundTwo", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, function()
            if WWV.DidSetupSwapCorrectly( WORKAROUND_TWO ) then
                successFunction()
            else
                EVENT_MANAGER:RegisterForUpdate( WW.name .. "ThrottleWorkaroundTwo", validationDelay / 2, handleSettings )
            end
        end )
        EVENT_MANAGER:AddFilterForEvent( WW.name .. "workaroundTwo", EVENT_INVENTORY_SINGLE_SLOT_UPDATE,
            REGISTER_FILTER_BAG_ID,
            BAG_WORN )

        EVENT_MANAGER:AddFilterForEvent( WW.name .. "workaroundTwo", EVENT_INVENTORY_SINGLE_SLOT_UPDATE,
            REGISTER_FILTER_INVENTORY_UPDATE_REASON,
            INVENTORY_UPDATE_REASON_DEFAULT )
        if not WWV.DidSetupSwapCorrectly( WORKAROUND_TWO ) then
            local DO_SKIP_VALIDATION = true
            WW.LoadSetupAdjacent( 0, DO_SKIP_VALIDATION )
        else
            successFunction()
        end
        EVENT_MANAGER:RegisterForUpdate( WW.name .. "ThrottleWorkaroundTwo", validationDelay, handleSettings ) -- wait for the gear swap event, if it doesnt happen then try workaround three
    end )
end

-- Sheathe weapons and see if it fixes itself
local function workaroundOne( skipValidation, isChangingWeapons )
    EVENT_MANAGER:UnregisterForUpdate( WW.name .. "Throttle" )

    logger:Info( "workaround one got called" )

    EVENT_MANAGER:RegisterForEvent( WW.name .. "workaroundOne", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, function()
        if WWV.DidSetupSwapCorrectly( WORKAROUND_ONE ) then
            successFunction()
        else
            EVENT_MANAGER:RegisterForUpdate( WW.name .. "ThrottleWorkaroundOne", validationDelay / 2, function()
                workaroundTwo( skipValidation )
            end ) -- throttle to call workaround after the last event
        end
    end )
    EVENT_MANAGER:AddFilterForEvent( WW.name .. "workaroundOne", EVENT_INVENTORY_SINGLE_SLOT_UPDATE,
        REGISTER_FILTER_BAG_ID, BAG_WORN )

    EVENT_MANAGER:AddFilterForEvent( WW.name .. "workaroundOne", EVENT_INVENTORY_SINGLE_SLOT_UPDATE,
        REGISTER_FILTER_INVENTORY_UPDATE_REASON,
        INVENTORY_UPDATE_REASON_DEFAULT )
    validationTask:Call( function()
        validationTask:WaitUntil( function()
            return not IsUnitInCombat( "player" )
        end )
        if not WWV.DidSetupSwapCorrectly( WORKAROUND_ONE ) then
            if not ArePlayerWeaponsSheathed() and isChangingWeapons then
                TogglePlayerWield()
            end
            EVENT_MANAGER:RegisterForUpdate( WW.name .. "ThrottleWorkaroundOne", validationDelay,
                function()
                    workaroundTwo( skipValidation )
                end ) -- we wait for the gear swap event, if it does not happen we try workaround two
        else
            successFunction()
        end
    end )
end
-- Make function accessible via keybind
--WWV.WorkAroundOne = workaroundOne


-- Function gets called once on setup swap

function WWV.SetupFailWorkaround( setupName, skipValidation, isChangingWeapons )
    if skipValidation then
        logger:Info( "Skipping validation" )
    else
        logger:Info( "Not skipping validation" )
    end
    logger:Verbose( "SetupFailWorkaround has been called" )
    validationDelay = WW.settings.setupValidation.delay
    local function throttle()
        if WWV.DidSetupSwapCorrectly( WORKAROUND_INITIAL_CALL ) then
            return successFunction()
        else
            EVENT_MANAGER:RegisterForUpdate( WW.name .. "Throttle", validationDelay, function()
                workaroundOne( skipValidation, isChangingWeapons )
            end )
        end
    end
    if WWV.DidSetupSwapCorrectly( WORKAROUND_INITIAL_CALL ) then
        return successFunction()
    end
    EVENT_MANAGER:RegisterForEvent( WW.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, throttle )
    EVENT_MANAGER:RegisterForEvent( WW.name, EVENT_ACTION_SLOT_UPDATED, throttle )
    EVENT_MANAGER:AddFilterForEvent( WW.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE,
        REGISTER_FILTER_BAG_ID, BAG_WORN )

    EVENT_MANAGER:AddFilterForEvent( WW.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE,
        REGISTER_FILTER_INVENTORY_UPDATE_REASON,
        INVENTORY_UPDATE_REASON_DEFAULT )
    EVENT_MANAGER:RegisterForUpdate( WW.name .. "Failure", validationDelay + 500, throttle )
end

-- Suspend all tasks when in combat and resume once we are out
local function combatFunction( _, inCombat )
    if inCombat then
        validationTask:Suspend()
    else
        validationTask:Resume()
    end
end


EVENT_MANAGER:RegisterForEvent( WW.name, EVENT_PLAYER_COMBAT_STATE, function( _, inCombat ) combatFunction( _, inCombat ) end )
