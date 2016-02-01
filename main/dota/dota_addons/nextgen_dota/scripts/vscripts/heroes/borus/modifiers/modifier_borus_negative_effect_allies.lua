if modifier_borus_negative_effect_allies == nil then
	modifier_borus_negative_effect_allies = class({})
end


function modifier_borus_negative_effect_allies:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_borus_negative_effect_allies:GetModifierAttackSpeedBonus_Constant(params)
	return self.attackspeed_increase
end

function modifier_borus_negative_effect_allies:GetModifierMoveSpeedBonus_Percentage (params)
	return self.ms_increase
end