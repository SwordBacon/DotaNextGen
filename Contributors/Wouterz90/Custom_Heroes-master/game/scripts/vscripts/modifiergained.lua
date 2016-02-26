function GameMode:FilterModifierGained( filterTable )

	local modifierCasterIndex = filterTable["entindex_caster_const"]
	local modifierCaster = EntIndexToHScript(modifierCasterIndex)
	local modifierAbilityIndex = filterTable["entindex_ability_const"]
	if modifierAbilityIndex then
		local modifierAbility = EntIndexToHScript(modifierAbilityIndex)
	end
	local modifierDuration = filterTable["duration"]
	local modifierTargetIndex =  filterTable["entindex_parent_const"]
	local modifierTarget = EntIndexToHScript(modifierTargetIndex)
	local modifierName = filterTable["name_const"]

	if modifierCaster:GetUnitName() == "npc_dota_hero_omniknight" and modifierCaster:GetTeamNumber() == modifierTarget:GetTeamNumber() and (modifierName == "modifier_sange_buff" or modifierName == "modifier_bashed" or modifierName == "modifier_sange_and_yasha_buff" or modifierName == "modifier_item_skadi_slow" or modifierName == "modifier_silver_edge_debuff" or modifierName == "modifier_desolator_buff") then
		return false
	end

	if modifierCaster:HasItemInInventory("Item_Debuff_Reduction") and modifierCaster:GetTeamNumber() == modifierTarget:GetTeamNumber() then
		filterTable["duration"] = modifierDuration * 0.8 
		return true
	end

	return true
end


