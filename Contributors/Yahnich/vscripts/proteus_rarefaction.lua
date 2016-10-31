function RarefactionToggle(keys)
	local caster = keys.caster
	local ability = keys.ability
	if ability:GetToggleState() then
		if not caster:HasModifier("modifier_proteus_rarefaction_aura") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_proteus_rarefaction_aura", {})
		end
	else
		if caster:HasModifier("modifier_proteus_rarefaction_aura") then
			caster:RemoveModifierByName("modifier_proteus_rarefaction_aura")
		end
	end
end

function RarefactionCooldownReduction(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	
	local cooldownreduction = ability:GetSpecialValueFor("cooldown_reduction") / 100
	for i = 0, 16 do
		local ability = target:GetAbilityByIndex(i)
		if ability and ability:GetAbilityType() ~= 1 then
			local cooldown = ability:GetCooldownTimeRemaining()
			ability:EndCooldown()
			ability:StartCooldown(cooldown - 0.1*cooldownreduction)
		end
	end
end