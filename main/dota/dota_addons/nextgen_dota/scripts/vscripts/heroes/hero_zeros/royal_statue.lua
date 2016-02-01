function FaceDirectionOfCaster( keys )
	local caster = keys.caster
	local target = keys.target
	local casterVec = caster:GetForwardVector()
	local ability = keys.ability
	local health = ability:GetLevelSpecialValueFor("health", ability:GetLevel() - 1)
	local bounty = ability:GetLevelSpecialValueFor("bounty", ability:GetLevel() - 1)

	target:SetForwardVector(casterVec)
	target:SetBaseMaxHealth(health)
	target:SetMinimumGoldBounty(bounty)
	target:SetMaximumGoldBounty(bounty)
end

function FindAbilityMalice( keys )
	local caster = keys.caster
	local target = keys.target
	local attacker = keys.attacker
	local ability = keys.ability

	local maliceAbility = caster:FindAbilityByName("zeros_blade_of_malice")

	if maliceAbility and maliceAbility:GetLevel() > 0 then
		maliceAbility:ApplyDataDrivenModifier(caster, attacker, "modifier_malice_debuff", {duration=8.0})
	end
end

function ApplyDamageReductionStacks( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifierName = "modifier_statue_debuff_stack"

	if not target:HasModifier(modifierName) then
		ability:ApplyDataDrivenModifier(caster, target, modifierName, {})
		target:SetModifierStackCount(modifierName, ability, 1)
	else
		local stack = target:GetModifierStackCount(modifierName, ability)
		target:SetModifierStackCount(modifierName, ability, stack + 1)
	end
end

