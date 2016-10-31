function SpecialBeamCannon( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local length = length or 200
	local height = height or 100
	local angle = 45
	local newAngle = newAngle or 0

	pointA = caster:GetAbsOrigin()
	vectorA = caster:GetForwardVector()

	pointB = (pointA + vectorA * length) + Vector(0,0,height)

	pointC = pointB + Vector(0,0,height)

	vectorB = (pointC - pointB):Normalized()

	rotate_position = pointB + vectorB * height
	rotate_angle = QAngle(0, 0, newAngle)
	pointD = RotatePosition(pointB, rotate_angle, rotate_position)

	target:SetAbsOrigin(pointD)
	newAngle = newAngle + angle


	RotateOrientation(QAngle QAngle_1, QAngle QAngle_2)
end

