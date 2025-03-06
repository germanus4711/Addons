-- Translated by: Cisneros

local PAC = PersonalAssistant.Constants
local PAWStrings = {
    -- =================================================================================================================
    -- Language specific texts that need to be translated --

    -- =================================================================================================================
    -- == MENU/PANEL TEXTS == --
    -- -----------------------------------------------------------------------------------------------------------------
    -- Menú PAWorker --
    SI_PA_MENU_WORKER_DESCRIPTION = "PAWorker puede deconstruir objetos o refinar materiales automáticamente",
    
    SI_PA_MENU_WORKER_METICULOUS_ENABLE = "Verificación de deconstrucción meticulosa",
    SI_PA_MENU_WORKER_METICULOUS_ENABLE_T = "Impide deconstruir/refinar si la deconstrucción meticulosa no está activada",
    SI_PA_MENU_WORKER_CHECK_EXTRACTION_ENABLE = "Verificación pasiva de extracción",
    SI_PA_MENU_WORKER_CHECK_EXTRACTION_ENABLE_T = "Impide deconstruir/refinar si la pasiva de extracción correspondiente a la habilidad de artesanía no está maximizada",

    -- Refinar automáticamente --
    SI_PA_MENU_WORKER_AUTOREFINE_HEADER = "Auto refinar materiales",
    SI_PA_MENU_WORKER_AUTOREFINE_ENABLE = "Habilitar auto refinar materiales",
    SI_PA_MENU_WORKER_AUTOREFINE_ENABLE_T = "Refina materiales automáticamente",
    
    -- Deconstruir automáticamente --
    SI_PA_MENU_WORKER_AUTODECONSTRUCT_HEADER = "Auto deconstrucción de objetos",
    SI_PA_MENU_WORKER_AUTODECONSTRUCT_ENABLE = "Habilitar auto deconstrucción de objetos",
    SI_PA_MENU_WORKER_AUTODECONSTRUCT_ENABLE_T = "Deconstruye objetos automáticamente",
    
    SI_PA_MENU_WORKER_PROTECT_BANK_ENABLE = "Proteger objetos del banco",
    SI_PA_MENU_WORKER_PROTECT_BANK_ENABLE_T = "Segunda protección para los objetos del banco",
    
    SI_PA_MENU_WORKER_PROTECT_UNCOLLECTED_SET_ITEMS_ENABLE = "Proteger objetos de conjuntos no coleccionados",
    SI_PA_MENU_WORKER_PROTECT_UNCOLLECTED_SET_ITEMS_ENABLE_T = "Protege objetos de conjuntos no coleccionados de la deconstrución automática",
    
    -- Investigar rasgos automáticamente --
    SI_PA_MENU_WORKER_AUTORESEARCHTRAITS_HEADER = "Investigar rasgos automáticamente",
    SI_PA_MENU_WORKER_AUTORESEARCHTRAITS_ENABLE = "Habilitar investigar rasgos automáticamente",
    SI_PA_MENU_WORKER_AUTORESEARCHTRAITS_ENABLE_T = "Investigar rasgos automáticamente",
    
    -- Textos generales usados en: Armas, Armaduras, Joyería --
    SI_PA_MENU_WORKER_AUTOMARK_QUALITY_THRESHOLD = "Auto deconstruir %s con calidad igual o inferior a",
    SI_PA_MENU_WORKER_AUTOMARK_QUALITY_THRESHOLD_T = "Auto deconstruir %s si son de la calidad seleccionada o inferior",
    SI_PA_MENU_WORKER_AUTOMARK_INTRICATE = table.concat({"Auto deconstruir %s con el rasgo [", GetString("SI_ITEMTRAITTYPE", ITEM_TRAIT_TYPE_ARMOR_INTRICATE),"]"}),
    SI_PA_MENU_WORKER_AUTOMARK_INTRICATE_T = table.concat({"Auto deconstruir %s con el rasgo [", GetString("SI_ITEMTRAITTYPE", ITEM_TRAIT_TYPE_ARMOR_INTRICATE), "] (inspiración aumentada)?"}),
    SI_PA_MENU_WORKER_AUTOMARK_ORNATE = table.concat({"Auto deconstruir %s con el rasgo [", GetString("SI_ITEMTRAITTYPE", ITEM_TRAIT_TYPE_ARMOR_ORNATE), "]"}),
    SI_PA_MENU_WORKER_AUTOMARK_ORNATE_T = table.concat({"Auto deconstruir %s con el rasgo [", GetString("SI_ITEMTRAITTYPE", ITEM_TRAIT_TYPE_ARMOR_ORNATE), "] (precio de venta aumentado)?"}),
    SI_PA_MENU_WORKER_AUTOMARK_INCLUDE_SETS = "Deconstruir %s que sean parte de un conjunto",
    SI_PA_MENU_WORKER_AUTOMARK_INCLUDE_SETS_T = "Si está desactivado, solo se desconstruirán %s que NO pertenezcan a un conjunto",
    SI_PA_MENU_WORKER_AUTOMARK_INCLUDE_KNOWN_TRAITS = "Deconstruir %s con rasgos conocidos",
    SI_PA_MENU_WORKER_AUTOMARK_INCLUDE_KNOWN_TRAITS_T = "Si está desactivado, solo se desconstruirán %s sin rasgos o con rasgos desconocidos",
    SI_PA_MENU_WORKER_AUTOMARK_INCLUDE_UNKNOWN_TRAITS = "Deconstruir %s con rasgos desconocidos",
    SI_PA_MENU_WORKER_AUTOMARK_INCLUDE_UNKNOWN_TRAITS_T = "Si está desactivado, solo se desconstruirán %s sin rasgos o con rasgos conocidos",



    -- =================================================================================================================
    -- == CHAT OUTPUTS == --
    -- -----------------------------------------------------------------------------------------------------------------
    -- Deconstrución con PAWorker --
    SI_PA_CHAT_ITEM_DECONSTRUCTED = "%s ha sido deconstruido",
    SI_PA_CHAT_ITEM_REFINED = "%s ha sido refinado",
    SI_PA_CHAT_ITEM_RESEARCHED = "%s se ha utilizado para investigar el rasgo %s (%s) para %s",
    SI_PA_CHAT_RESEARCH_FULL = "No se pudo investigar el rasgo %s para %s porque %s/%s ranuras de investigación están en uso",
    SI_PA_CHAT_RESEARCH_BUSY = "No se pudo investigar el rasgo %s porque ya estás investigando otro rasgo para %s",
    SI_PA_CHAT_NO_METICULOUS = "La deconstrución/refinación automática está bloqueada porque el deconstrucción Meticuloso no está activado",
    SI_PA_CHAT_NO_EXTRACTION = "La deconstrución/refinación automática está bloqueada porque %s no está maximizado",
    SI_PA_CHAT_NO_EXTRACTION_FOR_ITEM = "%s no está maximizado, por lo que %s no fue deconstruido automáticamente",
    SI_PA_CHAT_CRAFTING_QUEST = "La deconstrución/refinación/investigación automática fue bloqueada porque tienes una misión de artesanía en curso",

}

for key, value in pairs(PAWStrings) do
    ZO_CreateStringId(key, value)
    SafeAddVersion(key, 1)
end


local PAWGenericStrings = {
    -- =================================================================================================================
    -- Language independent texts (do not need to be translated/copied to other languages --

    -- =================================================================================================================
    -- == CHAT OUTPUTS == --
    -- -----------------------------------------------------------------------------------------------------------------
    --SI_PA_CHAT_Consume_CHARGE_WEAPON = "%s (%d%% --> %d%%) - %s",
}

for key, value in pairs(PAWGenericStrings) do
    ZO_CreateStringId(key, value)
    SafeAddVersion(key, 1)
end
