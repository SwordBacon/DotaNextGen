function ApplyDamageReduction ( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local abilityLevel = ability:GetLevel() - 1
	local damage = keys.Damage

	if target:IsNull() or not IsValidEntity(target) then return end

	local threshold = ability:GetLevelSpecialValueFor("threshold", abilityLevel) * target:GetMaxHealth() / 100
	local duration = ability:GetLevelSpecialValueFor("duration", abilityLevel)

	if target.damage_taken == nil then target.damage_taken = 0 end

	local damage_taken = target.damage_taken
	damage_taken = damage_taken + damage

	while damage_taken > threshold do
		ability:ApplyDataDrivenModifier(caster, target, "modifier_protection_shield", {Duration = duration})
		target:SetModifierStackCount("modifier_protection_shield", ability, target:GetModifierStackCount("modifier_protection_shield", ability) + 1)
		
		Timers:CreateTimer( duration, function()
			if target:IsNull() or not IsValidEntity(target) then return end
			if target:GetModifierStackCount("modifier_protection_shield", ability) > 1 then
				target:SetModifierStackCount("modifier_protection_shield", ability, target:GetModifierStackCount("modifier_protection_shield", ability) - 1)
			elseif caster:HasModifier("modifier_protection_shield") then
				target:RemoveModifierByName("modifier_protection_shield")
			end
		end)
		damage_taken = damage_taken - threshold
	end

	target.damage_taken = damage_taken
end