-------------------------------------------------
-- Russian localization for Dustman, by Asdolg --
-------------------------------------------------

local strings = {
    --style materials submenu
    DUSTMAN_STYLE_MATERIALS = "Материалы стиля",
    --item traits submenu
    DUSTMAN_ITEM_TRAITS = "Материалы особенностей снаряжения",
    --weapons & armors & jewelry submenu
    DUSTMAN_WEAP_ARM_JEWL = "Оружие, доспехи и юв. изделия",
    --weapons & armors submenu and jewelry submenu
    DUSTMAN_WEAP_ARM = "Оружие и доспехи",
    DUSTMAN_EQUIP_NOTRAIT = "Помечать снаряжение без особенностей",
    DUSTMAN_EQUIP_NOTRAIT_DESC_WA = "Включить/отключить механизм, который помечает оружие и доспехи (которые можно надеть) без особенности как хлам.",
    DUSTMAN_EQUIP_NOTRAIT_DESC_J = "Включить/отключить механизм, который помечает ювелирные изделия без особенностей как хлам.",
    DUSTMAN_EQUIPMENT = "Помечать надеваемые оружие и доспехи",
    DUSTMAN_EQUIPMENT_DESC_WA = "Включить/отключить механизм, который помечает оружие и доспехи (которые можно надеть) как хлам.",
    DUSTMAN_EQUIPMENT_DESC_J = "Включить/отключить механизм, который помечает ювелирные изделия, которые можно надеть, как хлам.",
    DUSTMAN_ORNATE = "Помечать снаряжение с Ornate",
    DUSTMAN_ORNATE_DESC_WA = "Включить/отключить механизм, который помечает оружие и доспехи с особенностью Ornate как хлам.",
    DUSTMAN_ORNATE_DESC_J = "Включить/отключить механизм, который помечает ювелирные изделия с особенностью Ornate как хлам.",
    DUSTMAN_WHITE_ZERO = "Помечать предметы с нулевым значением",
    DUSTMAN_WHITE_ZERO_DESC_WA = "Включить/отключить механизм, который помечает оружие и доспехи с нулевым нормальным качеством как хлам.",
    DUSTMAN_WHITE_ZERO_DESC_J = "Включить/отключить механизм, который помечает ювелирные изделия с нулевым нормальным качеством как хлам.",
    DUSTMAN_INTRICATE = "Исключить снаряж. с особен. Intricate",
    DUSTMAN_INTRICATE_DESC_WA = "Если включено, аддон никогда не будет помечать оружие и доспехи с особенностью Intricate как хлам.",
    DUSTMAN_INTRICATE_DESC_J = "Если включено, аддон никогда не будет помечать ювелирные изделия с особенностью Intricate как хлам.",
    DUSTMAN_INTRIC_MAX = "Только если нужно повысить ремесл. навык",
    DUSTMAN_INTRIC_MAX_DESC_WA = "Если включено, аддон будет исключать оружие и доспехи с особенностью Intricate только если они нужны вам, чтобы поднять уровень ремесленного навыка.",
    DUSTMAN_INTRIC_MAX_DESC_J = "Если включено, аддон будет исключать ювелирные изделия с особенностью Intricate только если они нужны вам, чтобы поднять уровень ремесленного навыка.",
    DUSTMAN_RESEARCH = "Искл. снаряж. с изучаемой особенностью",
    DUSTMAN_RESEARCH_DESC_WA = "Если включено, аддон никогда не пометит оружие и доспехи с особенностями, которые можно изучить, как хлам.",
    DUSTMAN_RESEARCH_DESC_J = "Если включено, аддон никогда не пометит ювелирные изделия с особенностями, которые можно изучить, как хлам.",
    DUSTMAN_NIRNHONED = "Исключить снаряж. с особенностью Nirnhoned",
    DUSTMAN_NIRNHONED_DESC = "Если включено, аддон никогда не пометит оружие и доспехи с особенностью Nirnhoned как хлам.",
    DUSTMAN_SET = "Исключить снаряжение из наборов",
    DUSTMAN_SET_DESC_WA = "Если включено, аддон никогда не пометит оружие и доспехи с бонусом от набора как хлам.",
    DUSTMAN_SET_DESC_J = "Если включено, аддон никогда не пометит ювелирные изделия с бонусом от набора как хлам.",
    DUSTMAN_LEVEL = "Исключить снаряж. уровня >=",
    DUSTMAN_LEVEL_DESC_WA = "Если включено, аддон никогда не будет помечать оружие и доспехи со значением выше нуля и уровнем (или рангом чемпиона), равным этому значению или выше него.",
    DUSTMAN_LEVEL_DESC_J = "Если включено, аддон никогда не будет помечать ювелирные изделия со значением выше нуля и уровнем (или рангом чемпиона), равным этому значению или выше него.",
    DUSTMAN_LEVEL_ORNATE = "Всегда помечать предм. Ornate с макс. ур.",
    DUSTMAN_LEVEL_ORNATE_DESC_WA = "Если включено, аддон всегда будет помечать оружие и доспехи с особенностью Ornate с уровнем (или рангом чемпиона), равным выбранному значению или выше него.",
    DUSTMAN_LEVEL_ORNATE_DESC_J = "Если включено, аддон всегда будет помечать ювелирные изделия с особенностью Ornate с уровнем (или рангом чемпиона), равным выбранному значению или выше него.",
    DUSTMAN_TRAITSSETS = "Помечать предметы из наборов с этими особен. как хлам",
    DUSTMAN_TRAITSSETS_DESC = "Если включено, аддон будет помечать предметы из наборов с выбранными ниже особенностями.",
    DUSTMAN_SET_ARENA = "Исключить оружие с арен",
    DUSTMAN_SET_ARENA_DESC = "Если включено, аддон никогда не будет помечать оружие с арен (Арена Драгонстара, Вихревая Арена, Тюрьма Черная Роза) как хлам.",
    DUSTMAN_SET_BG = "Исключить наборы с полей сражений",
    DUSTMAN_SET_BG_DESC_WA = "Если включено, аддон никогда не будет помечать оружие и доспехи из наборов полей сражений как хлам.",
    DUSTMAN_SET_BG_DESC_J = "Если включено, аддон никогда не будет помечать ювелирные изделия из наборов полей сражений как хлам.",
    DUSTMAN_SET_CRAFTED = "Исключить снаряж. из ремесленных наборов",
    DUSTMAN_SET_CRAFTED_DESC_WA = "Если включено, аддон никогда не будет помечать созданные через ремесло оружие и доспехи (например, Дар Магнуса, Пепельная Хватка, и т.д.) как хлам.",
    DUSTMAN_SET_CRAFTED_DESC_J = "Если включено, аддон никогда не будет помечать созданные через ремесло ювелирные изделия (например, Дар Магнуса, Пепельная Хватка, и т.д.) как хлам.",
    DUSTMAN_SET_CYRO_A = "Exclude Cyrodiil armor sets", --TO TRANSLATE
    DUSTMAN_SET_CYRO_W = "Exclude Cyrodiil weapon sets", --TO TRANSLATE
    DUSTMAN_SET_CYRO_DESC_A = "If enabled, addon will never mark Cyrodill armors (e.g Deadly Strike, Warrior's Fury, etc..) as junk.", --TO TRANSLATE
    DUSTMAN_SET_CYRO_DESC_W = "If enabled, addon will never mark Cyrodill weapons (e.g Deadly Strike, Warrior's Fury, etc..) as junk.", --TO TRANSLATE
    DUSTMAN_SET_CYRO_J = "Exclude Cyrodiil sets", --TO TRANSLATE
    DUSTMAN_SET_CYRO_DESC_J = "If enabled, addon will never mark Cyrodiil jewelry (e.g Deadly Strike, Warrior's Fury, etc..) as junk.", --TO TRANSLATE
    DUSTMAN_SET_RANDIC = "Исключить наборы RD и IC",
    DUSTMAN_SET_RANDIC_DESC = "Если включено, аддон никогда не будет помечать ювелирные изделия из наборов случайных данжей (RD) и Имперского Города (IC) (Выносливость, Сила воли, Ловкость) как хлам.",
    DUSTMAN_SET_DUNG = "Исключить наборы из данжей",
    DUSTMAN_SET_DUNG_DESC_WA = "Если включено, аддон никогда не будет помечать оружие и доспехи из наборов данжей(например, Опека Йорвульда, Кровавая Луна, и т.д.) как хлам.",
    DUSTMAN_SET_DUNG_DESC_J = "Если включено, аддон никогда не будет помечать ювелирные изделия из наборов данжей (например, Опека Йорвульда, Кровавая Луна, и т.д.) как хлам.",
    DUSTMAN_SET_IC = "Исключить наборы Имперского Города",
    DUSTMAN_SET_IC_DESC_WA = "Если включено, аддон никогда не будет помечать оружие и доспехи из наборов Имперского Города (например, Феникс, Имперское Телосложение, и т.д.) как хлам.",
    DUSTMAN_SET_IC_DESC_J = "Если включено, аддон никогда не будет помечать ювелирные изделия из наборов Имперского Города (например, Феникс, Имперское Телосложение, и т.д.) как хлам.",
    DUSTMAN_SET_MS = "Исключить наборы чудовищ",
    DUSTMAN_SET_MS_DESC = "Если включено, аддон никогда не будет помечать снаряжение из наборов чудовищ (например, Иламбрис, Ледяное Сердце, и т.д.) как хлам.",
    DUSTMAN_SET_OVERLAND = "Исключить наборы поверхности",
    DUSTMAN_SET_OVERLAND_DESC_WA = "Если включено, аддон никогда не будет помечать оружие и доспехи из наборов поверхности (например, Некропотенс, Вересковое Сердце, и т.д.) как хлам.",
    DUSTMAN_SET_OVERLAND_DESC_J = "Если включено, аддон никогда не будет помечать ювелирные изделия из наборов поверхности (например, Некропотенс, Вересковое Сердце, и т.д.) как хлам.",
    DUSTMAN_SET_SPEC = "Исключить особые наборы",
    DUSTMAN_SET_SPEC_DESC_WA = "Если включено, аддон никогда не будет помечать особое оружие и доспехи (Пророк, Сломленная Душа из наград за повышение уровня) как хлам.",
    DUSTMAN_SET_SPEC_DESC_J = "Если включено, аддон никогда не будет помечать особые ювелирные изделия (Сломленная Душа из наград за повышение уровня) как хлам.",
    DUSTMAN_SET_TRIAL = "Исключить наборы за испытания",
    DUSTMAN_SET_TRIAL_DESC_WA = "Если включено, аддон никогда не будет помечать оружие и доспехи из наборов за испытания (например, Лунный Танцор, Воин-Берсерк, и т.д.) как хлам.",
    DUSTMAN_SET_TRIAL_DESC_J = "Если включено, аддон никогда не будет помечать ювелирные изделия из наборов за испытания (например, Лунный Танцор, Воин-Берсерк, и т.д.) как хлам.",
    DUSTMAN_DISGUISES = "Помечать маскировку",
    DUSTMAN_DISGUISES_DESC = "Включить/отключить механизм, помечающий маскировочную одежду как хлам.",
    DUSTMAN_DISGUISES_DESTROY = "...и уничтожать её!",
    DUSTMAN_DISGUISES_DESTROY_DESC = "Автоматически уничтожать маскировочную одежду.",
    --provisioning submenu
    DUSTMAN_INGR_ALL = "Помечать все ингридиенты снабжения",
    DUSTMAN_INGR_ALL_DESC = "Включить/отключить механизм, помечающий все ингридиенты снабжения как хлам.",
    DUSTMAN_INGR_UNUS = "Помечать неиспользуемые ингридиенты снабжения",
    DUSTMAN_INGR_UNUS_DESC = "Включить/отключить механизм, помечающий ингридиенты снабжения, которые нельзя использовать, как хлам.",
    DUSTMAN_INGR_DISH = "Включить для ингридентов блюд",
    DUSTMAN_INGR_DISH_DESC = "Включить фильтр для ингридиентов блюд (бонусы к характеристикам)",
    DUSTMAN_INGR_DRINK = "Включить для ингридиентов напитков",
    DUSTMAN_INGR_DRINK_DESC = "Включить фильтр для ингридиентов напитков (восстановление характеристик)",
    DUSTMAN_INGR_RARE = "Исключить редкие приправы",
    DUSTMAN_INGR_RARE_DESC = "Исключить |H1:item:26802:28:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h, |H1:item:27059:28:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h и |H1:item:64222:29:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h.",
    DUSTMAN_RECIPE = "Помечать изученные рецепты",
    DUSTMAN_RECIPE_DESC = "Включить/отключить механизм, помечающий известные рецепты снабжения как хлам.",
    --crafting materials submenu
    DUSTMAN_CRAFTING_MATERIALS = "Ремесленные материалы",
    DUSTMAN_CRAFTING_BLACKSMITHING_DESC = "Включить/отключить механизм, помечающий низкоуровневые материалы для кузнечного ремесла (только |H0:item:64489:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h не будет помечен)",
    DUSTMAN_CRAFTING_RAW_BLACKSMITHING_DESC = "Включить/отключить механизм, помечающий низкоуровневое сырьё для кузнечного ремесла (только |H0:item:71198:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h не будет помечен)",
    DUSTMAN_CRAFTING_CLOTHING_DESC = "Включить/отключить механизм, помечающий низкоуровневые материалы для портняжного ремесла (только |H0:item:64504:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h и |H0:item:64506:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h не будут помечены)",
    DUSTMAN_CRAFTING_RAW_CLOTHING_DESC = "Включить/отключить механизм, помечающий никозуровневое сырьё для портняжного ремесла (только |H0:item:71200:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h и |H0:item:71239:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h не будут помечены)",
    DUSTMAN_CRAFTING_WOODWORKING_DESC = "Включить/отключить механизм, помечающий низкоуровневые материалы для столярного ремесла (только |H0:item:64502:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h не будет помечен)",
    DUSTMAN_CRAFTING_RAW_WOODWORKING_DESC = "Включить/отключить механизм, помечающий никозуровневое сырьё для столярного ремесла (только |H0:item:71199:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h не будет помечен)",
    DUSTMAN_CRAFTING_JEWELRY_DESC = "Включить/отключить механизм, помечающий низкоуровневые материалы для ювелирного ремесла (только |H0:item:135146:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h не будет помечен)",
    DUSTMAN_CRAFTING_RAW_JEWELRY_DESC = "Включить/отключить механизм, помечающий никозуровневое сырьё для ювелирного ремесла (только |H0:item:135145:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h не будет помечен)",
    --furnishing submenu
    DUSTMAN_FURNISHING_MATERIALS = "Материалы предметов обстановки",
    DUSTMAN_ALCHRESIN = "Алхимическая смола",
    DUSTMAN_BAST = "Луб",
    DUSTMAN_CLEANPELT = "Чистая шкура",
    DUSTMAN_DECWAX = "Декоративный воск",
    DUSTMAN_HEARTWOOD = "Ядровая древесина",
    DUSTMAN_MUNDRUNE = "Мирская руна",
    DUSTMAN_OCHRE = "Охра",
    DUSTMAN_REGULUS = "Королёк",
    --enchanting submenu
    DUSTMAN_GLYPHS = "Помечать найденные глифы",
    DUSTMAN_GLYPHS_DESC = "Включить/отключить механизм, помечающий найденные глифы (т.е. НЕ созданные при помощи ремесла)",
    DUSTMAN_LEVELGLYPH = "Исключить глифы уровня >=",
    DUSTMAN_LEVELGLYPH_DESC = "Если включено, аддон никогда не будет помечать найденные глифы со значением выше нуля и уровнем или рангом чемпиона, равным этому значению или выше него.",
    DUSTMAN_ASPECT_RUNES = "Помечать руны аспекта",
    DUSTMAN_ASPECT_RUNES_DESC = "Включить/отключить механизм, помечающий руны аспекта как хлам.",
    DUSTMAN_ESSENCE_RUNES = "Mark essence runes",
    DUSTMAN_ESSENCE_RUNES_DESC = "Enable/disable marking of essence runes as junk.",
    DUSTMAN_POTENCY_RUNES = "Mark potency runes",
    DUSTMAN_POTENCY_RUNES_DESC = "Enable/disable marking of potency runes as junk.",
    --consumables submenu
    DUSTMAN_FOOD_ALL = "Помечать всю еду и все напитки",
    DUSTMAN_FOOD_ALL_DESC = "Включить/отключить механизм, помечающий всю еду и все напитки как хлам.",
    DUSTMAN_POTIONS = "Помечать найденные зелья",
    DUSTMAN_POTIONS_DESC = "Включить/отключить механизм, помечающий найденные (т.е. не созданные при помощи ремесла) зелья как хлам.",
    DUSTMAN_LEVELPOTIONS = "Исключить зелья уровнем >=",
    DUSTMAN_LEVELPOTIONS_DESC = "Если включено, аддон никогда не будет помечать найденные зелья со значением выше нуля и уровнем или рангом чемпиона, равным этому значению или выше него.",
    DUSTMAN_POISONS = "Помечать найденные яды",
    DUSTMAN_POISONS_DESC = "Включить/отключить механизм, помечающий найденные (т.е. не созданные при помощи ремесла) яды как хлам.",
    DUSTMAN_POISONS_SOLVANTS = "Помечать растворители для ядов",
    DUSTMAN_POISONS_SOLVANTS_DESC = "Включить/отключить механизм, помечающий растворители для ядов как хлам.",
    DUSTMAN_LEVELPOISONS = "Исключить яды уровнем >=",
    DUSTMAN_LEVELPOISONS_DESC = "Если включено, аддон никогда не будет помечать найденные яды со значением выше нуля и уровнем или рангом чемпиона, равным этому значению или выше него.",
    DUSTMAN_EMPTYGEMS = "Помечать пустые Камни Душ",
    DUSTMAN_EMPTYGEMS_DESC = "Включить/отключить механизм, помечающий пустые Камни Душ как хлам.",
    DUSTMAN_TREASURE_MAPS = "Помечать карты сокровищ",
    DUSTMAN_TREASURE_MAPS_DESC = "Включить/отключить механизм, помечающий карты сокровищ как хлам.",
    DUSTMAN_TREASURE_MAPS_DESTROY = "...и уничтожать их!",
    DUSTMAN_TREASURE_MAPS_DESTROY_DESC = "Автоматически уничтожать карты сокровищ.",
    DUSTMAN_JEWELRY_MASTER_WRITS = "Destroy Jewelry Master Writs", --TO TRANSLATE
    DUSTMAN_JEWELRY_MASTER_WRITS_DESC = "Automatically destroy Jewelry Master Writs",  --TO TRANSLATE
    --treasures and trophies submenu
    DUSTMAN_TREASURES = "Сокровища и трофеи",
    DUSTMAN_TREASURE = "Помечать сокровища",
    DUSTMAN_TREASURE_DESC = "Включить/отключить механизм, помечающий сокровища как хлам.",
    DUSTMAN_TROPHIES = "Помечать собранные трофеи",
    DUSTMAN_TROPHIES_DESC = "Включить/отключить механизм, помечающий трофеи как хлам (если ранее они уже были найдены)",
    DUSTMAN_MUSEUM_PIECES = "Помечать трофеи для музея",
    DUSTMAN_MUSEUM_PIECES_DESC = "Включить/отключить механизм, помечающий трофеи для музея как хлам.",
    DUSTMAN_MUSEUM_PIECES_DESTROY = "...и уничтожать их!",
    DUSTMAN_MUSEUM_PIECES_DESTROY_DESC = "Автоматически уничтожать трофеи для музея.",
    --daily logins stuff
    DUSTMAN_CROWN = "Кронн",
    DUSTMAN_DAILY_LOGINS = "Ежедневные награды за вход",
    DUSTMAN_DL_FOOD = "Пища",
    DUSTMAN_DL_FOOD_DESC = "Уничтожать пищу из наград за ежедневный вход",
    DUSTMAN_DL_DRINKS = "Напитки",
    DUSTMAN_DL_DRINKS_DESC = "Уничтожать напитки из наград за ежедневный вход",
    DUSTMAN_DL_POTIONS = "Зелья",
    DUSTMAN_DL_POTIONS_DESC = "Уничтожать зелья из наград за ежедневный вход",
    DUSTMAN_DL_POISONS = "Яды",
    DUSTMAN_DL_POISONS_DESC = "Уничтожать яды из наград за ежедневный вход",
    DUSTMAN_DL_REP_KITS = "Ремонтные наборы",
    DUSTMAN_DL_REP_KITS_DESC = "Уничтожать ремонтные наборы из наград за ежедневный вход",
    DUSTMAN_DL_SOUL_GEMS = "Камни душ",
    DUSTMAN_DL_SOUL_GEMS_DESC = "Уничтожать камни душ из наград за ежедневный вход",
    --shared
    DUSTMAN_QUALITY = "Только если качество меньше или равно:",
    DUSTMAN_QUALITY_DESC = "Применяется, только если качество предмета меньше выбранного значения или равно ему.",
    DUSTMAN_QUALITY_SUPP = "Только если качество выше или равно:",
    DUSTMAN_QUALITY_SUPP_DESC = "Применяется, только если качество предмета выше выбранного значения или равно ему.",
    DUSTMAN_FULLSTACK = "Только с полным стаком в банке",
    DUSTMAN_FULLSTACK_DESC = "Применяется, только если у вас уже есть полный стак предметов в банке.",
    DUSTMAN_FULLSTACK_BAG = "Только с полным стаком в сумке",
    DUSTMAN_FULLSTACK_BAG_DESC = "Применяется, только если у вас уже есть полный стак предметов в сумке.",
    --fishing
    DUSTMAN_FISHES = "Рыбалка",
    DUSTMAN_LURE = "Помечать рыбью приманку",
    DUSTMAN_LURE_DESC = "Включить/отключить механизм, помечающий рыбьи приманки как хлам.",
    DUSTMAN_TROPHY = "Помечать собранную троф. рыбу",
    DUSTMAN_TROPHY_DESC = "Включить/отключить механизм, помечающий трофейную рыбу как хлам, если она уже была выловлена. Обычная рыба исключена, а ингредиенты обрабатываются, как и другие материалы снабжения.",
    -- housing
    DUSTMAN_HOUSING_RECIPES = "Помечать известные шаблоны",
    DUSTMAN_HOUSING_RECIPES_DESC = "Включить/отключить механизм, помечающий известные шаблоны как хлам.",
    --remember junk
    DUSTMAN_REMEMBER = "Запомнить предметы, отмеченные как хлам",
    DUSTMAN_REMEMBER_DESC = "Включить/отключить слежение за тем, что вы помечаете хламом. Когда вы это сделаете, аддон автоматически будет помечать подобные предметы при их последующем подборе как хлам, пока вы не снимите с него отметку хлама.",
    DUSTMAN_MEMORYFIRST = "Сначала использовать запомненные предм.",
    DUSTMAN_MEMORYFIRST_DESC = "Если выбрано, запомненные предметы будут использованы как фильтры с высоким приоритетом. Это означает, что они могут игнорировать другие фильтры.",
    --destroy junk submenu
    DUSTMAN_DESTROY = "Уничтожать хлам",
    DUSTMAN_DESTROY_DESC = "Включить/отключить уничтожение нежелаемых дешевых предметов.",
    DUSTMAN_DESTROY_VAL = "Ценовой порог",
    DUSTMAN_DESTROY_VAL_DESC = "Все нежелаемые предметы со значением равным или ниже выбранному будут уничтожены.",
    DUSTMAN_DESTROY_STOLEN = "Порог для украденных предметов",
    DUSTMAN_DESTROY_STOLEN_DESC = "Все украденные предметы, помеченные как хлам, по цене равной выбранному значению или меньше него будут уничтожены.",
    DUSTMAN_DESTROY_STACK = "Исключить предметы в стаке",
    DUSTMAN_DESTROY_STACK_DESC = "Не уничтожать предметы, которые суммируются в одном стаке, ценой больше нуля или меньше выбранного значения.",
    --notifications submenu
    DUSTMAN_VERBOSE = "Уведомлять, когда обрабат. хлам",
    DUSTMAN_VERBOSE_DESC = "Включить/отключить оповещение, что предмет был помечен как хлам или был уничтожен.",
    DUSTMAN_FOUND = "Сообщать об интересных предметах",
    DUSTMAN_FOUND_DESC = "Включить/отключить оповещение, что аддон нашел предмет с изучаемой особенностью, с редким стилем при деконструкции или предмет с бонусом от набора.",
    DUSTMAN_ALLITEMS = "Показывать детальный список при продаже",
    DUSTMAN_ALLITEMS_DESC = "Включить/отключить отображение детального списка того, что было продано.",
    DUSTMAN_TOTAL = "Показывать сводку при продаже",
    DUSTMAN_TOTAL_DESC = "Включить/отключить сводку того, что было продано.",
    DUSTMAN_CONFIRM = "Показывать окно подтвер. при продаже",
    DUSTMAN_CONFIRM_DESC = "Включить/отключить окно подтверждения продажи хлама.",
    DUSTMAN_DONTSELL = "Автоматически продавать предметы",
    DUSTMAN_DONTSELL_DESC = "Включить/отключить автоматическую продажу при разговоре с торговцем. Если отключено, вам придется использовать кнопку «Продать весь хлам» или продавать хлам вручную.",
    DUSTMAN_AUTOMATIC_SCAN = "Automatically scan inventory", --TO TRANSLATE
    DUSTMAN_AUTOMATIC_SCAN_DESC = "If this option is enabled your Dustman rules will be automatically applied when a new item is found in your inventory. Note that if you disable this option you will need to manually force an inventory scan using the option below or the rescan keybind", --TO TRANSLATE
    --stolen items
    DUSTMAN_STOLEN = "Помечать украденные ценности как хлам",
    DUSTMAN_STOLEN_DESC = "Включить/отключить механизм, помечающий украденные ценности (предметы без иного использования) как хлам",
    DUSTMAN_STOLEN_LAUNDER = "Отмыть украденные предметы",
    DUSTMAN_STOLEN_LAUNDER_DESC = "Отмывать украденные предметы, которые не совпадают с фильтрами хлама.",
    DUSTMAN_STOLEN_CLOTHES = "Исключить украденную одежду",
    DUSTMAN_STOLEN_CLOTHES_DESC = "Не помечать и не отмывать украденную одежду.",
    DUSTMAN_NOLAUNDER = "Не отмывать: <<1>>",
    DUSTMAN_NOLAUNDER_DESC = "Не отмывать: <<1>>.",
    DUSTMAN_NON_LAUNDERED = "Уничтожить ранее выбранные предметы",
    DUSTMAN_NON_LAUNDERED_DESC = "Уничтожить ранее выбранные предметы. Если не активно, предметы смогут находиться в вашей сумке.",
    DUSTMAN_ACT_LOWTREASURES = "Действия с сокровищами низкого качества",
    DUSTMAN_ACT_LOWTREASURES_DESC = "Выберете, что нужно делать с сокровищами низкого качества.",
    DUSTMAN_ACT_LOWTREASURE1 = "Ничего",
    DUSTMAN_ACT_LOWTREASURE2 = "Уничтожить",
    DUSTMAN_ACT_LOWTREASURE3 = "Отмыть",
    --keybinds
    DUSTMAN_JUNKKEYBIND = "Включить гор. клавишу \"Отметить как хлам\"",
    DUSTMAN_JUNKKEYBIND_DESC = "Добавить горячую клавишу для быстрой пометки предметов как хлам.",
    DUSTMAN_DESTROYKEYBIND = "Включить гор. клавишу \"Уничтожить\"",
    DUSTMAN_DESTROYKEYBIND_DESC = "Добавить горячую клавишу для быстрого уничтожения предметов в инвентаре.",
    --rescan button
    DUSTMAN_SWEEP = "Сканирование",
    DUSTMAN_SWEEP_DESC = "Повторно сканирует все предметы в багаже с использованием верхних фильтров.",
    --clear marked как хлам
    DUSTMAN_CLEAR_MARKED = "Очистить память хлама",
    DUSTMAN_CLEAR_MARKED_DESC = "Очистить список предметов, помеченных вручную как хлам.",
    --global settings
    DUSTMAN_GLOBAL = "Использовать общую конфигурацию?",
    DUSTMAN_GLOBAL_DESC = "Использовать одни и те же настройки для всех персонажей?",
    --import
    DUSTMAN_IMPORT = "Импортировать настройки Dustman",
    DUSTMAN_IMPORT_DESC = "Выберите, настройки Dustman какого персонажа следует импортировать.",
    DUSTMAN_IMPORTED = "Настройки Dustman персонажа по мени <<1>> были импортированы.",
    --chat notification
    DUSTMAN_SET_ENABLED = "Dustman не исключит комплект оборудования.",
    DUSTMAN_SET_DISABLED = "Dustman исключит оборудование из комплектов.",
    DUSTMAN_RESCAN_MSG = "Dustman благополучно пересканировал инвентарь!",
    DUSTMAN_NOTE_JUNK = "Dustman пометил предмет «<<t:1>>» как хлам (<<2>>).",
    DUSTMAN_NOTE_DESTROY = "Dustman уничтожил предмет «<<t:1>>» (<<2>>).",
    DUSTMAN_NOTE_RESEARCH = "Предмет с исследуемой особенностью: <<t:1>> (<<2>>).",
    DUSTMAN_NOTE_NIRNHONED = "Предмет со способностью |cFFFFFF<<1>>|r: <<t:2>>.",
    DUSTMAN_NOTE_SETITEM = "Предмет с бонусом от набора: <<t:1>> (<<2>>).",
    DUSTMAN_NOTE_INTERSTING = "Интересный предмет: <<t:1>>.",
    --report formats
    DUSTMAN_FORMAT_ZERO = "Dustman продал: <<2>>x <<t:1>>.",
    DUSTMAN_FORMAT_GOLD = "Dustman продал: <<2>>x <<t:1>> за <<3>>|t16:16:EsoUI/Art/currency/currency_gold.dds|t.",
    DUSTMAN_FORMAT_NOTSOLD = "Dustman не смог продать предмет <<t:1>>.",
    DUSTMAN_FORMAT_TOTAL = "Dustman продал: <<1>> <<1[предмет/предметы]>> (<<3>> <<3[stack/stacks]>>) за <<2>>|t16:16:EsoUI/Art/currency/currency_gold.dds|t.",
    DUSTMAN_FORMATL_ZERO = "Dustman отмыл: <<2>>x <<t:1>>.",
    DUSTMAN_FORMATL_GOLD = "Dustman отмыл: <<2>>x <<t:1>> за <<3>>|t16:16:EsoUI/Art/currency/currency_gold.dds|t.",
    DUSTMAN_FORMATL_NOTSOLD = "Dustman не смог отмыть <<t:1>>.",
    DUSTMAN_FORMATL_TOTAL = "Dustman отмыл <<1>> <<1[предмет/предметы]>> за <<2>>|t16:16:EsoUI/Art/currency/currency_gold.dds|t.",
    DUSTMAN_ZOS_RESTRICTIONS = "Согласно ограничениям ZOS Dustman может обрабатывать лишь 50 операций. Пожалуйста, подождите 10 секунд и снова поговорите с NPC.",
    --bursar of tributes
    DUSTMAN_BOT_QUEST_NAME_1 = "Вопрос о подношениях",
    DUSTMAN_BOT_QUEST_NAME_2 = "предметы для ухода",
    DUSTMAN_BOT_QUEST_NAME_3 = "Вопрос о свободном времени",
    DUSTMAN_BOT_QUEST_NAME_4 = "Шик и блеск",
    DUSTMAN_BOT_QUEST_NAME_5 = "Лакомые кусочки",
    DUSTMAN_BOT_QUEST_NAME_6 = "Кусочки и частички",
    DUSTMAN_BOT_COSMETIC = "косметика",
    DUSTMAN_BOT_GROOMING_ITEMS = "предметы для ухода",
    DUSTMAN_BOT_UTENSILS = "утварь",
    DUSTMAN_BOT_DAC = "посуда и кухонные принадлежности",
    DUSTMAN_BOT_DRINKWARE = "посуда для напитков",
    DUSTMAN_BOT_CT = "детские игрушки",
    DUSTMAN_BOT_DOLLS = "куклы",
    DUSTMAN_BOT_GAMES = "игры",
    DUSTMAN_BOT = "Save Bursar of Tributes quest items", --TO TRANSLATE
    DUSTMAN_BOT_DESC = "Save items for Bursar of Tributes quests. Since there are six possible quests given by the raven npc, you can choose to save all items required for all the possible quests or to save only the items required for the active quest.", --TO TRANSLATE
    DUSTMAN_BOT_DD_ALL = "All items required for all the quests", --TO TRANSLATE
    DUSTMAN_BOT_DD_ACTIVE = "Items required for active quest only" --TO TRANSLATE
}

for stringId, stringValue in pairs(strings) do
    ZO_CreateStringId(stringId, stringValue)
    SafeAddVersion(stringId, 1)
end