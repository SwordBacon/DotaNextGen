function CapeSpin( keys )
	local caster = keys.caster
	local radius = keys.radius
	local ability = keys.ability
	local duration = keys.duration
	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

	for i = 1, #targets do
		ability:ApplyDataDrivenModifier(caster, targets[i], "modifier_cape_spin", {Duration = duration})
	end 
end

function SpinEffect( event )
	local caster		= event.target
	local ability		= event.ability

	local duration	= event.duration
	local modifier	= "modifier_cape_spin"
	local casterAngles	= caster:GetAngles()

	local startTime = GameRules:GetGameTime()

	caster:SetContextThink( DoUniqueString("updateDevilsCape"), function ( )

		local elapsedTime = GameRules:GetGameTime() - startTime

		-- Interrupted
		if not caster:HasModifier( modifier ) then
			return nil
		end

		local yaw = casterAngles.y + (elapsedTime * 360)
		
		caster:SetAngles(casterAngles.x, yaw, casterAngles.z )

		return 0.03
	end, 0 )
end