function GoreLeft( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	-- Determine if target is within 90 degrees of the caster's forward vector, else does not apply effects.
	local targetLoc = target:GetAbsOrigin()
	local casterLoc = caster:GetAbsOrigin()


	local target_angle = (targetLoc - casterLoc):Normalized().y
	local caster_vector = caster:GetForwardVector()
	local caster_angle = caster_vector.y
	-- Convert the radian to degrees.
	local angle_difference = (target_angle - caster_angle) * 180
	local pi_angle = angle_difference / math.pi
	-- See the opening block comment for why I do this. Basically it's to turn negative angles into positive ones and make the math simpler.
	result_angle = math.abs(pi_angle)
	print(result_angle)


	-- if the target is in front of ixhotil, they will be relocated to the left side over 0.3 seconds
 	if result_angle < 60 then

 		rotate_position = casterLoc + caster_vector * 225 -- Radius
		rotate_angle = QAngle(0, -45, 0)
		rotate_point = RotatePosition(casterLoc, rotate_angle, rotate_position)

		 travel_distance = (targetLoc - rotate_point):Length()
		 vector = (targetLoc - rotate_point):Normalized()
		 travel_speed = targetLoc + vector * (travel_distance / 10)


 		if target:IsHero() then
 			ability:ApplyDataDrivenModifier(caster, target, "modifier_gore_left", {Duration = 3.0})
 		else
 			ability:ApplyDataDrivenModifier(caster, target, "modifier_gore_left", {Duration = 6.0})
 		end
	 	FindClearSpaceForUnit(target, rotate_point, false)
	 	GridNav:DestroyTreesAroundPoint(rotate_point, 200, false)
 	end
end

function GoreRight( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	-- Determine if target is within 90 degrees of the caster's forward vector, else does not apply effects.
	local targetLoc = target:GetAbsOrigin()
	local casterLoc = caster:GetAbsOrigin()


	local target_angle = (targetLoc - casterLoc):Normalized().y
	local caster_vector = caster:GetForwardVector()
	local caster_angle = caster_vector.y
	-- Convert the radian to degrees.
	local angle_difference = (target_angle - caster_angle) * 180
	local pi_angle = angle_difference / math.pi
	-- See the opening block comment for why I do this. Basically it's to turn negative angles into positive ones and make the math simpler.
	result_angle = math.abs(pi_angle)
	print(result_angle)


	-- if the target is in front of ixhotil, they will be relocated to the left side over 0.3 seconds
 	if result_angle < 60 then

 		rotate_position = casterLoc + caster_vector * 225 -- Radius
		rotate_angle = QAngle(0, 45, 0)
		rotate_point = RotatePosition(casterLoc, rotate_angle, rotate_position)

		travel_distance = (targetLoc - rotate_point):Length()
		vector = (targetLoc - rotate_point):Normalized()
		travel_speed = targetLoc + vector * (travel_distance / 10)


 		if target:IsHero() then
 			ability:ApplyDataDrivenModifier(caster, target, "modifier_gore_right", {Duration = 3.0})
 		else
 			ability:ApplyDataDrivenModifier(caster, target, "modifier_gore_right", {Duration = 6.0})
 		end

	 	FindClearSpaceForUnit(target, rotate_point, false)
	 	GridNav:DestroyTreesAroundPoint(rotate_point, 200, false)
 	end
end