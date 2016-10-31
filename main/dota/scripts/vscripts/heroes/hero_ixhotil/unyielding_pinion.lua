function CheckCooldown( keys )
	if keys.caster:PassivesDisabled() and keys.caster:HasModifier("modifier_pinion_passive") then
		caster:RemoveModifierByName("modifier_pinion_passive")
		return
	end
	if keys.ability:IsCooldownReady() and not keys.caster:HasModifier("modifier_pinion_passive") then
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_pinion_passive", {})
	end
end