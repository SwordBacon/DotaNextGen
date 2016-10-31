function Guard_Table(keys)
	keys.caster.Guard_Reflected_units = {}
end
 
function Guard_Reflect(keys)
	local caster = keys.caster
	local attacker = keys.attacker
	local damageTaken = keys.DamageTaken
	local ability = keys.ability

	caster:SetHealth( caster:GetHealth() + damageTaken )
 
	if not caster.Guard_Reflected_units[ attacker:entindex() ] then
        caster:PerformAttack(attacker, true, true, true, false, false)
        local particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/pw_blossom_sword/juggernaut_omni_slash_tgt.vpcf",PATTACH_OVERHEAD_FOLLOW,attacker)
        ability:ApplyDataDrivenModifier( caster, attacker, "modifier_guard_reflected", { } )
        caster.Guard_Reflected_units[ attacker:entindex() ] = attacker
    end
end