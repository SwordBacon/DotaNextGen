function BlankSpaceExpand( keys )
	local caster = keys.caster
	local ability = keys.ability
	local maxRadius = ability:GetSpecialValueFor("max_radius")
	local radiusPerSecond = ability:GetSpecialValueFor("radius_per_second")

	local modifier = "modifier_blank_space"
	local startRadius = ability:GetSpecialValueFor("start_radius")
	local currentRadius = startRadius

	Timers:CreateTimer(1/30, function()
		ability:CreateVisibilityNode(caster:GetAbsOrigin(), currentRadius, 2.0)  --Shiva's Guard's active provides 800 flying vision around the caster, which persists for 2 seconds.

		currentRadius = keys.caster.currentRadius + (radiusPerSecond /30)
		local nearby_enemy_units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, currentRadius, DOTA_UNIT_TARGET_TEAM_CUSTOM,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		for i, individual_unit in ipairs(nearby_enemy_units) do
			if not individual_unit:HasModifier("modifier_blank_space") then
				ApplyDamage({victim = individual_unit, attacker = keys.caster, damage = keys.BlastDamage, damage_type = DAMAGE_TYPE_MAGICAL,})
				
				--This impact particle effect should radiate away from the caster of Shiva's Guard.
				local shivas_guard_impact_particle = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, individual_unit)
				local target_point = individual_unit:GetAbsOrigin()
				local caster_point = individual_unit:GetAbsOrigin()
				ParticleManager:SetParticleControl(shivas_guard_impact_particle, 1, target_point + (target_point - caster_point) * 30)
				
				keys.ability:ApplyDataDrivenModifier(keys.caster, individual_unit, "modifier_blank_space", nil)
			end
		end
		
		if keys.caster.shivas_guard_current_blast_radius < keys.BlastFinalRadius then  --If the blast should still be expanding.
			return 1/30
		else  --The blast has reached or exceeded its intended final radius.
			keys.caster.shivas_guard_current_blast_radius = 0
			return nil
		end
	end)
end