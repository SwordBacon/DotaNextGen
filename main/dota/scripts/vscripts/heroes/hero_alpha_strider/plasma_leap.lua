function LeapDistance( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = keys.target_points[1]
	local leap_distance = (caster:GetAbsOrigin() - point):Length2D()

	-- Clears any current command
	caster:Stop()
	local start_position = GetGroundPosition(caster:GetAbsOrigin() , caster)
   
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 2, caster:GetAbsOrigin())
	
	-- Physics
	local origin = caster:GetAbsOrigin()
	local direction = caster:GetForwardVector()
	local velocity = leap_distance / (0.9)
	local end_time = 0.9
	local time_elapsed = 0
	local jump = 48 + (leap_distance/96)
	local fall = jump / 15
	
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_plasma_leap", {})
	ability:StartCooldown(0.9)

	-- Move the unit
	Timers:CreateTimer(0, function()
		local ground_position = GetGroundPosition(caster:GetAbsOrigin() , caster)
		time_elapsed = time_elapsed + 0.03
		origin = caster:GetAbsOrigin()
		position = origin + direction * velocity / 30
		caster:SetAbsOrigin(position + Vector(0,0,jump))
		jump = jump - fall
		
		if time_elapsed > end_time then
			jump = jump * 1.1
			if caster:GetAbsOrigin().z - ground_position.z <= 0 then
				caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin() , caster))
				FindClearSpaceForUnit(caster, origin, false)
				caster:RemoveModifierByName("modifier_plasma_leap")
				local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControl(particle2, 0, caster:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle2, 1, caster:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle2, 2, caster:GetAbsOrigin())
				return nil
			end
		end
		if caster:GetAbsOrigin().z - ground_position.z <= 0 then
			caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin() , caster))
		end
		return 0.03
	end)
end