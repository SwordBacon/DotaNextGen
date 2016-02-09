function ManaBurn( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local manaburn = ability:GetLevelSpecialValueFor("mana_burn", ability:GetLevel() - 1)

	target:SpendMana(manaburn, ability)
end