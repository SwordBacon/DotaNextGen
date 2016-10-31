function Polyp(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	local polypBase = ability:GetSpecialValueFor("base_polyp_health")
	local polypMax = ability:GetSpecialValueFor("max_polyp_health")
	
	local polyp = target.PolypAttached
	
	if not polyp or polyp:IsNull() then
		polyp = CreateUnitByName("npc_dota_proteus_polyp", target:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
		target.PolypAttached = polyp
		polyp:SetMaxHealth(polypMax)
		polyp:SetBaseMaxHealth(polypMax)
		polyp:SetHealth(polypBase)
		ability:ApplyDataDrivenModifier(caster, polyp, "modifier_proteus_polyp_unit", {})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_proteus_polyp_protection", {})
		polyp:SetParent(target, "attach_hitloc")
		polyp:SetOrigin( polyp:GetOrigin()+Vector(-1,-2,5) )
	else -- refresh polyp
		target.PolypAttached:SetMaxHealth(polypMax)
		target.PolypAttached:SetBaseMaxHealth(polypMax)
		target.PolypAttached:SetHealth(polypBase)
	end
end

function PolypCheck(keys)
	local polyp = keys.target
	local ability = keys.ability
	if polyp:GetHealth() == polyp:GetMaxHealth() then
		ability:ApplyDataDrivenModifier(keys.caster, polyp:GetMoveParent(), "modifier_proteus_polyp_damage", {duration = 5})
		polyp:GetMoveParent():RemoveModifierByName("modifier_proteus_polyp_protection")
		polyp:RemoveSelf()
	end
end

function PolypDamageBlock(keys)
	local victim = keys.unit
	local damage = keys.damage
	local polyp = victim.PolypAttached
	local damageBlock = damage
	if damageBlock > polyp:GetHealth() then damageBlock = polyp:GetHealth() end
	victim:SetHealth(victim:GetHealth() + damageBlock)
	polyp:SetHealth(polyp:GetHealth() - damage)
	if polyp:GetHealth() <= 0 then
		polyp:GetMoveParent():RemoveModifierByName("modifier_proteus_polyp_protection")
		polyp:RemoveSelf()
	end
end

function PolypBonusDamage(keys)
	local owner = keys.attacker
	local target = keys.target
	owner:RemoveModifierByName("modifier_proteus_polyp_damage")
	-- ApplyDamage({victim = target, attacker = owner, damage = keys.ability:GetSpecialValueFor("max_polyp_health"), damage_type = DAMAGE_TYPE_PHYSICAL, ability = keys.ability})
end