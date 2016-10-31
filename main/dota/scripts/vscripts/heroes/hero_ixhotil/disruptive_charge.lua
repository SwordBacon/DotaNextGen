function MoveForward ( keys )
	local caster = keys.caster
	local ability = keys.ability
	local abilityLevel = ability:GetLevel() - 1

	local speed = ability:GetLevelSpecialValueFor("movespeed", abilityLevel)
	local distance = speed  * 0.03

	local forwardVec = caster:GetForwardVector()
	local origin = GetGroundPosition(caster:GetAbsOrigin(), caster)

	local vector = origin + forwardVec * distance

	caster:SetAbsOrigin(vector)
	GridNav:DestroyTreesAroundPoint(origin, 200, false)
end

function ResetAngles( keys )
	local caster = keys.caster
	caster:SetAngles(0, caster:GetAngles().y, caster:GetAngles().z)
	caster:StopSound("Hero_Ixhotil.Disruptive_Charge.Effect")
end

function StompShake( keys )
	ScreenShake(keys.caster:GetAbsOrigin(), 1500, 1000, 1.5, 2000, 0, true)
end

function Panic( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local abilityLevel = ability:GetLevel() - 1

	local origin = target:GetAbsOrigin()
	local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
	local vector = origin + direction * 100

	local order = 
	{
		UnitIndex = target:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		TargetIndex = vector
	}

	ExecuteOrderFromTable(order)
	target:MoveToPosition(vector)
end

function FindScepter( keys )
	local caster = keys.caster
	local ability = keys.ability

	if caster:HasScepter() then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_disruptive_charge_launch_scepter", {Duration = ability:GetDuration()})
	else 
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_disruptive_charge_launch", {Duration = ability:GetDuration()})
	end
end