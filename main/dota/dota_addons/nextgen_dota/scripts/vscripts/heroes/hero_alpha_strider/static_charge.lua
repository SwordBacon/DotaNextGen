function AddCharges( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifierName = "modifier_static_charge"
	local mana = ability:GetManaCost(ability:GetLevel() - 1)
	
	if not caster:HasModifier(modifierName) then
		ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
	end
	local modifierCount = caster:GetModifierStackCount(modifierName, caster)
	caster:SetModifierStackCount(modifierName, caster, modifierCount + 1)
	
	if caster:GetMana() < mana then
		ability:ToggleAbility()
	end
end

function SpendCharges( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local modifierName = "modifier_static_charge"
	local modifierCount = caster:GetModifierStackCount(modifierName, caster)
	
	local damage = ability:GetAbilityDamage()
	local shockDamage = damage * modifierCount
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	
	if target:IsBuilding() then
		shockDamage = shockDamage / 2
	end
	
	local DamageTable = {
	victim = target,
	attacker = caster,
	ability = ability,
	damage = shockDamage,
	damage_type = DAMAGE_TYPE_MAGICAL
	}
	

	if not target:IsMagicImmune() then
		ApplyDamage(DamageTable)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_charge_slow", {Duration = duration})
		target:SetModifierStackCount("modifier_charge_slow", ability, modifierCount)
		if modifierCount > 10 then 
			target:AddNewModifier(caster, ability, "modifier_stunned", {Duration = duration})
		end
		caster:RemoveModifierByName(modifierName)
		EmitSoundOn("Hero_Leshrac.Lightning_Storm", target)
		particle = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, target)
                --shared control points for all the different lightnings
                ParticleManager:SetParticleControl(particle, 0, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,1000)) -- height of the bolt
                ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()) -- point landing
                ParticleManager:SetParticleControl(particle, 2, target:GetAbsOrigin()) -- point origin  
	end
end