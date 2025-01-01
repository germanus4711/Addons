IIfA = {}

-- --------------------------------------------------------------
--	Global Variables
-- --------------------------------------------------------------
IIFA_LOCATION_KEY_BANK = "Bank"
IIFA_LOCATION_KEY_CRAFTBAG = "CraftBag"
IIFA_LOCATION_KEY_ALL = "All"
IIFA_FILTER_MENU_QUALITY_ANY = 99
IIFA_FILTER_CHARACTER_ALL = "AllCharacters"
IIFA_FILTER_SERVER_TYPE_ANY = "AnyServer"
IIFA_HOUSING_BAG_LOCATION = 98
IIFA_HOUSING_DROPDOWN_EMPTY = "None"

IIFA_CUSTOM_ICON_NONE = ""
IIFA_CUSTOM_ICON_USE_API = "Api"
IIFA_CUSTOM_ICON_DO_NOT_USE = "Skip"

IIfA.currentCharacterId = GetCurrentCharacterId()
IIfA.currentAccount = GetDisplayName()
IIfA.currentServerType = GetWorldName():gsub(" Megaserver", "")

IIfA.name = "InventoryInsight"
IIfA.displayName = "Inventory Insight"
IIfA.version = "3.84"
IIfA.authors = "AssemblerManiac, manavortex, |cff9b15Sharlikran|r"
IIfA.defaultAlertSound = nil
IIfA.colorHandler = nil
IIfA.isGuildBankReady = false
IIfA.TooltipLink = nil
IIfA.CurrSceneName = "hud"
IIfA.bFilterOnSetName = false
IIfA.fontListChoices = {}
IIfA.fontStyleChoices = {}
IIfA.fontStyleValues = {}
IIfA.houseNamesIgnored = {}
IIfA.houseNamesTracked = {}
IIfA.houseNameToIdTbl = {}
IIfA.EMPTY_STRING = ""
IIfA.BagSlotInfo = {}    -- 8-4-18 AM - make sure the table exists in case something tries to reference it before it's created.
IIfA.ScrollSortUp = true

IIfA.searchFilter = ""
IIfA.ActiveFilter = 0
IIfA.ActiveSubFilter = 0
IIfA.InventoryFilter = GetString(IIFA_LOCATION_NAME_ALL)
IIfA.InventoryListFilter = GetString(IIFA_DROPDOWN_QUALITY_MENU_ANY)
IIfA.InventoryListFilterQuality = IIFA_FILTER_MENU_QUALITY_ANY

IIfA.trackedBags = {
  [BAG_BACKPACK] = true,
  [BAG_BANK] = true,
  [BAG_COMPANION_WORN] = true,
  [BAG_GUILDBANK] = true,
  [BAG_HOUSE_BANK_ONE] = true,
  [BAG_HOUSE_BANK_TWO] = true,
  [BAG_HOUSE_BANK_THREE] = true,
  [BAG_HOUSE_BANK_FOUR] = true,
  [BAG_HOUSE_BANK_FIVE] = true,
  [BAG_HOUSE_BANK_SIX] = true,
  [BAG_HOUSE_BANK_SEVEN] = true,
  [BAG_HOUSE_BANK_EIGHT] = true,
  [BAG_HOUSE_BANK_NINE] = true,
  [BAG_HOUSE_BANK_TEN] = true,
  [BAG_SUBSCRIBER_BANK] = true,
  [BAG_VIRTUAL] = true,
  [BAG_WORN] = true,
}

IIfA.dropdownLocNames = {
  GetString(IIFA_LOCATION_NAME_ALL),
  GetString(IIFA_LOCATION_NAME_ALL_BANKS),
  GetString(IIFA_LOCATION_NAME_ALL_GUILDBANKS),
  GetString(IIFA_LOCATION_NAME_ALL_CHARACTERS),
  GetString(IIFA_LOCATION_NAME_ALL_COMPANIONS),
  GetString(IIFA_LOCATION_NAME_ALL_EQUIPPED),
  GetString(IIFA_LOCATION_NAME_ALL_STORAGE),
  GetString(IIFA_LOCATION_NAME_EVERYTHING),
  GetString(IIFA_LOCATION_NAME_BANK_ONLY),
  GetString(IIFA_LOCATION_NAME_BANK_AND_CHARACTERS),
  GetString(IIFA_LOCATION_NAME_BANK_CURRENT_CHARACTER),
  GetString(IIFA_LOCATION_NAME_BANK_OTHER_CHARACTERS),
  GetString(IIFA_LOCATION_NAME_CRAFT_BAG),
  GetString(IIFA_LOCATION_NAME_HOUSING_STORAGE),
  GetString(IIFA_LOCATION_NAME_ALL_HOUSES),
}

IIfA.dropdownLocNamesTT = {
  [GetString(IIFA_LOCATION_NAME_ALL_STORAGE)] = GetString(IIFA_LOCATION_NAME_ALL_STORAGE_TT),
  [GetString(IIFA_LOCATION_NAME_EVERYTHING)] = GetString(IIFA_LOCATION_NAME_EVERYTHING_TT),
  [GetString(IIFA_LOCATION_NAME_HOUSING_STORAGE)] = GetString(IIFA_LOCATION_NAME_HOUSING_STORAGE_TT),
}

IIFA_FURN_TOP_ID_CONSERVATORY = 12
IIFA_FURN_TOP_ID_COURTYARD = 6
IIFA_FURN_TOP_ID_DINING = 5
IIFA_FURN_TOP_ID_GALLERY = 9
IIFA_FURN_TOP_ID_HEARTH = 8
IIFA_FURN_TOP_ID_LIBRARY = 4
IIFA_FURN_TOP_ID_LIGHTING = 11
IIFA_FURN_TOP_ID_PARLOR = 3
IIFA_FURN_TOP_ID_SERVICES = 25
IIFA_FURN_TOP_ID_STRUCTURES = 13
IIFA_FURN_TOP_ID_SUITE = 2
IIFA_FURN_TOP_ID_UNDERCROFT = 7
IIFA_FURN_TOP_ID_WORKSHOP = 10

IIFA_FURN_TOP_CONSERVATORY = GetFurnitureCategoryName(IIFA_FURN_TOP_ID_CONSERVATORY)
IIFA_FURN_TOP_COURTYARD = GetFurnitureCategoryName(IIFA_FURN_TOP_ID_COURTYARD)
IIFA_FURN_TOP_DINING = GetFurnitureCategoryName(IIFA_FURN_TOP_ID_DINING)
IIFA_FURN_TOP_GALLERY = GetFurnitureCategoryName(IIFA_FURN_TOP_ID_GALLERY)
IIFA_FURN_TOP_HEARTH = GetFurnitureCategoryName(IIFA_FURN_TOP_ID_HEARTH)
IIFA_FURN_TOP_LIBRARY = GetFurnitureCategoryName(IIFA_FURN_TOP_ID_LIBRARY)
IIFA_FURN_TOP_LIGHTING = GetFurnitureCategoryName(IIFA_FURN_TOP_ID_LIGHTING)
IIFA_FURN_TOP_PARLOR = GetFurnitureCategoryName(IIFA_FURN_TOP_ID_PARLOR)
IIFA_FURN_TOP_SERVICES = GetFurnitureCategoryName(IIFA_FURN_TOP_ID_SERVICES)
IIFA_FURN_TOP_STRUCTURES = GetFurnitureCategoryName(IIFA_FURN_TOP_ID_STRUCTURES)
IIFA_FURN_TOP_SUITE = GetFurnitureCategoryName(IIFA_FURN_TOP_ID_SUITE)
IIFA_FURN_TOP_UNDERCROFT = GetFurnitureCategoryName(IIFA_FURN_TOP_ID_UNDERCROFT)
IIFA_FURN_TOP_WORKSHOP = GetFurnitureCategoryName(IIFA_FURN_TOP_ID_WORKSHOP)

-- Conservatory

IIFA_FURN_SUB_ID_CS_SAPLINGS = 141
IIFA_FURN_SUB_ID_CS_CRYSTALS = 161
IIFA_FURN_SUB_ID_CS_STONES_AND_PEBBLES = 136
IIFA_FURN_SUB_ID_CS_TREES = 108
IIFA_FURN_SUB_ID_CS_PLANTS = 109
IIFA_FURN_SUB_ID_CS_SHRUBS = 110
IIFA_FURN_SUB_ID_CS_FLOWERS = 111

IIFA_FURN_SUB_CS_SAPLINGS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_CS_SAPLINGS)
IIFA_FURN_SUB_CS_CRYSTALS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_CS_CRYSTALS)
IIFA_FURN_SUB_CS_STONES_AND_PEBBLES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_CS_STONES_AND_PEBBLES)
IIFA_FURN_SUB_CS_TREES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_CS_TREES)
IIFA_FURN_SUB_CS_PLANTS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_CS_PLANTS)
IIFA_FURN_SUB_CS_SHRUBS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_CS_SHRUBS)
IIFA_FURN_SUB_CS_FLOWERS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_CS_FLOWERS)

-- Courtyard

IIFA_FURN_SUB_ID_CY_WELLS = 72
IIFA_FURN_SUB_ID_CY_FOUNTAINS = 74
IIFA_FURN_SUB_ID_CY_POSTS_AND_PILLARS = 69
IIFA_FURN_SUB_ID_CY_VEHICLES = 71
IIFA_FURN_SUB_ID_CY_YARD_ORNAMENTS = 99
IIFA_FURN_SUB_ID_CY_STATUES = 70

IIFA_FURN_SUB_CY_WELLS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_CY_WELLS)
IIFA_FURN_SUB_CY_FOUNTAINS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_CY_FOUNTAINS)
IIFA_FURN_SUB_CY_POSTS_AND_PILLARS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_CY_POSTS_AND_PILLARS)
IIFA_FURN_SUB_CY_VEHICLES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_CY_VEHICLES)
IIFA_FURN_SUB_CY_YARD_ORNAMENTS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_CY_YARD_ORNAMENTS)
IIFA_FURN_SUB_CY_STATUES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_CY_STATUES)

-- Dining

IIFA_FURN_SUB_ID_DN_CHAIRS = 132
IIFA_FURN_SUB_ID_DN_TABLES = 66
IIFA_FURN_SUB_ID_DN_COUNTERS = 67
IIFA_FURN_SUB_ID_DN_BENCHES = 134

IIFA_FURN_SUB_DN_CHAIRS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_DN_CHAIRS)
IIFA_FURN_SUB_DN_TABLES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_DN_TABLES)
IIFA_FURN_SUB_DN_COUNTERS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_DN_COUNTERS)
IIFA_FURN_SUB_DN_BENCHES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_DN_BENCHES)

-- Gallery

IIFA_FURN_SUB_ID_GY_DISPLAY = 91
IIFA_FURN_SUB_ID_GY_THRONES = 93
IIFA_FURN_SUB_ID_GY_PAINTINGS = 54
IIFA_FURN_SUB_ID_GY_MOUNTED_DECOR = 89
IIFA_FURN_SUB_ID_GY_ART = 92
IIFA_FURN_SUB_ID_GY_ESO_PLUS = 184

IIFA_FURN_SUB_GY_DISPLAY = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_GY_DISPLAY)
IIFA_FURN_SUB_GY_THRONES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_GY_THRONES)
IIFA_FURN_SUB_GY_PAINTINGS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_GY_PAINTINGS)
IIFA_FURN_SUB_GY_MOUNTED_DECOR = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_GY_MOUNTED_DECOR)
IIFA_FURN_SUB_GY_ART = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_GY_ART)
IIFA_FURN_SUB_GY_ESO_PLUS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_GY_ESO_PLUS)

-- Hearth

IIFA_FURN_SUB_ID_HT_BASKETS_AND_BAGS = 87
IIFA_FURN_SUB_ID_HT_MEATS_AND_CHEESES = 155
IIFA_FURN_SUB_ID_HT_GAME = 86
IIFA_FURN_SUB_ID_HT_BREADS_AND_DESSERTS = 156
IIFA_FURN_SUB_ID_HT_UTENSILS = 82
IIFA_FURN_SUB_ID_HT_COOKWARE = 151
IIFA_FURN_SUB_ID_HT_PRODUCE = 154
IIFA_FURN_SUB_ID_HT_MEALS = 85
IIFA_FURN_SUB_ID_HT_DRINKWARE = 144
IIFA_FURN_SUB_ID_HT_LAUNDRY = 153
IIFA_FURN_SUB_ID_HT_STOCKROOM = 84
IIFA_FURN_SUB_ID_HT_DISHES = 81
IIFA_FURN_SUB_ID_HT_CABINETRY = 83
IIFA_FURN_SUB_ID_HT_POTTERY = 80

IIFA_FURN_SUB_HT_BASKETS_AND_BAGS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_HT_BASKETS_AND_BAGS)
IIFA_FURN_SUB_HT_MEATS_AND_CHEESES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_HT_MEATS_AND_CHEESES)
IIFA_FURN_SUB_HT_GAME = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_HT_GAME)
IIFA_FURN_SUB_HT_BREADS_AND_DESSERTS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_HT_BREADS_AND_DESSERTS)
IIFA_FURN_SUB_HT_UTENSILS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_HT_UTENSILS)
IIFA_FURN_SUB_HT_COOKWARE = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_HT_COOKWARE)
IIFA_FURN_SUB_HT_PRODUCE = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_HT_PRODUCE)
IIFA_FURN_SUB_HT_MEALS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_HT_MEALS)
IIFA_FURN_SUB_HT_DRINKWARE = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_HT_DRINKWARE)
IIFA_FURN_SUB_HT_LAUNDRY = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_HT_LAUNDRY)
IIFA_FURN_SUB_HT_STOCKROOM = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_HT_STOCKROOM)
IIFA_FURN_SUB_HT_DISHES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_HT_DISHES)
IIFA_FURN_SUB_HT_CABINETRY = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_HT_CABINETRY)
IIFA_FURN_SUB_HT_POTTERY = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_HT_POTTERY)

-- Library

IIFA_FURN_SUB_ID_LB_LITERATURE = 62
IIFA_FURN_SUB_ID_LB_DESKS = 61
IIFA_FURN_SUB_ID_LB_SHELVES = 60
IIFA_FURN_SUB_ID_LB_SUPPLIES = 63

IIFA_FURN_SUB_LB_LITERATURE = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_LB_LITERATURE)
IIFA_FURN_SUB_LB_DESKS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_LB_DESKS)
IIFA_FURN_SUB_LB_SHELVES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_LB_SHELVES)
IIFA_FURN_SUB_LB_SUPPLIES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_LB_SUPPLIES)

-- Lighting

IIFA_FURN_SUB_ID_LT_CANDLES = 129
IIFA_FURN_SUB_ID_LT_BRAZIERS = 124
IIFA_FURN_SUB_ID_LT_FIRES = 127
IIFA_FURN_SUB_ID_LT_LANTERNS = 121
IIFA_FURN_SUB_ID_LT_CHANDELIERS = 125
IIFA_FURN_SUB_ID_LT_LIGHTPOSTS = 122
IIFA_FURN_SUB_ID_LT_LAMPS = 120
IIFA_FURN_SUB_ID_LT_ENCHANTED_LIGHTS = 126
IIFA_FURN_SUB_ID_LT_SCONCES = 123

IIFA_FURN_SUB_LT_CANDLES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_LT_CANDLES)
IIFA_FURN_SUB_LT_BRAZIERS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_LT_BRAZIERS)
IIFA_FURN_SUB_LT_FIRES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_LT_FIRES)
IIFA_FURN_SUB_LT_LANTERNS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_LT_LANTERNS)
IIFA_FURN_SUB_LT_CHANDELIERS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_LT_CHANDELIERS)
IIFA_FURN_SUB_LT_LIGHTPOSTS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_LT_LIGHTPOSTS)
IIFA_FURN_SUB_LT_LAMPS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_LT_LAMPS)
IIFA_FURN_SUB_LT_ENCHANTED_LIGHTS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_LT_ENCHANTED_LIGHTS)
IIFA_FURN_SUB_LT_SCONCES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_LT_SCONCES)

-- Parlor

IIFA_FURN_SUB_ID_PL_TEA_TABLES = 59
IIFA_FURN_SUB_ID_PL_RUGS_AND_CARPETS = 53
IIFA_FURN_SUB_ID_PL_VASES = 57
IIFA_FURN_SUB_ID_PL_SOFAS_AND_COUCHES = 133
IIFA_FURN_SUB_ID_PL_BANNERS = 58
IIFA_FURN_SUB_ID_PL_KNICK_KNACKS = 56
IIFA_FURN_SUB_ID_PL_TAPESTRIES = 52
IIFA_FURN_SUB_ID_PL_INSTRUMENTS = 55

IIFA_FURN_SUB_PL_TEA_TABLES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_PL_TEA_TABLES)
IIFA_FURN_SUB_PL_RUGS_AND_CARPETS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_PL_RUGS_AND_CARPETS)
IIFA_FURN_SUB_PL_VASES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_PL_VASES)
IIFA_FURN_SUB_PL_SOFAS_AND_COUCHES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_PL_SOFAS_AND_COUCHES)
IIFA_FURN_SUB_PL_BANNERS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_PL_BANNERS)
IIFA_FURN_SUB_PL_KNICK_KNACKS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_PL_KNICK_KNACKS)
IIFA_FURN_SUB_PL_TAPESTRIES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_PL_TAPESTRIES)
IIFA_FURN_SUB_PL_INSTRUMENTS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_PL_INSTRUMENTS)

-- Services

IIFA_FURN_SUB_ID_SV_TRAINING_DUMMIES = 98
IIFA_FURN_SUB_ID_SV_CRAFTING_STATIONS = 104
IIFA_FURN_SUB_ID_SV_HOUSEGUESTS = 189

IIFA_FURN_SUB_SV_TRAINING_DUMMIES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_SV_TRAINING_DUMMIES)
IIFA_FURN_SUB_SV_CRAFTING_STATIONS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_SV_CRAFTING_STATIONS)
IIFA_FURN_SUB_SV_HOUSEGUESTS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_SV_HOUSEGUESTS)

-- Structures

IIFA_FURN_SUB_ID_ST_BLOCKS = 115
IIFA_FURN_SUB_ID_ST_DOORWAYS = 163
IIFA_FURN_SUB_ID_ST_WALLS_AND_FENCES = 164
IIFA_FURN_SUB_ID_ST_PLATFORMS = 138
IIFA_FURN_SUB_ID_ST_BUILDING_COMPONENTS = 117
IIFA_FURN_SUB_ID_ST_TENTS = 114
IIFA_FURN_SUB_ID_ST_BUILDINGS = 185

IIFA_FURN_SUB_ST_BLOCKS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_ST_BLOCKS)
IIFA_FURN_SUB_ST_DOORWAYS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_ST_DOORWAYS)
IIFA_FURN_SUB_ST_WALLS_AND_FENCES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_ST_WALLS_AND_FENCES)
IIFA_FURN_SUB_ST_PLATFORMS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_ST_PLATFORMS)
IIFA_FURN_SUB_ST_BUILDING_COMPONENTS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_ST_BUILDING_COMPONENTS)
IIFA_FURN_SUB_ST_TENTS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_ST_TENTS)
IIFA_FURN_SUB_ST_BUILDINGS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_ST_BUILDINGS)

-- Suite

IIFA_FURN_SUB_ID_SU_MIRRORS = 50
IIFA_FURN_SUB_ID_SU_DRESSERS = 146
IIFA_FURN_SUB_ID_SU_PILLOWS = 51
IIFA_FURN_SUB_ID_SU_BEDDING = 46
IIFA_FURN_SUB_ID_SU_DIVIDERS = 47
IIFA_FURN_SUB_ID_SU_NIGHTSTANDS = 145
IIFA_FURN_SUB_ID_SU_WARDROBES = 48
IIFA_FURN_SUB_ID_SU_BATHING_GOODS = 176
IIFA_FURN_SUB_ID_SU_TRUNKS = 49

IIFA_FURN_SUB_SU_MIRRORS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_SU_MIRRORS)
IIFA_FURN_SUB_SU_DRESSERS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_SU_DRESSERS)
IIFA_FURN_SUB_SU_PILLOWS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_SU_PILLOWS)
IIFA_FURN_SUB_SU_BEDDING = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_SU_BEDDING)
IIFA_FURN_SUB_SU_DIVIDERS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_SU_DIVIDERS)
IIFA_FURN_SUB_SU_NIGHTSTANDS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_SU_NIGHTSTANDS)
IIFA_FURN_SUB_SU_WARDROBES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_SU_WARDROBES)
IIFA_FURN_SUB_SU_BATHING_GOODS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_SU_BATHING_GOODS)
IIFA_FURN_SUB_SU_TRUNKS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_SU_TRUNKS)

-- Undercroft

IIFA_FURN_SUB_ID_UC_BASINS = 137
IIFA_FURN_SUB_ID_UC_REMAINS = 75
IIFA_FURN_SUB_ID_UC_TORTURE = 77
IIFA_FURN_SUB_ID_UC_INCENSE = 105
IIFA_FURN_SUB_ID_UC_URNS = 78
IIFA_FURN_SUB_ID_UC_SYMBOLIC_DECOR = 106
IIFA_FURN_SUB_ID_UC_SOUL_GEMS = 199
IIFA_FURN_SUB_ID_UC_GRAVE_GOODS = 76
IIFA_FURN_SUB_ID_UC_SACRED_PIECES = 107

IIFA_FURN_SUB_UC_BASINS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_UC_BASINS)
IIFA_FURN_SUB_UC_REMAINS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_UC_REMAINS)
IIFA_FURN_SUB_UC_TORTURE = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_UC_TORTURE)
IIFA_FURN_SUB_UC_INCENSE = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_UC_INCENSE)
IIFA_FURN_SUB_UC_URNS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_UC_URNS)
IIFA_FURN_SUB_UC_SYMBOLIC_DECOR = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_UC_SYMBOLIC_DECOR)
IIFA_FURN_SUB_UC_SOUL_GEMS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_UC_SOUL_GEMS)
IIFA_FURN_SUB_UC_GRAVE_GOODS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_UC_GRAVE_GOODS)
IIFA_FURN_SUB_UC_SACRED_PIECES = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_UC_SACRED_PIECES)

-- Workshop

IIFA_FURN_SUB_ID_WS_PIPES_AND_MECHANISMS = 159
IIFA_FURN_SUB_ID_WS_MATERIALS = 97
IIFA_FURN_SUB_ID_WS_TOOLS = 96
IIFA_FURN_SUB_ID_WS_MACHINERY = 170
IIFA_FURN_SUB_ID_WS_CARGO = 95
IIFA_FURN_SUB_ID_WS_STOOLS = 135

IIFA_FURN_SUB_WS_PIPES_AND_MECHANISMS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_WS_PIPES_AND_MECHANISMS)
IIFA_FURN_SUB_WS_MATERIALS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_WS_MATERIALS)
IIFA_FURN_SUB_WS_TOOLS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_WS_TOOLS)
IIFA_FURN_SUB_WS_MACHINERY = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_WS_MACHINERY)
IIFA_FURN_SUB_WS_CARGO = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_WS_CARGO)
IIFA_FURN_SUB_WS_STOOLS = GetFurnitureCategoryName(IIFA_FURN_SUB_ID_WS_STOOLS)

------------------------------
--- Debugging              ---
------------------------------

IIfA.show_log = false
IIfA.loggerName = 'InventoryInsight'
if LibDebugLogger then
  IIfA.logger = LibDebugLogger.Create(IIfA.loggerName)
end

local logger
local viewer
if DebugLogViewer then viewer = true else viewer = false end
if LibDebugLogger then logger = true else logger = false end

local function create_log(log_type, log_content)
  if not viewer and log_type == "Info" then
    CHAT_ROUTER:AddSystemMessage(log_content)
    return
  end
  if not IIfA.show_log then return end
  if logger and log_type == "Debug" then
    IIfA.logger:Debug(log_content)
  end
  if logger and log_type == "Info" then
    IIfA.logger:Info(log_content)
  end
  if logger and log_type == "Verbose" then
    IIfA.logger:Verbose(log_content)
  end
  if logger and log_type == "Warn" then
    IIfA.logger:Warn(log_content)
  end
end

local function emit_message(log_type, text)
  if (text == "") then
    text = "[Empty String]"
  end
  create_log(log_type, text)
end

local function emit_table(log_type, t, indent, table_history)
  indent = indent or "."
  table_history = table_history or {}

  if not t then
    emit_message(log_type, indent .. "[Nil Table]")
    return
  end

  if next(t) == nil then
    emit_message(log_type, indent .. "[Empty Table]")
    return
  end

  for k, v in pairs(t) do
    local vType = type(v)

    emit_message(log_type, indent .. "(" .. vType .. "): " .. tostring(k) .. " = " .. tostring(v))

    if (vType == "table") then
      if (table_history[v]) then
        emit_message(log_type, indent .. "Avoiding cycle on table...")
      else
        table_history[v] = true
        emit_table(log_type, v, indent .. "  ", table_history)
      end
    end
  end
end

local function emit_userdata(log_type, udata)
  local function_limit = 5  -- Limit the number of functions displayed
  local total_limit = 10   -- Total number of entries to display (functions + non-functions)
  local function_count = 0  -- Counter for functions
  local entry_count = 0     -- Counter for total entries displayed

  emit_message(log_type, "Userdata: " .. tostring(udata))

  local meta = getmetatable(udata)
  if meta and meta.__index then
    for k, v in pairs(meta.__index) do
      -- Show function name for functions
      if type(v) == "function" then
        if function_count < function_limit then
          emit_message(log_type, "  Function: " .. tostring(k))  -- Function name
          function_count = function_count + 1
          entry_count = entry_count + 1
        end
      elseif type(v) ~= "function" then
        -- For non-function entries (like tables or variables), show them
        emit_message(log_type, "  " .. tostring(k) .. ": " .. tostring(v))
        entry_count = entry_count + 1
      end

      -- Stop when we've reached the total limit
      if entry_count >= total_limit then
        emit_message(log_type, "  ... (output truncated due to limit)")
        break
      end
    end
  else
    emit_message(log_type, "  (No detailed metadata available)")
  end
end

local function contains_placeholders(str)
  return type(str) == "string" and str:find("<<%d+>>")
end

function IIfA:dm(log_type, ...)
  local num_args = select("#", ...)
  local first_arg = select(1, ...)  -- The first argument is always the message string

  -- Check if the first argument is a string with placeholders
  if type(first_arg) == "string" and contains_placeholders(first_arg) then
    -- Extract any remaining arguments for zo_strformat (after the message string)
    local remaining_args = { select(2, ...) }

    -- Format the string with the remaining arguments
    local formatted_value = ZO_CachedStrFormat(first_arg, unpack(remaining_args))

    -- Emit the formatted message
    emit_message(log_type, formatted_value)
  else
    -- Process other argument types (userdata, tables, etc.)
    for i = 1, num_args do
      local value = select(i, ...)
      if type(value) == "userdata" then
        emit_userdata(log_type, value)
      elseif type(value) == "table" then
        emit_table(log_type, value)
      else
        emit_message(log_type, tostring(value))
      end
    end
  end
end
