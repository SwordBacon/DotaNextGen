if modifier_alternating_current == nil then
	modifier_alternating_current = class({})
end

function modifier_alternating_current:DeclareFunctions()
	return 
	{ 
	MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
	}
end

function modifier_alternating_current:GetAttributes() 
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_alternating_current:IsHidden()
    return false
end

--[[function nexus_super_illusion:GetIsIllusion()
	return true
end]]

function modifier_alternating_current:GetModifierPercentageManacost()
	return 40
end