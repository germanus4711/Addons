local LCCC = LibCodesCommonCode
local LEJ = LibExtendedJournal
local LootLog = LootLog


--------------------------------------------------------------------------------
-- LootLog.AddAntiquityTooltipExtension
--------------------------------------------------------------------------------

function LootLog.AddAntiquityTooltipExtension( tooltip, antiquityId )
	if (type(antiquityId) ~= "number" or antiquityId == 0) then return end

	local extension = LEJ.TooltipExtensionInitialize(
		true,
		zo_strformat(SI_ANTIQUITY_TIMES_ACQUIRED, GetNumAntiquitiesRecovered(antiquityId)),
		zo_strformat(SI_ANTIQUITY_CODEX_ENTRIES_FOUND, GetNumAntiquityLoreEntriesAcquired(antiquityId), GetNumAntiquityLoreEntries(antiquityId)):gsub("|c%w%w%w%w%w%w", ""):gsub("|r", ""),
		"Antiquity"
	)

	extension:AddSection(nil, LootLog.GetAntiquityRewardLink(antiquityId))

	local setId = GetAntiquitySetId(antiquityId)
	if (setId and setId ~= 0) then
		local results = { }
		local leads = 0

		for i = 1, GetNumAntiquitySetAntiquities(setId) do
			local fragmentId = GetAntiquitySetAntiquityId(setId, i)
			local name = zo_strformat(SI_TOOLTIP_ITEM_NAME, GetAntiquityName(fragmentId))

			local color
			if (DoesAntiquityNeedCombination(fragmentId)) then
				color = LEJ.GetTooltipColor(1, 1)
				leads = leads + 1
			elseif (DoesAntiquityHaveLead(fragmentId)) then
				color = LEJ.GetTooltipColor(1, 3)
				leads = leads + 1
			else
				color = LEJ.GetTooltipColor(1, 2)
			end

			if (antiquityId == fragmentId) then
				table.insert(results, string.format("|c%06X|l0:1:1:1:1:%06X|l%s|l|r", color, color, name))
			else
				table.insert(results, string.format("|c%06X%s|r", color, name))
			end
		end

		extension:AddSection(string.format("%s (%d/%d)", GetString(SI_ANTIQUITY_FRAGMENTS), leads, #results), table.concat(results, ", "))
	end

	extension:Finalize(tooltip, true)
end


--------------------------------------------------------------------------------
-- LootLog.HookAntiquityTooltips
--------------------------------------------------------------------------------

local AreAntiquityTooltipsHooked = false

function LootLog.HookAntiquityTooltips( )
	if (AreAntiquityTooltipsHooked or not LootLog.vars.antiquityTooltips) then return end
	AreAntiquityTooltipsHooked = true

	local TooltipHook = function( control, functionName, leadFunction )
		ZO_PostHook(control, functionName, function( self, ... )
			if (LootLog.vars.antiquityTooltips) then
				LootLog.AddAntiquityTooltipExtension(control, leadFunction(...))
			end
		end)
	end

	local LeadPassthrough = function( antiquityId )
		return antiquityId
	end

	TooltipHook(AntiquityTooltip, "SetAntiquityLead", LeadPassthrough)
	TooltipHook(AntiquityTooltip, "SetAntiquitySetFragment", LeadPassthrough)
	TooltipHook(ItemTooltip, "SetStoreItem", GetStoreEntryAntiquityId)
	TooltipHook(ItemTooltip, "SetLootItem", GetLootAntiquityLeadId)
end

LCCC.RunAfterInitialLoadscreen(LootLog.HookAntiquityTooltips)
