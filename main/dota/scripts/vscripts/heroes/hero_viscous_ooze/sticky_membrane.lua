function StickyMembraneDistanceCheck( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("bonus_duration", ability:GetLevel() - 1)
	
	local caster_location = caster:GetAbsOrigin()
	local attacker_location = attacker:GetAbsOrigin()

	local damage_pct = ability:GetLevelSpecialValueFor("bonus_damage", ability:GetLevel() - 1)/100
	local attack_damage = attacker:GetAttackDamage()
	damage_stacks = attack_damage * damage_pct
	
	local distance = (caster_location - attacker_location):Length2D()
	local trigger_radius = ability:GetLevelSpecialValueFor("trigger_radius", (ability:GetLevel() - 1))
	
	
	if distance <= trigger_radius and not attacker:IsMagicImmune() and not attacker:IsBuilding() then
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_sticky_membrane_disarm", {})
		ability:ApplyDataDrivenModifier(attacker, caster, "modifier_sticky_membrane_bonus", {})
		local stacks = caster:GetModifierStackCount("modifier_sticky_membrane_bonus", ability)
		caster:SetModifierStackCount("modifier_sticky_membrane_bonus", ability, stacks + damage_stacks)

		local projTable = {
			Target = caster,
			Source = attacker,
			Ability = ability,
			EffectName = "particles/units/heroes/hero_rubick/rubick_spell_steal.vpcf",
			bDodgeable = false,
			bProvidesVision = false,
			iMoveSpeed = 400, 
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1, 
			vSpawnOrigin = attacker:GetAbsOrigin()
		}
		ProjectileManager:CreateTrackingProjectile( projTable )

		Timers:CreateTimer(duration, function() 
			local remove_stacks = caster:GetModifierStackCount("modifier_sticky_membrane_bonus", ability)
			if caster:HasModifier("modifier_sticky_membrane_bonus") then
				caster:SetModifierStackCount("modifier_sticky_membrane_bonus", ability, remove_stacks - damage_stacks)
			end
		end)
	end
end
