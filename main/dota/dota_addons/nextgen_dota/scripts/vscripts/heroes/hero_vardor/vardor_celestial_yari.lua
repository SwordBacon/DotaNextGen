

function Celestial(keys)

	local caster = keys.caster
	local ability = keys.ability
	local duration = keys.duration

	local modifier_1 = "modifier_hold_yari"
	local ability_partner = caster:FindAbilityByName("vardor_mental_thrusts")
	local ability_partner2 = caster:FindAbilityByName("vardor_piercing_shot")

	local current_stack = caster:GetModifierStackCount( modifier_1 , ability_partner )

	if current_stack == 1 then
		caster:SetModifierStackCount(modifier_1, ability_partner, 2)
	end

	ability_partner2:ApplyDataDrivenModifier(caster, caster, "modifier_cooldown_reduction", {Duration = duration})

end

function CelestialDestroy(keys)
	local caster = keys.caster
	local ability = keys.ability

	local modifier_1 = "modifier_hold_yari"
	local ability_partner = caster:FindAbilityByName("vardor_mental_thrusts")

	local current_stack = caster:GetModifierStackCount( modifier_1 , ability_partner )
	if current_stack > 0 then
		caster:SetModifierStackCount(modifier_1, ability_partner, 1)
	end

end