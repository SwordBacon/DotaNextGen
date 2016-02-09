function TyphoonSpinEffect( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	if target:IsMagicImmune() or target:HasModifier("modifier_roshan_bash") then return end
	
	-- calculates rotation
	local origin = caster:GetAbsOrigin()
	local distance = target:GetAbsOrigin() - caster:GetAbsOrigin()
	local distanceLength = distance:Length2D()
	local randomSpeed = (RandomInt(5,20) * 60) / distanceLength
	local increaseSpeed = randomSpeed / 10
	local variableSpeed = increaseSpeed
	
	
	-- calculates elevation
	local jump = RandomInt(10,20)/10.0
	local gravity = 0.5
	local height = 0
	
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )
	local damageElevation = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1 ) / 100.0
	print(damageElevation)
	
	ability:CreateVisibilityNode(caster:GetAbsOrigin(), radius, duration)

	Timers:CreateTimer(0, function()
		local ground_position = GetGroundPosition(target:GetAbsOrigin() , target)
		local height = height + jump
		local origin = caster:GetAbsOrigin()
		local distance = target:GetAbsOrigin() - origin
		local vector = distance:Normalized()
		local newDistanceLength = distance:Length()
		local rotate_position = origin + vector * newDistanceLength
		local rotate_angle = QAngle(0, randomSpeed, 0)
		local rotate_point = RotatePosition(origin, rotate_angle, rotate_position)
		local randomDistance = newDistanceLength + increaseSpeed

		if caster:HasModifier("modifier_typhoon") then
			jump = jump + (gravity / 5)
			target:SetAbsOrigin(rotate_point + Vector(0,0,jump) )
			fallDamage = target:GetAbsOrigin().z * damageElevation
			print(fallDamage)
			randomSpeed = randomSpeed + variableSpeed
			variableSpeed = variableSpeed / 1.03
		else
			jump = jump - (gravity * 3)
			randomDistance = randomDistance + 12
			rotate_position = origin + vector * randomDistance
			rotate_point = RotatePosition(origin, rotate_angle, rotate_position)
			target:SetAbsOrigin(rotate_point + Vector(0,0,jump) )
			if randomSpeed >= increaseSpeed then
				randomSpeed = randomSpeed - increaseSpeed
			else
				randomSpeed = 0
			end
		end
		if target:GetAbsOrigin().z - ground_position.z <= 0 and not caster:HasModifier("modifier_typhoon") then 
			target:RemoveModifierByName("modifier_typhoon_stunned")
			target:SetAbsOrigin(ground_position)
			FindClearSpaceForUnit(target, target:GetAbsOrigin(), false) 
			
			local damageTable = {}
			damageTable.attacker = caster
			damageTable.victim = target
			damageTable.damage_type = ability:GetAbilityDamageType()
			damageTable.ability = ability
			damageTable.damage = fallDamage
			print(damageTable)
	
			ApplyDamage(damageTable)
			return nil
		end
		return 1/30
	end)
end