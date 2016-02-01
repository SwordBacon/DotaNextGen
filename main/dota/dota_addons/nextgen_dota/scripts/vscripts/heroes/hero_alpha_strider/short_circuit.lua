function RefreshCooldowns( keys )
	local caster = keys.caster
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local damageType = ability:GetAbilityDamageType()
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local max_targets = ability:GetLevelSpecialValueFor("targets", ability:GetLevel() - 1)
	
	local ability1 = caster:GetAbilityByIndex(0)
	local ability2 = caster:GetAbilityByIndex(1)
	local ability3 = caster:GetAbilityByIndex(2)
	local ability4 = caster:GetAbilityByIndex(3)
	
	local ability1CD = ability1:GetCooldownTimeRemaining()
	local ability2CD = ability2:GetCooldownTimeRemaining()
	local ability3CD = ability3:GetCooldownTimeRemaining()
	local ability4CD = ability4:GetCooldownTimeRemaining()
	
	
	ability1:EndCooldown()
	ability2:EndCooldown()
	ability3:EndCooldown()
	ability4:EndCooldown()

	local cooldown = ability1CD + ability2CD + ability3CD + ability4CD + 5
	damage = damage * cooldown


	ability:StartCooldown(cooldown)

	ApplyDamage({ victim = caster, attacker = caster, damage = damage, damage_type = damageType })

	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)

	for i = 1, #targets do
		ability:ApplyDataDrivenModifier(caster, targets[i], "modifier_short_circuit", {})
		Timers:CreateTimer( 0.1, function() 
			ApplyDamage({ victim = targets[i], attacker = caster, ability = ability, damage = damage, damage_type = damageType })
		end)
		max_targets = max_targets - 1
		if max_targets < 1 then break end
	end
end