function SpellLifesteal( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = keys.damage
	local lifesteal_hero = ability:GetLevelSpecialValueFor("spell_lifesteal", ability:GetLevel() - 1)
	local lifesteal_creep = ability:GetLevelSpecialValueFor("spell_lifesteal_creep", ability:GetLevel() - 1)

	if not caster:HasItemInInventory("item_octarine_core") then
		if target:IsHero() then
			local heal_amount = damage * lifesteal_hero
			caster:Heal(heal_amount, ability)
			ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN, caster)
		else
			local heal_amount = damage * lifesteal_creep
			caster:Heal(heal_amount, ability)
			ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN, caster)
		end
	end
end

function SpellLifestealConsume( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = keys.damage
	local lifesteal_hero = ability:GetLevelSpecialValueFor("spell_lifesteal", ability:GetLevel() - 1) / 100
	local lifesteal_creep = ability:GetLevelSpecialValueFor("spell_lifesteal_creep", ability:GetLevel() - 1) / 100

	if not caster:HasItemInInventory("item_octarine_core") and not caster:HasItemInInventory("item_octarine_core_datadriven") then
		if target:IsHero() then
			local heal_amount = damage * lifesteal_hero
			caster:Heal(heal_amount, ability)
			ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN, caster)
		else
			local heal_amount = damage * lifesteal_creep
			caster:Heal(heal_amount, ability)
			ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN, caster)
		end
	end
end