function Forget( keys )
	local caster = keys.caster
	local target = keys.target 
	local ability = keys.ability

	local lastAbilityName = PlayerResource:GetSelectedHeroEntity( target:GetPlayerID() ).lastAbility
	local lastAbility = PlayerResource:GetSelectedHeroEntity( target:GetPlayerID() ):FindAbilityByName(lastAbilityName)

	if lastAbility then
		local index = lastAbility:GetAbilityIndex() + 1
		local relearnAbility = target:FindAbilityByName("tyra_relearn_" .. index)

		if not relearnAbility then 
			relearnAbility = target:AddAbility("tyra_relearn_" .. index) 
		end

		if relearnAbility and lastAbility ~= relearnAbility then
			relearnAbility.index = index
			relearnAbility.forgottenAbility = lastAbility:GetName()
			relearnAbility:SetHidden(true)
			relearnAbility:SetLevel(ability:GetLevel())

			target:SwapAbilities(lastAbility:GetName(), relearnAbility:GetName(), false, true)
		end
	end
	if target:IsChanneling() then
		target:Interrupt()
		target:AddNewModifier(caster, ability, "modifier_stunned", {Duration = 1.5})
	end
end

function Relearn( keys )
	local caster = keys.caster
	local index = keys.ability.index
	local lastAbility = keys.ability.forgottenAbility
	local relearnAbility = "tyra_relearn_" .. index

	if lastAbility then
		caster:SwapAbilities(relearnAbility, lastAbility, false, true)
	end
end