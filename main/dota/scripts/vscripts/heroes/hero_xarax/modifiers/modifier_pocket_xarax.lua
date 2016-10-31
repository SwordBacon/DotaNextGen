if modifier_pocket_xarax == nil then
	modifier_pocket_xarax = class({})
end

function modifier_pocket_xarax:DeclareFunctions()
	return 
	{ 
	MODIFIER_PROPERTY_SUPER_ILLUSION,
	MODIFIER_PROPERTY_ILLUSION_LABEL, 
	--MODIFIER_PROPERTY_IS_ILLUSION,
	}
end

function modifier_pocket_xarax:GetAttributes() 
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_pocket_xarax:IsHidden()
    return true
end

--[[function nexus_super_illusion:GetIsIllusion()
	return true
end]]

function modifier_pocket_xarax:GetModifierSuperIllusion()
	return true
end

function modifier_pocket_xarax:GetModifierIllusionLabel()
	return true
end
function modifier_pocket_xarax:CheckState()
 	return 
 	{
 	[MODIFIER_STATE_DISARMED] = true,
 	} 
end