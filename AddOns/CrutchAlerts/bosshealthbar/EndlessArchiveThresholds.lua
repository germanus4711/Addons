CrutchAlerts = CrutchAlerts or {}
CrutchAlerts.BossHealthBar = CrutchAlerts.BossHealthBar or {}
local Crutch = CrutchAlerts
local BHB = Crutch.BossHealthBar

---------------------------------------------------------------------
local function GetBossName(id)
    return Crutch.GetCapitalizedString(id)
end

---------------------------------------------------------------------
-- Add percentage threshold + the mechanic name below
---------------------------------------------------------------------
local endlessArchiveThresholds = {
    -- Allene Pellingare -- nothing interesting
    -- Ash Titan

    -- Barbas -- nothing interesting
    -- Baron Zaudrus
    -- Bittergreen the Wild

    -- Caluurion -- not sure if relics are hp based. spawns exploding skellies
    -- Canonreeve Oraneth -- no hp gates, has squishy skelly spawns
    -- Captain Blackheart -- no hp gates, no adds
    -- Councilor Vandacia -- kamikaze flame atros, cc'able daedroths
    [GetBossName(CRUTCH_BHB_COUNCILOR_VANDACIA)] = {
        [50] = "Desperation", -- meteors all over the place
    },
    -- Cynhamoth

    -- Death's Leviathan -- no adds
    [GetBossName(CRUTCH_BHB_DEATHS_LEVIATHAN)] = {
        [50] = "Immolate",
    },
    -- Doylemish Ironheart
    [GetBossName(CRUTCH_BHB_DOYLEMISH_IRONHEART)] = {
        [50] = "Stone Orb", -- They seem to spawn on a timer after 50%, but don't... do anything?
    },
    -- Dranos Velador -- big yikes
    ["Dranos Velador"] = { -- TODO: localization
        [50] = "Duplicity",
    },
    -- Dugan the Red

    -- Exarch Kraglen -- nothing interesting

    -- Garron the Returned -- Consume Life is timer based -- no hp gates, wraiths can hit hard
    -- Ghemvas the Harbinger
    [GetBossName(CRUTCH_BHB_GHEMVAS_THE_HARBINGER)] = {
        [50] = "Unstable Energy",
    },
    -- Glemyos Wildhorn -- indriks might be on timer
    -- Graufang -- nothing interesting
    -- Grothdarr -- nothing interesting

    -- High Kinlord Rilis -- nothing interesting

    -- Iceheart -- nothing interesting

    -- Kjarg the Tuskscraper -- nothing interesting
    -- Kovan Giryon -- doesn't seem to have gates

    -- Kra'gh the Dreugh King
    [GetBossName(CRUTCH_BHB_KRAGH_THE_DREUGH_KING)] = {
        [50] = "Mudcrabs",
    },

    -- Laatvulon -- RIP. frost atros during blizzard, but worse, freezing winds dot that can't be debuffed
    [GetBossName(CRUTCH_BHB_LAATVULON)] = {
        [50] = "Blizzard",
    },
    -- Lady Belain
    [GetBossName(CRUTCH_BHB_LADY_BELAIN)] = {
        [50] = "Awakening", -- She flies up and summons 2~4 voidmothers (random/inconsistent), and you take constant Awakening damage
        -- Seems like after 50 she also summons blood knights, 3 at once
    },
    -- Lady Thorn -- no adds, except squishy things during scatter
    [GetBossName(CRUTCH_BHB_LADY_THORN)] = {
        [50] = "Batdance",
    },
    -- Limenauruus -- no hp gates, no adds
    -- Lord Warden Dusk -- no hp gates? has shades

    -- Marauder Bittog -- no hp gates
    -- Marauder Gothmau -- no hp gates
    -- Marauder Hilkarax -- no hp gates
    -- Marauder Ulmor -- no hp gates
    -- Marauder Zulfimbul -- no hp gates

    -- Molag Kena -- storm atros. might be possible to debuff while in shielded phase?
    -- Mulaamnir
    [GetBossName(CRUTCH_BHB_MULAAMNIR)] = {
        [50] = "Storm",
    },
    -- Murklight

    -- Nazaray
    -- Nerien'eth
    [GetBossName(CRUTCH_BHB_NERIENETH)] = {
        [50] = "Ebony Blade",
    },

    -- Old Snagara -- no hp gates
    -- Prior Thierric Sarazen -- no hp gates

    -- Queen of the Reef

    -- Ra'khajin -- no hp gates
    -- Rada al-Saran -- no hp gates
    -- Rakkhat -- no hp gates I think
    -- Razor Master Erthas
    -- Ri'Atahrashi -- no hp gates, no adds
    -- Risen Ruins -- no hp gates, has adds like nullifier. boulders may not be affected by cowardice? unsure

    -- Sail Ripper
    -- Selene -- the Claw and Fang seem to be on both timer and hp gate
    -- Sentinel Aksalaz -- big adds AND frostkin!!
    [GetBossName(CRUTCH_BHB_SENTINEL_AKSALAZ)] = {
        -- Unsure of exact %s. In 2 runs, spawned in order of atro > indrik > nereid
        -- Different order: indrik > nereid > atro
        -- solo run: atro > indrid > nereid
        [75] = "Add", -- TODO: still not sure. He seems to have a lot of priority skills
        [50] = "Add",
        [25] = "Add",
    },
    -- Shadowrend -- no hp gates, has some shades
    -- Staada -- no hp gates no adds
    -- Sonolia the Matriarch -- no hp gates
    -- Symphony of Blades -- no hp gates?

    -- Taupezu Azzida -- no hp gates
    -- The Ascendant Lord -- no hp gates?
    -- The Endling -- no hp gates?
    -- The Imperfect -- shield at 50%?
    -- The Lava Queen -- no hp gates, no adds
    -- The Mage -- storm atros
    [GetBossName(CRUTCH_BHB_THE_MAGE)] = {
        [50] = "Arcane Vortex",
    },
    -- The Sable Knight -- no hp gates, no adds
    -- The Serpent
    -- The Warrior
    ["The Warrior"] = { -- TODO: localization
        [50] = "Shehai",
    },
    -- The Weeping Woman -- no hp gates, no adds
    -- The Whisperer
    -- Tho'at Replicanum
    [GetBossName(CRUTCH_BHB_THOAT_REPLICANUM)] = {
        [70] = "Shard", -- TODO: don't show this for Arc 1
    },
    [GetBossName(CRUTCH_BHB_THOAT_SHARD)] = {
        -- This is needed because after the Replicanum dies, there is no boss1
        [70] = "Shard", -- TODO: don't show this for Arc 2
    },
    -- Tremorscale -- no hp gates, no adds

    -- Valkynaz Nokvroz -- maybe no hp gates, but annoying magma scamps
    -- Varlariel -- clones seem to be on a timer
    -- Varzunon -- dunno
    -- Vila Theran
    -- Voidmother Elgroalif -- no hp gates? LOTS of adds (snipers, mages, boogers)
    -- Vorenor Winterbourne -- no adds. TODO: CHECK OPEN WOUNDS
    ["Vorenor Winterbourne"] = { -- TODO: localization
        [50] = "Blood Mist",
    },

    -- War Chief Ozozai -- no hp gates, no adds

    -- Xeemhok the Trophy-Taker
    ["Xeemhok the Trophy-Taker"] = { -- TODO: localization
        [50] = "Fury",
    },

    -- Yandir the Butcher -- no hp gates, HM version. fire mages, totems
    -- Yolnahkriin
    [GetBossName(CRUTCH_BHB_YOLNAHKRIIN)] = {
        [50] = "Cataclysm",
    },
    -- Ysmgar

    -- Z'Baza -- no hp gates
    -- Zhaj'hassa the Forgotten -- no hp gates?
}

---------------------------------------------------------------------
-- Separate from the other files
BHB.eaThresholds = endlessArchiveThresholds
