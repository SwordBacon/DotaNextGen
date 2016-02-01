if modifier_borus_negative_effect_enemies == nil then
	modifier_borus_negative_effect_enemies = class({})
end

function modifier_borus_negative_effect_enemies:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_borus_negative_effect_enemies:GetModifierAttackSpeedBonus_Constant(params)
	return self.attackspeed_increase
end

function modifier_borus_negative_effect_enemies:GetModifierMoveSpeedBonus_Percentage (params)
	return self.ms_increase
end