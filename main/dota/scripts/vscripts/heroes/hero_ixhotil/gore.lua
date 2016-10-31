function LevelUpAbility( event )
	local caster = event.caster
	local this_ability = event.ability		
	local this_abilityName = this_ability:GetAbilityName()
	local this_abilityLevel = this_ability:GetLevel()

	-- The ability to level up
	local ability_name_1 = event.ability_name_1
	local ability_handle_1 = caster:FindAbilityByName(ability_name_1)	
	local ability_level_1 = ability_handle_1:GetLevel()

	-- Check to not enter a level up loop
	if ability_level_1 ~= this_abilityLevel then
		ability_handle_1:SetLevel(this_abilityLevel)
	end
end

function GoreLeft( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	-- Determine if target is within 90 degrees of the caster's forward vector, else does not apply effects.
	local targetLoc = target:GetAbsOrigin()
	local casterLoc = caster:GetAbsOrigin()


	local direction = (targetLoc - casterLoc):Normalized()
	local forward_vector = caster:GetForwardVector()
	local result_angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y)


	-- if the target is in front of ixhotil, they will be relocated to the left side over 0.3 seconds
 	if result_angle < 90 then

 		rotate_position = casterLoc + forward_vector * 225 -- Radius
		rotate_angle = QAngle(0, -45, 0)
		rotate_point = RotatePosition(casterLoc, rotate_angle, rotate_position)

		travel_distance = (targetLoc - rotate_point):Length()
		vector = (targetLoc - rotate_point):Normalized()
		travel_speed = targetLoc + vector * (travel_distance / 10)

		if not target:IsMagicImmune() and not target:HasModifier("modifier_roshan_bash") then
	 		if target:IsHero() then
	 			ability:ApplyDataDrivenModifier(caster, target, "modifier_gore_left", {Duration = 3.0})
	 		else
	 			ability:ApplyDataDrivenModifier(caster, target, "modifier_gore_left", {Duration = 6.0})
	 		end
		 	FindClearSpaceForUnit(target, rotate_point, false)
		 	GridNav:DestroyTreesAroundPoint(rotate_point, 200, false)
		else
			ability:ApplyDataDrivenModifier(caster, target, "modifier_gore_left", {Duration = 0.05})
		end
 	end
end

function GoreRight( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	-- Determine if target is within 90 degrees of the caster's forward vector, else does not apply effects.
	local targetLoc = target:GetAbsOrigin()
	local casterLoc = caster:GetAbsOrigin()

	
	local direction = (targetLoc - casterLoc):Normalized()
	local forward_vector = caster:GetForwardVector()
	local result_angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y)


	-- if the target is in front of ixhotil, they will be relocated to the right side
 	if result_angle < 90 then
 		rotate_position = casterLoc + forward_vector * 225 -- Radius
		rotate_angle = QAngle(0, 45, 0)
		rotate_point = RotatePosition(casterLoc, rotate_angle, rotate_position)

		travel_distance = (targetLoc - rotate_point):Length()
		vector = (targetLoc - rotate_point):Normalized()
		travel_speed = targetLoc + vector * (travel_distance / 10)

		if not target:IsMagicImmune() and not target:HasModifier("modifier_roshan_bash") then
	 		if target:IsHero() then
	 			ability:ApplyDataDrivenModifier(caster, target, "modifier_gore_right", {Duration = 3.0})
	 		else
	 			ability:ApplyDataDrivenModifier(caster, target, "modifier_gore_right", {Duration = 6.0})
	 		end

		 	FindClearSpaceForUnit(target, rotate_point, false)
		 	GridNav:DestroyTreesAroundPoint(rotate_point, 200, false)
		else
		 	ability:ApplyDataDrivenModifier(caster, target, "modifier_gore_right", {Duration = 0.1})
		end
 	end
end

function Particles( keys )
	local caster = keys.caster
	local ability = keys.ability
	local effectName = keys.Particle
	local forwardVec = caster:GetForwardVector()

	local particle = ParticleManager:CreateParticle(effectName, PATTACH_ABSORIGIN,caster)
	ParticleManager:SetParticleControl(particle,0,caster:GetAbsOrigin() + Vector(0, 0, 100))
end