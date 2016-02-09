function RestoreMana( keys )
	local caster = keys.caster
	local ability = keys.ability
	local mana = ability:GetLevelSpecialValueFor("mana_restore", ability:GetLevel() - 1)
	local bonusMana = ability:GetLevelSpecialValueFor("bonus_restore", ability:GetLevel() - 1)
	local burnAmount = ability:GetLevelSpecialValueFor("burn_amount", ability:GetLevel() - 1) / 100
	local modifierName = "modifier_static_charge"
	local modifierCount = caster:GetModifierStackCount(modifierName, caster)

	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	
	mana = (bonusMana * modifierCount) + mana
	caster:GiveMana(mana)

	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	for _,v in pairs(targets) do
		v:ReduceMana(mana * burnAmount)
	end
end