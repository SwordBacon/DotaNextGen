function HealingAttack (keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local attacker = keys.attacker
	local DamageTaken = keys.DamageTaken
	local Cooldown_Factor = ability:GetLevelSpecialValueFor("Cooldown_Factor",ability:GetLevel()-1)
	local Cooldown_Chance = ability:GetLevelSpecialValueFor("Cooldown_Chance",ability:GetLevel()-1)
	local Heal_Factor = ability:GetLevelSpecialValueFor("Heal_Factor",ability:GetLevel()-1)

	if caster == attacker then

		target:Heal(caster:GetAverageTrueAttackDamage() * Heal_Factor,caster)

		local random = RandomInt(1,100)
		if random <= Cooldown_Chance then
			-- Loop through abilities and items to alter cooldowns.

			for ability_id = 0, 15 do

				local ability = target:GetAbilityByIndex(ability_id)
				if ability then
					if ability:GetCooldownTimeRemaining() > 0  and ability:GetAbilityType() == 0 then 
						--local new_cooldown = ability:GetCooldownTimeRemaining() * (1-Cooldown_Factor)
						ability:EndCooldown()
						--ability:StartCooldown(new_cooldown)
					end   
				end
			end
		end
	end
end

