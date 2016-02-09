function SetForwardVector( keys )
	local caster = keys.caster
	local casterVec = caster:GetForwardVector()
	local target = keys.target
	target:SetForwardVector(casterVec)
end

function KillPuppetsOnSpawm( keys )
	local caster = keys.caster
	local targets = caster.skeletons or {}
	for _,unit in pairs(targets) do	
		if unit and IsValidEntity(unit) then
			unit:ForceKill(true)
			end
		end
	-- Reset table
	caster.skeletons = {}
end

function KillPuppets( keys )
	keys.target:ForceKill(false)
end

function PuppetDistanceCheck( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local casterLoc = caster:GetAbsOrigin()
	local targetLoc = target:GetAbsOrigin()
	local maxDistance = ability:GetLevelSpecialValueFor("max_distance", ability:GetLevel() - 1)
	local distance = (casterLoc - targetLoc):Length2D()

	if distance > maxDistance then
		target:ForceKill(false)
	end
end

function PuppetDeathBonus( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	if target:GetUnitName() == "skeleton_puppet" then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_puppet_attackspeed_bonus", {})
	end
end