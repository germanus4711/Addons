ESODBExportConst = {}

ESODBExportConst.OpenUrlWebsite = "https://www.eso-database.com/"

ESODBExportConst.SupportedLanguages = {
	"en",
	"de",
	"fr",
	"es",
	"ru",
}

-- Tradeskill types
ESODBExportConst.Tradeskills = {
	CRAFTING_TYPE_ALCHEMY,
	CRAFTING_TYPE_BLACKSMITHING,
	CRAFTING_TYPE_CLOTHIER,
	CRAFTING_TYPE_ENCHANTING,
	CRAFTING_TYPE_JEWELRYCRAFTING,
	CRAFTING_TYPE_PROVISIONING,
	CRAFTING_TYPE_WOODWORKING,
}

-- Tradeskill writ types
ESODBExportConst.TradeskillWrits = {
	CRAFTING_WRIT_NONE = 0,
	CRAFTING_WRIT_ALCHEMIST = 1,
	CRAFTING_WRIT_BLACKSMITH = 2,
	CRAFTING_WRIT_CLOTHIER = 3,
	CRAFTING_WRIT_ENCHANTER = 4,
	CRAFTING_WRIT_PROVISIONER = 5,
	CRAFTING_WRIT_WOODWORKER = 6,
	CRAFTING_WRIT_JEWELRYCRAFTING =  7
}

-- Allowed research types
ESODBExportConst.TradeskillResearchTypes = {
	[CRAFTING_TYPE_BLACKSMITHING] = true,
	[CRAFTING_TYPE_CLOTHIER] = true,
	[CRAFTING_TYPE_JEWELRYCRAFTING] = true,
	[CRAFTING_TYPE_WOODWORKING] = true
}

-- Allowed collectible categories
ESODBExportConst.CollectionsCategoryTypes = {
	[COLLECTIBLE_CATEGORY_TYPE_ABILITY_FX_OVERRIDE] = true,
	[COLLECTIBLE_CATEGORY_TYPE_ASSISTANT] = true,
	[COLLECTIBLE_CATEGORY_TYPE_BODY_MARKING] = true,
	[COLLECTIBLE_CATEGORY_TYPE_COSTUME] = true,
	[COLLECTIBLE_CATEGORY_TYPE_EMOTE] = true,
	[COLLECTIBLE_CATEGORY_TYPE_FACIAL_ACCESSORY] = true,
	[COLLECTIBLE_CATEGORY_TYPE_FACIAL_HAIR_HORNS] = true,
	[COLLECTIBLE_CATEGORY_TYPE_FURNITURE] = true,
	[COLLECTIBLE_CATEGORY_TYPE_HAIR] = true,
	[COLLECTIBLE_CATEGORY_TYPE_HAT] = true,
	[COLLECTIBLE_CATEGORY_TYPE_HEAD_MARKING] = true,
	[COLLECTIBLE_CATEGORY_TYPE_HOUSE] = true,
	[COLLECTIBLE_CATEGORY_TYPE_HOUSE_BANK] = true,
	[COLLECTIBLE_CATEGORY_TYPE_MEMENTO] = true,
	[COLLECTIBLE_CATEGORY_TYPE_MOUNT] = true,
	[COLLECTIBLE_CATEGORY_TYPE_OUTFIT_STYLE] = true,
	[COLLECTIBLE_CATEGORY_TYPE_PERSONALITY] = true,
	[COLLECTIBLE_CATEGORY_TYPE_PIERCING_JEWELRY] = true,
	[COLLECTIBLE_CATEGORY_TYPE_POLYMORPH] = true,
	[COLLECTIBLE_CATEGORY_TYPE_SKIN] = true,
	[COLLECTIBLE_CATEGORY_TYPE_VANITY_PET] = true,
	[COLLECTIBLE_CATEGORY_TYPE_COMBINATION_FRAGMENT] = true,
	[COLLECTIBLE_CATEGORY_TYPE_COMPANION] = true,
	[COLLECTIBLE_CATEGORY_TYPE_PLAYER_FX_OVERRIDE] = true,
	[COLLECTIBLE_CATEGORY_TYPE_ABILITY_FX_OVERRIDE] = true,
}

ESODBExportConst.Alchemy = {
	Reagents = {
		30165,
		30158,
		30155,
		30152,
		30162,
		30148,
		30149,
		30161,
		30160,
		30154,
		30157,
		30151,
		30164,
		30159,
		30163,
		30153,
		30156,
		30166,
		77581,
		77583,
		77584,
		77585,
		77587,
		77589,
		77590,
		77591,
		139019,
		139020,
		150731,
		150789,
		150789,
		150671,
		150672,
		150670,
		150669,
	},
	TraitNames = {
		["de"] = {
			["leben wiederherstellen"] = 1,
			["lebensverwüstung"] = 2,
			["magicka wiederherstellen"] = 3,
			["magickaverwüstung"] = 4,
			["ausdauer wiederherstellen"] = 5,
			["ausdauerverwüstung"] = 6,
			["erhöht waffenkraft"] = 7,
			["verkrüppeln"] = 8,
			["erhöht magiekraft"] = 9,
			["feigheit"] = 10,
			["kritische waffentreffer"] = 11,
			["schwäche"] = 12,
			["kritische magietreffer"] = 13,
			["ungewissheit"] = 14,
			["erhöht rüstung"] = 15,
			["fraktur"] = 16,
			["erhöht magieresistenz"] = 17,
			["bruch"] = 18,
			["sicherer stand"] = 19,
			["einfangen"] = 20,
			["tempo"] = 21,
			["einschränken"] = 22,
			["unsichtbarkeit"] = 23,
			["detektion"] = 24,
			["beständige heilung"] = 25,
			["langsame lebensverwüstung"] = 26,
			["vitalität"] = 27,
			["verwundbarkeit"] = 28,
			["schutz"] = 29,
			["schänden"] = 30,
			["heldentum"] = 31,
			["scheu"] = 32,
		},
		["en"] = {
			["restore health"] = 1,
			["ravage health"] = 2,
			["restore magicka"] = 3,
			["ravage magicka"] = 4,
			["restore stamina"] = 5,
			["ravage stamina"] = 6,
			["increase weapon power"] = 7,
			["maim"] = 8,
			["increase spell power"] = 9,
			["cowardice"] = 10,
			["weapon critical"] = 11,
			["enervation"] = 12,
			["spell critical"] = 13,
			["uncertainty"] = 14,
			["increase armor"] = 15,
			["fracture"] = 16,
			["increase spell resist"] = 17,
			["breach"] = 18,
			["unstoppable"] = 19,
			["entrapment"] = 20,
			["speed"] = 21,
			["hindrance"] = 22,
			["invisible"] = 23,
			["detection"] = 24,
			["lingering health"] = 25,
			["gradual ravage health"] = 26,
			["vitality"] = 27,
			["vulnerability"] = 28,
			["protection"] = 29,
			["defile"] = 30,
			["heroism"] = 31,
			["timidity"] = 32,
		},
		["fr"] = {
			["rend de la santé"] = 1,
			["réduit la santé"] = 2,
			["rend de la magie"] = 3,
			["réduit la magie"] = 4,
			["rend de la vigueur"] = 5,
			["ravage de vigueur"] = 6,
			["augmente la puissance de l'arme"] = 7,
			["mutilation"] = 8,
			["augmente la puissance des sorts"] = 9,
			["couardise"] = 10,
			["critique d'armes"] = 11,
			["affaiblissement"] = 12,
			["critique de sorts"] = 13,
			["incertitude"] = 14,
			["augmente l'armure"] = 15,
			["fracture"] = 16,
			["augmente la résistance aux sorts"] = 17,
			["brèche"] = 18,
			["implacable"] = 19,
			["capture"] = 20,
			["vitesse"] = 21,
			["entrave"] = 22,
			["invisible"] = 23,
			["de détection"] = 24,
			["santé persistante"] = 25,
			["ravage de santé graduel"] = 26,
			["vitalité"] = 27,
			["vulnérabilité"] = 28,
			["protection"] = 29,
			["profanation"] = 30,
			["héroïsme"] = 31,
			["timidité"] = 32,
		},
		["es"] = {
			["restauración de salud"] = 1,
			["reducción de salud"] = 2,
			["restauración de magia"] = 3,
			["reducción de magia"] = 4,
			["restauración de aguante"] = 5,
			["reducción de aguante"] = 6,
			["aumento del poder físico"] = 7,
			["mutilación"] = 8,
			["aumento de potencia mágica"] = 9,
			["cobardía"] = 10,
			["crítico físico"] = 11,
			["enervación"] = 12,
			["crítico mágico"] = 13,
			["incertidumbre"] = 14,
			["aumento de armadura"] = 15,
			["fractura"] = 16,
			["aumento de resistencia a hechizos"] = 17,
			["fisura"] = 18,
			["imparable"] = 19,
			["captura"] = 20,
			["velocidad"] = 21,
			["torpeza"] = 22,
			["invisible"] = 23,
			["detección"] = 24,
			["salud prolongada"] = 25,
			["deterioro de salud gradual"] = 26,
			["vitalidad"] = 27,
			["vulnerabilidad"] = 28,
			["protección"] = 29,
			["profanación"] = 30,
			["heroísmo"] = 31,
			["timidez"] = 32,
		},
		["ru"] = {
			["восстановление здоровья"] = 1,
			["опустошение здоровья"] = 2,
			["восстановление магии"] = 3,
			["опустошение магии"] = 4,
			["восстановление запаса сил"] = 5,
			["опустошение запаса сил"] = 6,
			["увеличение силы оружия"] = 7,
			["повреждение"] = 8,
			["увеличение силы заклинаний"] = 9,
			["трусость"] = 10,
			["крит. рейтинг оружия"] = 11,
			["бессилие"] = 12,
			["крит. рейтинг заклинаний"] = 13,
			["неуверенность"] = 14,
			["увеличение показателя брони"] = 15,
			["перелом"] = 16,
			["увеличение магической сопротивляемости"] = 17,
			["прорыв"] = 18,
			["неудержимость"] = 19,
			["захват"] = 20,
			["скорость"] = 21,
			["замедление"] = 22,
			["невидимость"] = 23,
			["обнаружение"] = 24,
			["длительное исцеление"] = 25,
			["постепенное опустошение здоровья"] = 26,
			["живучесть"] = 27,
			["уязвимость"] = 28,
			["защита"] = 29,
			["осквернение"] = 30,
			["героизм"] = 31,
			["трусливость"] = 32,
		},
	}
}

ESODBExportConst.Enchanting = {
	Runes = {
		45855,
		45856,
		45857,
		45806,
		45807,
		45808,
		45809,
		45810,
		45811,
		45812,
		45813,
		45814,
		45815,
		45816,
		45817,
		45818,
		45819,
		45820,
		45821,
		45822,
		45823,
		45824,
		45825,
		45826,
		45827,
		45828,
		45829,
		45830,
		64508,
		64509,
		68340,
		68341,
		45831,
		45832,
		45833,
		45834,
		45835,
		45836,
		45837,
		45838,
		45839,
		45840,
		45841,
		45842,
		45843,
		45846,
		45847,
		45848,
		45849,
		68342,
		45850,
		45851,
		45852,
		45853,
		45854,
		166045,
	}
}

ESODBExportConst.MundusAbilityIds = {
	13979,
	13982,
	13976,
	13978,
	13981,
	13943,
	13980,
	13974,
	13984,
	13977,
	13975,
	13985,
	13940,
}

ESODBExportConst.POIEventType = {
	NONE = 0,
	DARK_ANCHOR = 1,
	ABYSSAL_GEYSERS = 2,
	HARROWSTORM = 3,
	VOLCANIC_VENT = 4,
	MIRRORMOOR_INCURSION = 5,
}

ESODBExportConst.WritQuestNames = {
	[ESODBExportConst.TradeskillWrits.CRAFTING_WRIT_ALCHEMIST] = {
		["en"] = "alchemist writ",
		["de"] = "alchemistenschrieb",
		["fr"] = "commande d'alchimie",
		["es"] = "encargo de alquimia",
		["ru"] = "заказ для алхимиков",
	},
	[ESODBExportConst.TradeskillWrits.CRAFTING_WRIT_BLACKSMITH] = {
		["en"] = "blacksmith writ",
		["de"] = "schmiedeschrieb",
		["fr"] = "commande de forge",
		["es"] = "encargo de herrería",
		["ru"] = "заказ для кузнецов",
	},
	[ESODBExportConst.TradeskillWrits.CRAFTING_WRIT_CLOTHIER] = {
		["en"] = "clothier writ",
		["de"] = "schneiderschrieb",
		["fr"] = "commande de tailleur",
		["es"] = "encargo de sastrería",
		["ru"] = "заказ для портных",
	},
	[ESODBExportConst.TradeskillWrits.CRAFTING_WRIT_ENCHANTER] = {
		["en"] = "enchanter writ",
		["de"] = "verzaubererschrieb",
		["fr"] = "commandes d'enchantement",
		["es"] = "encargo de encantamiento",
		["ru"] = "заказ для зачарователей",
	},
	[ESODBExportConst.TradeskillWrits.CRAFTING_WRIT_PROVISIONER] = {
		["en"] = "provisioner writ",
		["de"] = "versorgerschrieb",
		["fr"] = "commande de cuisine",
		["es"] = "encargo de cocina",
		["ru"] = "заказ для снабженцев",
	},
	[ESODBExportConst.TradeskillWrits.CRAFTING_WRIT_WOODWORKER] = {
		["en"] = "woodworker writ",
		["de"] = "schreinerschrieb",
		["fr"] = "commande de travail du bois",
		["es"] = "encargo de carpintería",
		["ru"] = "заказ для столяров",
	},
	[ESODBExportConst.TradeskillWrits.CRAFTING_WRIT_JEWELRYCRAFTING] = {
		["en"] = "jewelry crafting writ",
		["de"] = "schmuckhandwerksschrieb",
		["fr"] = "commande de joaillerie",
		["es"] = "encargo de joyería",
		["ru"] = "заказ для ювелиров",
	},
}

ESODBExportConst.WorthyRewardMailSubjects = {
	["en"] = "rewards for the worthy!",
	["de"] = "gerechter lohn!",
	["fr"] = "la récompense des dignes !",
	["es"] = "¡eecompensa por el mérito!",
	["ru"] = "награда достойным!",
}

ESODBExportConst.GuildStoreNames = {
	["en"] = "guild store",
	["de"] = "gildenladen",
	["fr"] = "boutique de guilde",
	["es"] = "tienda del gremio",
	["ru"] = "магазин гильдии",
}

ESODBExportConst.SlaughterfishAttackStatusStrings = {
	["en"] = "slaughterfish attack",
	["de"] = "schlachterfischangriff",
	["fr"] = "attaque de poissons carnassiers",
	["es"] = "ataque de pez asesino",
	["ru"] = "атака рыбы-убийцы",
}

ESODBExportConst.PsijikPortalNames = {
	["en"] = "psijic portal",
	["de"] = "psijik-portal",
	["fr"] = "portail psijique",
	["es"] = "portal psijic",
	["ru"] = "портал псиджиков",
}

ESODBExportConst.ThievesTroveNames = {
	["en"] = "thieves trove",
	["de"] = "diebesgut",
	["fr"] = "trésor des voleurs",
	["es"] = "tesoro de los ladrones",
	["ru"] = "воровской тайник",
}

ESODBExportConst.HeavySackNames = {
	["en"] = "heavy sack",
	["de"] = "schwerer sack",
	["fr"] = "sac lourd",
	["es"] = "saco pesado",
	["ru"] = "тяжелый мешок",
}

ESODBExportConst.Currencies = {
	Account = {
		CURT_CHAOTIC_CREATIA,
		CURT_ENDLESS_DUNGEON,
		CURT_EVENT_TICKETS,
		CURT_CROWNS,
		CURT_CROWN_GEMS,
		CURT_ENDEAVOR_SEALS,
		CURT_UNDAUNTED_KEYS,
		CURT_STYLE_STONES,
	},
	Bank = {
		CURT_MONEY,
		CURT_ALLIANCE_POINTS,
		CURT_TELVAR_STONES,
		CURT_WRIT_VOUCHERS,
	},
	Character = {
		CURT_MONEY,
		CURT_ALLIANCE_POINTS,
		CURT_TELVAR_STONES,
		CURT_WRIT_VOUCHERS,
	},
}

ESODBExportConst.BattlegroundWinnerStatus = {
	WINNER = 1,
	LOSER = 2,
}
