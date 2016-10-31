modifier_static_charge_slow = class({})

function modifier_static_charge_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
	}
	return funcs
end

function modifier_static_charge_slow:GetModifierMoveSpeedBonus_Percentage()
	if not self:GetCaster() then return 0 end
	local ability = self:GetCaster():FindAbilityByName("alpha_strider_static_charge_lua")
	if not ability then return 0 end
	local slow_amount = ability:GetLevelSpecialValueFor("slow_amount", ability:GetLevel() - 1)
	return self:GetStackCount() * slow_amount
end

function modifier_static_charge_slow:GetModifierAttackSpeedBonus_Constant()
	if not self:GetCaster() then return 0 end
	local ability = self:GetCaster():FindAbilityByName("alpha_strider_static_charge_lua")
	if not ability then return 0 end
	local slow_amount = ability:GetLevelSpecialValueFor("slow_amount", ability:GetLevel() - 1)
	return self:GetStackCount() * slow_amount
end

function modifier_static_charge_slow:GetEffectName()
    return "particles/units/heroes/hero_leshrac/leshrac_lightning_slow.vpcf"
end

function modifier_static_charge_slow:GetEffectAttachType()
    return PATTACH_ABSORIGIN
end