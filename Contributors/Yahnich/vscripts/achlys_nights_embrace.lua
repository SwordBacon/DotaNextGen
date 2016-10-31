LinkLuaModifier( "modifier_hidden_invis", LUA_MODIFIER_MOTION_NONE )
function AddInvis(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_hidden_invis", {duration = 15} )
end
function AddDamage(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	local cost = caster:GetMaxMana() * burn
	if caster:IsInvisible() and caster:GetMana() > cost then
		if caster:HasModifier("modifier_achlys_nights_embrace_damage") then
			local stacks = caster:GetModifierStackCount("modifier_achlys_nights_embrace_damage", caster)
			ability.DamageStacks = stacks + 1
			caster:SetModifierStackCount("modifier_achlys_nights_embrace_damage", caster, ability.DamageStacks)
		else
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_achlys_nights_embrace_damage", {})
			caster:SetModifierStackCount("modifier_achlys_nights_embrace_damage", caster, 1)
		end
		local burn = ability:GetSpecialValueFor("mana_cost_pct") / 500
		caster:SpendMana(cost, ability)
	else
		caster:RemoveModifierByName("modifier_achlys_nights_embrace_damage")
	end
end