function BeginCooldown( keys )
	local caster = keys.caster
	local ability = keys.ability
	if not abilityLast then abilityLast = ability end
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
		
		if abilityCD:GetLevel() > 0 and abilityCD ~= ability then
			ability:EndCooldown()
			if ability:GetName() == "alpha_strider_plasma_leap" then
				ability:StartCooldown(0.85)
			end
			cooldown = cooldown + abilityCD:GetCooldownTimeRemaining()
			if cooldown > 60 then cooldown = 60 end
			abilityCD:StartCooldown(cooldown)

			if abilityLast == ability then
				if not caster:HasModifier("modifier_alternating_current_stacks") then
					ability4:ApplyDataDrivenModifier(caster, caster, "modifier_alternating_current_stacks", {Duration = duration})
				end
				stack_count = caster:GetModifierStackCount("modifier_alternating_current_stacks", ability)
				mana_spent = (ability:GetManaCost(-1) * stack_count) / 5
				caster:SetModifierStackCount("modifier_alternating_current_stacks", ability, stack_count + 1)
				caster:ReduceMana(mana_spent)
			else 
				abilityLast = ability
				caster:RemoveModifierByName("modifier_alternating_current_stacks")
			end
			check = true
		end
	end
end