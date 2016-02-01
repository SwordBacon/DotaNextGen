function BeginCooldown( keys )
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local cooldown = ability:GetCooldown(level)
	local check = false
	
	
	local ability1 = caster:GetAbilityByIndex(0)
	local ability2 = caster:GetAbilityByIndex(1)
	local ability3 = caster:GetAbilityByIndex(2)
	local ability4 = caster:GetAbilityByIndex(3)
	
	while check == false do
		local randomInt = RandomInt(0,3)
		local abilityCD = caster:GetAbilityByIndex(randomInt)
		
		if abilityCD:GetLevel() > 0 then
			ability:EndCooldown()
			if ability:GetName() == "alpha_strider_plasma_leap" and ability ~= abilityCD then
				ability:StartCooldown(0.85)
			end
			cooldown = cooldown + abilityCD:GetCooldownTimeRemaining()
			abilityCD:StartCooldown(cooldown)
			if abilityCD:GetName() == "alpha_strider_static_charge" and ability == abilityCD then
				abilityCD:ToggleAbility()
			end
			check = true
		end
	end
end