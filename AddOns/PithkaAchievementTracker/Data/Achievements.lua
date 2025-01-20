PITHKA = PITHKA or {}
PITHKA.Data = PITHKA.Data or {}
PITHKA.Data.Achievements = {}



PITHKA.Data.Achievements.DB = {
    -- Trials
    {NAME="Hel Ra Citadel",         ABBV="HRC", VET=1474, PHM1=nil,  PHM1NAME="",         PHM2=nil,  PHM2NAME="",        HM=1136,  HMNAME="Celest. Warrior", TRI=nil,  TRINAME="",                    EXT=nil,  EXTNAME="",                      DLC=false,   LBINDEX=1,   portID= 230,  TYPE="trial"},
    {NAME="Aetherian Archive",      ABBV="AA",  VET=1503, PHM1=nil,  PHM1NAME="",         PHM2=nil,  PHM2NAME="",        HM=1137,  HMNAME="Celest. Mage",    TRI=nil,  TRINAME="",                    EXT=nil,  EXTNAME="",                      DLC=false,   LBINDEX=2,   portID= 231,  TYPE="trial"},
    {NAME="Sanctum Ophidia",        ABBV="SO",  VET=1462, PHM1=nil,  PHM1NAME="",         PHM2=nil,  PHM2NAME="",        HM=1138,  HMNAME="Celest. Serpent", TRI=nil,  TRINAME="",                    EXT=nil,  EXTNAME="",                      DLC=false,   LBINDEX=3,   portID= 232,  TYPE="trial"},
    {NAME="Maw of Lorkhaj",         ABBV="MOL", VET=1368, PHM1=nil,  PHM1NAME="",         PHM2=nil,  PHM2NAME="",        HM=1344,  HMNAME="Rakkhat",         TRI=nil,  TRINAME="",                    EXT=1391, EXTNAME="Dro-m'Athra Destroyer", DLC=true,    LBINDEX=5,   portID= 258,  TYPE="trial"},
    {NAME="Halls of Fabrication",   ABBV="HOF", VET=1810, PHM1=nil,  PHM1NAME="",         PHM2=nil,  PHM2NAME="",        HM=1829,  HMNAME="Assembly Gen.",   TRI=1838, TRINAME="Tick-Tock Tormentor", EXT=1836, EXTNAME="The Dynamo",            DLC=true,    LBINDEX=7,   portID= 331,  TYPE="trial"},
    {NAME="Asylum Sanctorium",      ABBV="AS",  VET=2077, PHM1=2085, PHM1NAME="+Llothis", PHM2=2086, PHM2NAME="+Felms",  HM=2079,  HMNAME="vAS +2",          TRI=2087, TRINAME="Saintly Savior",      EXT=2075, EXTNAME="Immortal Redeemer",     DLC=true,    LBINDEX=8,   portID= 346,  TYPE="trial"},
    {NAME="Cloudrest",              ABBV="CR",  VET=2133, PHM1=2134, PHM1NAME="vCR +1",   PHM2=2135, PHM2NAME="vCR +2",  HM=2136,  HMNAME="vCR +3",          TRI=2139, TRINAME="Gryphon Heart",       EXT=2140, EXTNAME="Welkynar Liberator",    DLC=true,    LBINDEX=9,   portID= 364,  TYPE="trial"},

    {NAME="Sunspire",               ABBV="SS",  VET=2435, PHM1=2469, PHM1NAME="Yolna",    PHM2=2470, PHM2NAME="Lokke",   HM=2466,  HMNAME="Nahvi",           TRI=2467, TRINAME="Godslayer",           EXT=2468, EXTNAME="Hand of Alkosh",        DLC=true,    LBINDEX=12,  portID= 399,  TYPE="trial"},
    {NAME="Kyne's Aegis",           ABBV="KA",  VET=2734, PHM1=2736, PHM1NAME="Yandir",   PHM2=2737, PHM2NAME="Vrol",    HM=2739,  HMNAME="Falgravn",        TRI=2740, TRINAME="Kyne's Wrath",        EXT=2746, EXTNAME="Dawnbringer",           DLC=true,    LBINDEX=13,  portID= 434,  TYPE="trial"},
    {NAME="Rockgrove",              ABBV="RG",  VET=2987, PHM1=3005, PHM1NAME="Oaxiltso", PHM2=3006, PHM2NAME="Bahsei",  HM=3007,  HMNAME="Xalvakka",        TRI=3003, TRINAME="Planesbreaker",       EXT=3004, EXTNAME="Daedric Bane",          DLC=true,    LBINDEX=15,  portID= 468,  TYPE="trial"},
    {NAME="Dreadsail Reef",         ABBV="DSR", VET=3244, PHM1=3250, PHM1NAME="Twins",    PHM2=3251, PHM2NAME="Reef",    HM=3252,  HMNAME="Taleria",         TRI=3248, TRINAME="Soul of the Squall",  EXT=3249, EXTNAME="Swashbuckler Supreme",  DLC=true,    LBINDEX=16,  portID= 488,  TYPE="trial"},
    {NAME="Sanity's Edge",          ABBV="SE",  VET=3560, PHM1=3566, PHM1NAME="Yaseyla",  PHM2=3567, PHM2NAME="Twelvane",HM=3568,  HMNAME="Ansuul",          TRI=3564, TRINAME="Dream Master",        EXT=3565, EXTNAME="Mindmender",            DLC=true,    LBINDEX=17,  portID= 534,  TYPE="trial"},
    {NAME="Lucent Citadel",         ABBV="LC",  VET=4015, PHM1=4021, PHM1NAME="Count",    PHM2=4022, PHM2NAME="Orphic",  HM=4023,  HMNAME="Arcane Knot",     TRI=4019, TRINAME="Unstoppable",         EXT=4020, EXTNAME="Arcane Stabilizer",     DLC=true,    LBINDEX=18,  portID= 568,  TYPE="trial"},

    -- Arenas   
    {NAME="Dragonstar Arena",       ABBV="DSA",  VET=1140, TRI=nil,   TRINAME="",                   EXT=nil,  EXTNAME="",                      DLC=false,   LBINDEX=4,   portID= 270,  TYPE="arena"},    
    {NAME="Blackrose Prison",       ABBV="BRP",  VET=2363, TRI=2368,  TRINAME="Unchained",          EXT=2372, EXTNAME="A Thrilling Trifecta",  DLC=false,   LBINDEX=11,   portID= 378,  TYPE="arena"},
    {NAME="Maelstrom Arena",        ABBV="MSA",  VET=1305, TRI=nil,   TRINAME=nil,                  EXT=nil,  EXTNAME="",                      DLC=false,   LBINDEX=6,  portID= 250,  TYPE="arena"},
    --{NAME="Maelstrom",              ABBV="MSA",  VET=1305, TRI=1330,  TRINAME="Flawless Conqueror", EXT=nil,  EXTNAME="",                      DLC=false,   LB2INDEX=1,  portID= 250,  TYPE="arena"},
    {NAME="Vateshran Arena",        ABBV="VSA",  VET=2908, TRI=2912,  TRINAME="Spirit Slayer",      EXT=2913, EXTNAME="Hero of Undying Song",  DLC=true,    LBINDEX=14,  portID= 457,  TYPE="arena"},    

    -- Infinity Archive
    {NAME="Solo",                   ABBV="EA1",  VET=nil, TRI=nil,  TRINAME=nil,      EXT=nil, EXTNAME=nil,  DLC=true,    ENDLESSLBINDEX=0, GROUPTYPE = 0, portID= 550,  TYPE="endless"}, -- Oct 30, 2023
    {NAME="Duo",                    ABBV="EA2",  VET=nil, TRI=nil,  TRINAME=nil,      EXT=nil, EXTNAME=nil,  DLC=true,    ENDLESSLBINDEX=0, GROUPTYPE = 1, portID= 550,  TYPE="endless"}, -- Oct 30, 2023

    -- DLC Dungeons
    {NAME = "White Gold Tower",     ABBV="WGT", VET = 1120,  CHA = nil,  HM = 1279, SR = 1275, ND = 1276, TRI = nil , TRINAME = nil,                      EXT = 1306, EXTNAME = "Out of the Frying Pan",  vQueue = 287,  nQueue = 288,  portID = 247, TYPE="no_tri_dungeon"},
    {NAME = "Imperial City Prison", ABBV="ICP", VET = 880,   CHA = 1132, HM = 1303, SR = 1128, ND = 1129, TRI = nil , TRINAME = nil,                      EXT = 1133, EXTNAME = "Out of Sight",           vQueue = 268,  nQueue = 289,  portID = 236, TYPE="no_tri_dungeon"},
    {NAME = "Ruins of Mazzatun",    ABBV="ROM", VET = 1505,  CHA = 1511, HM = 1506, SR = 1507, ND = 1508, TRI = nil , TRINAME = nil,                      EXT = 1516, EXTNAME = "Obedience Training",     vQueue = 294,  nQueue = 293,  portID = 260, TYPE="no_tri_dungeon"},
    {NAME = "Cradle of Shadows",    ABBV="COS", VET = 1523,  CHA = 1529, HM = 1524, SR = 1525, ND = 1526, TRI = nil , TRINAME = nil,                      EXT = 1534, EXTNAME = "Embrace the Shadow",     vQueue = 296,  nQueue = 295,  portID = 261, TYPE="no_tri_dungeon"},
    {NAME = "Falkreath Hold",       ABBV="FH",  VET = 1699,  CHA = 1942, HM = 1704, SR = 1702, ND = 1703, TRI = nil , TRINAME = nil,                      EXT = 1948, EXTNAME = "Epic Undertaking",       vQueue = 369,  nQueue = 368,  portID = 332, TYPE="no_tri_dungeon"},
    {NAME = "Bloodroot Forge",      ABBV="BF",  VET = 1691,  CHA = 1941, HM = 1696, SR = 1694, ND = 1695, TRI = nil , TRINAME = nil,                      EXT = 1819, EXTNAME = "Wildlife Sanctuary",     vQueue = 325,  nQueue = 224,  portID = 326, TYPE="no_tri_dungeon"},
    {NAME = "Fang Lair",            ABBV="FL",  VET = 1960,  CHA = 1966, HM = 1965, SR = 1963, ND = 1964, TRI = 2102, TRINAME = "Leave No Bone Unbroken", EXT = 1967, EXTNAME = "Minimal Animosity",      vQueue = 421,  nQueue = 420,  portID = 341, TYPE="dungeon"},
    {NAME = "Scalecaller Peak",     ABBV="SP",  VET = 1976,  CHA = 1982, HM = 1981, SR = 1979, ND = 1980, TRI = 1983, TRINAME = "Mountain God",           EXT = 1991, EXTNAME = "Daedric Deflector",      vQueue = 419,  nQueue = 418,  portID = 363, TYPE="dungeon"},
    {NAME = "Moon Hunter Keep",     ABBV="MHK", VET = 2153,  CHA = 2158, HM = 2154, SR = 2155, ND = 2156, TRI = 2159, TRINAME = "Pure Lunacy",            EXT = 2301, EXTNAME = "Strangling Cowardice",   vQueue = 427,  nQueue = 426,  portID = 371, TYPE="dungeon"},
    {NAME = "March of Sacrifices",  ABBV="MOS", VET = 2163,  CHA = 2167, HM = 2164, SR = 2165, ND = 2166, TRI = 2168, TRINAME = "Apex Predator",          EXT = 2305, EXTNAME = "Mist Walker",            vQueue = 429,  nQueue = 428,  portID = 370, TYPE="dungeon"},
    {NAME = "Frostvault",           ABBV="FV",  VET = 2261,  CHA = 2266, HM = 2262, SR = 2263, ND = 2264, TRI = 2267, TRINAME = "Relentless Raider",      EXT = 2384, EXTNAME = "Cold Potato",            vQueue = 434,  nQueue = 433,  portID = 389, TYPE="dungeon"},
    {NAME = "Depths of Malatar",    ABBV="DOM", VET = 2271,  CHA = 2275, HM = 2272, SR = 2273, ND = 2274, TRI = 2276, TRINAME = "Depths Defier",          EXT = 2395, EXTNAME = "Lackluster",             vQueue = 436,  nQueue = 435,  portID = 390, TYPE="dungeon"},
    {NAME = "Lair of Maarselok",    ABBV="LOM", VET = 2426,  CHA = 2430, HM = 2427, SR = 2428, ND = 2429, TRI = 2431, TRINAME = "Nature's Wrath",         EXT = 2581, EXTNAME = "Shagrath's Shield",      vQueue = 497,  nQueue = 496,  portID = 398, TYPE="dungeon"},
    {NAME = "Moongrave Fane",       ABBV="MF",  VET = 2416,  CHA = 2421, HM = 2417, SR = 2418, ND = 2419, TRI = 2422, TRINAME = "Defanged the Devourer",  EXT = 2575, EXTNAME = "Drop the Block",         vQueue = 495,  nQueue = 494,  portID = 391, TYPE="dungeon"},
    {NAME = "Icereach",             ABBV="IR",  VET = 2540,  CHA = 2545, HM = 2541, SR = 2542, ND = 2543, TRI = 2546, TRINAME = "Storm Foe",              EXT = 2677, EXTNAME = "Prodigous Pacification", vQueue = 504,  nQueue = 503,  portID = 424, TYPE="dungeon"},
    {NAME = "Unhallowed Grave",     ABBV="UG",  VET = 2550,  CHA = 2554, HM = 2551, SR = 2552, ND = 2553, TRI = 2555, TRINAME = "Bonecaller's Bane",      EXT = 2679, EXTNAME = "Relentless Dogcatcher",  vQueue = 506,  nQueue = 505,  portID = 425, TYPE="dungeon"},
    {NAME = "Stone Garden",         ABBV="SG",  VET = 2695,  CHA = 2700, HM = 2755, SR = 2697, ND = 2698, TRI = 2701, TRINAME = "True Genius",            EXT = 2824, EXTNAME = "Old Fashioned",          vQueue = 508,  nQueue = 507,  portID = 435, TYPE="dungeon"},
    {NAME = "Castle Thorn",         ABBV="CT",  VET = 2705,  CHA = 2709, HM = 2706, SR = 2707, ND = 2708, TRI = 2710, TRINAME = "Bane of Thorns",         EXT = 2828, EXTNAME = "Guardian Preserved",     vQueue = 510,  nQueue = 509,  portID = 436, TYPE="dungeon"},
    {NAME = "Black Drake Villa",    ABBV="BDV", VET = 2832,  CHA = 2837, HM = 2833, SR = 2834, ND = 2835, TRI = 2838, TRINAME = "Ardent Bibliophile",     EXT = 2883, EXTNAME = "Salley-oop",             vQueue = 592,  nQueue = 591,  portID = 437, TYPE="dungeon"},
    {NAME = "The Cauldron",         ABBV="TC",  VET = 2842,  CHA = 2846, HM = 2843, SR = 2844, ND = 2845, TRI = 2847, TRINAME = "Subterranean Smasher",   EXT = 2886, EXTNAME = "Can't Catch Me",         vQueue = 594,  nQueue = 593,  portID = 454, TYPE="dungeon"},
    {NAME = "Red Petal Bastion",    ABBV="RPB", VET = 3017,  CHA = 3022, HM = 3018, SR = 3019, ND = 3020, TRI = 3023, TRINAME = "of the Silver Rose",     EXT = 3035, EXTNAME = "Terror Billy",           vQueue = 596,  nQueue = 595,  portID = 470, TYPE="dungeon"},
    {NAME = "Dread Cellar",         ABBV="DC",  VET = 3027,  CHA = 3031, HM = 3028, SR = 3029, ND = 3030, TRI = 3032, TRINAME = "the Dreaded",            EXT = 3042, EXTNAME = "Settling Scores",        vQueue = 598,  nQueue = 597,  portID = 469, TYPE="dungeon"},    
    {NAME = "Coral Aerie",          ABBV="CA",  VET = 3105,  CHA = 3110, HM = 3153, SR = 3107, ND = 3108, TRI = 3111, TRINAME = "Coral Caretaker",        EXT = 3226, EXTNAME = "Tentacless Triumph",     vQueue = 600,  nQueue = 599,  portID = 497, TYPE="dungeon"},
    {NAME = "Shipwright's Regret",  ABBV="SR",  VET = 3115,  CHA = 3119, HM = 3154, SR = 3117, ND = 3118, TRI = 3120, TRINAME = "Privateer",              EXT = 3224, EXTNAME = "Sans Spirit Support",    vQueue = 602,  nQueue = 601,  portID = 498, TYPE="dungeon"},
    {NAME = "Earthen Root Enclave", ABBV="ERE", VET = 3376,  CHA = 3380, HM = 3377, SR = 3378, ND = 3379, TRI = 3381, TRINAME = "Invaders' Bane",         EXT = 3391, EXTNAME = "Scourge of Archdruid",   vQueue = 609,  nQueue = 608,  portID = 520, TYPE="dungeon"},
    {NAME = "Graven Deep",          ABBV="GD",  VET = 3395,  CHA = 3399, HM = 3396, SR = 3397, ND = 3398, TRI = 3400, TRINAME = "Fist of Tava",           EXT = 3410, EXTNAME = "Pressure in the Deep",   vQueue = 611,  nQueue = 610,  portID = 521, TYPE="dungeon"},
    {NAME = "Bal Sunnar",           ABBV="BS",  VET = 3469,  CHA = 3473, HM = 3470, SR = 3471, ND = 3472, TRI = 3474, TRINAME = "Temporal Tempest",       EXT = 3484, EXTNAME = "No Time to Waste",       vQueue = 614,  nQueue = 613,  portID = 531, TYPE="dungeon"},
    {NAME = "Scrivener's Hall",     ABBV="SH",  VET = 3530,  CHA = 3534, HM = 3531, SR = 3532, ND = 3533, TRI = 3535, TRINAME = "Curator's Champion",     EXT = 3538, EXTNAME = "Harsh Edit",             vQueue = 616,  nQueue = 615,  portID = 532, TYPE="dungeon"},
    {NAME = "Oathsworn Pit",        ABBV="OP",  VET = 3811,  CHA = 3815, HM = 3812, SR = 3813, ND = 3814, TRI = 3816, TRINAME = "Oathsworn",              EXT = 3826, EXTNAME = "Dogged Avenger",         vQueue = 618,  nQueue = 617,  portID = 556, TYPE="dungeon"},
    {NAME = "Bedlam Veil",          ABBV="BV",  VET = 3852,  CHA = 3856, HM = 3853, SR = 3854, ND = 3855, TRI = 3857, TRINAME = "Bedlam's Desciple",      EXT = 3867, EXTNAME = "Martial Gift",           vQueue = 620,  nQueue = 619,  portID = 565, TYPE="dungeon"},
    {NAME = "Exiled Redoudt",       ABBV="ER",  VET = 4110,  CHA = 4114, HM = 4111, SR = 4112, ND = 4113, TRI = 4115, TRINAME = "Revenge Breaker",        EXT = 4120, EXTNAME = "Exposed to the Elements",vQueue = 856,  nQueue = 855,  portID = 581, TYPE="dungeon"},
    {NAME = "Lep Seclusa",          ABBV="LS",  VET = 4129,  CHA = 4133, HM = 4130, SR = 4131, ND = 4132, TRI = 4134, TRINAME = "Sic Semper",             EXT = 4139, EXTNAME = "Fight the Darkness",     vQueue = 858,  nQueue = 857,  portID = 582, TYPE="dungeon"},



    {NAME = "Blackrose Prison ",    ABBV="BRP", VET = 2363,  CHA = nil,  HM = 2364, SR = 2366, ND = 2365, TRI = 2368, TRINAME = "Unchained",              EXT = 2372, EXTNAME = "A Thrilling Trifecta",   vQueue = nil,  nQueue = nil,  portID = 378, TYPE="dungeon"},
                            -- added trailing space to BRP dungeon name as a hack to prevent multirow lookups in Scores:line64
    -- Base Game Dungeons

    {NAME = "Fungal Grotto I",      ABBV="FG1",  VET=1556, HM = 1561,   SR = 1559,   ND = 1560,  TYPE='baseDungeon', portID=98,  nQueue=2,   vQueue=299,  n=1},
    {NAME = "Fungal Grotto II",     ABBV="FG2",  VET=343,  HM = 342,    SR = 340,    ND = 1563,  TYPE='baseDungeon', portID=266, nQueue=18,  vQueue=312,  n=2},
    {NAME = "Banished Cells I",     ABBV="BC1",  VET=1549, HM = 1554,   SR = 1552,   ND = 1553,  TYPE='baseDungeon', portID=194, nQueue=4,   vQueue=20,   n=1},
    {NAME = "Banished Cells II",    ABBV="BC2",  VET=545,  HM = 451,    SR = 449,    ND = 1564,  TYPE='baseDungeon', portID=262, nQueue=300, vQueue=301,  n=2},
    {NAME = "Elden Hollow I",       ABBV="EH1",  VET=1573, HM = 1578,   SR = 1576,   ND = 1577,  TYPE='baseDungeon', portID=191, nQueue=7,   vQueue=23,   n=1},
    {NAME = "Elden Hollow II",      ABBV="EH2",  VET=459,  HM = 463,    SR = 461,    ND = 1580,  TYPE='baseDungeon', portID=265, nQueue=303, vQueue=302,  n=2},
    {NAME = "City of Ash I",        ABBV="COA1", VET=1597, HM = 1602,   SR = 1600,   ND = 1601,  TYPE='baseDungeon', portID=197, nQueue=10,  vQueue=310,  n=1},
    {NAME = "City of Ash II",       ABBV="COA2", VET=878,  HM = 1114,   SR = 1108,   ND = 1107,  TYPE='baseDungeon', portID=268, nQueue=322, vQueue=267,  n=2},
    {NAME = "Crypt of Hearts I",    ABBV="COH1", VET=1610, HM = 1615,   SR = 1613,   ND = 1614,  TYPE='baseDungeon', portID=190, nQueue=9,   vQueue=261,  n=1},
    {NAME = "Crypt of Hearts II",   ABBV="COH2", VET=876,  HM = 1084,   SR = 941,    ND = 942 ,  TYPE='baseDungeon', portID=269, nQueue=317, vQueue=318,  n=2},
    {NAME = "Darkshade Caverns I",  ABBV="DC1",  VET=1581, HM = 1586,   SR = 1584,   ND = 1585,  TYPE='baseDungeon', portID=198, nQueue=5,   vQueue=309,  n=1},
    {NAME = "Darkshade Caverns II", ABBV="DC2",  VET=464,  HM = 467,    SR = 465,    ND = 1588,  TYPE='baseDungeon', portID=264, nQueue=308, vQueue=21,   n=2},
    {NAME = "Spindleclutch I",      ABBV="SC1",  VET=1565, HM = 1570,   SR = 1568,   ND = 1569,  TYPE='baseDungeon', portID=193, nQueue=3,   vQueue=315,  n=1},
    {NAME = "Spindleclutch II",     ABBV="SC2",  VET=421,  HM = 448,    SR = 446,    ND = 1572,  TYPE='baseDungeon', portID=267, nQueue=316, vQueue=19,   n=2},
    {NAME = "Wayrest Sewers I",     ABBV="WS1",  VET=1589, HM = 1594,   SR = 1592,   ND = 1593,  TYPE='baseDungeon', portID=189, nQueue=6,   vQueue=306,  n=1},
    {NAME = "Wayrest Sewers II",    ABBV="WS2",  VET=678,  HM = 681,    SR = 679,    ND = 1596,  TYPE='baseDungeon', portID=263, nQueue=22,  vQueue=307,  n=2},
    {NAME = "Arx Corinium",         ABBV="AC",   VET=1604, HM = 1609,   SR = 1607,   ND = 1608,  TYPE='baseDungeon', portID=192, nQueue=8,   vQueue=305,  n=0},
    {NAME = "Blackheart Haven",     ABBV="BH",   VET=1647, HM = 1652,   SR = 1650,   ND = 1651,  TYPE='baseDungeon', portID=186, nQueue=15,  vQueue=321,  n=0},
    {NAME = "Blessed Crucible",     ABBV="BC",   VET=1641, HM = 1646,   SR = 1644,   ND = 1645,  TYPE='baseDungeon', portID=187, nQueue=14,  vQueue=320,  n=0},
    {NAME = "Direfrost Keep",       ABBV="DK",   VET=1623, HM = 1628,   SR = 1626,   ND = 1627,  TYPE='baseDungeon', portID=195, nQueue=11,  vQueue=319,  n=0},
    {NAME = "Selene's Web",         ABBV="SW",   VET=1635, HM = 1640,   SR = 1638,   ND = 1639,  TYPE='baseDungeon', portID=185, nQueue=16,  vQueue=313,  n=0},
    {NAME = "Tempest Island",       ABBV="TI",   VET=1617, HM = 1622,   SR = 1620,   ND = 1621,  TYPE='baseDungeon', portID=188, nQueue=13,  vQueue=311,  n=0},
    {NAME = "Vaults of Madness",    ABBV="VOM",  VET=1653, HM = 1658,   SR = 1656,   ND = 1657,  TYPE='baseDungeon', portID=184, nQueue=17,  vQueue=314,  n=0},
    {NAME = "Volenfell",            ABBV="VOL",  VET=1629, HM = 1634,   SR = 1632,   ND = 1633,  TYPE='baseDungeon', portID=196, nQueue=12,  vQueue=304,  n=0},
} 


PITHKA.Data.Achievements.DBFilter = function(query, col, customFn)
    local customFn = customFn or function() return true end
    local output = {}    
    for _, row in ipairs(PITHKA.Data.Achievements.DB) do 
        local test = true
        for key, value in pairs(query) do
            test = test and row[key] == value
        end
        if test and customFn() then 
            table.insert(output, row) 
        end
    end

    -- if col is passed, return array of values
    if col then
        local tmp = {}
        for _, row in ipairs(output) do
            table.insert(tmp, row[col])
        end
        output = tmp
    end

    -- if length of table is 0 return nil
    if table.getn(output) == 0 then
        return nil
    end

    -- if length of table is 1 remove table wrapper -- just return row or value
    if table.getn(output) == 1 then
        output = output[1]
    end
    
    return output
end