function edgewalkerCascadeEvent_OnSpellStart(event)
	-- caster and ability handle
	local hCaster, hAbility = event.caster, event.ability

	-- projectile direction vector (caster to cursor)
	local vDirection = hAbility:GetCursorPosition() - hCaster:GetOrigin()
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()

	-- projectile origin level to attack pos height
	local vAttachPosHeight = hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("attach_attack1")).z
	hAbility.vSpawnPoint = hCaster:GetOrigin()
	hAbility.vSpawnPoint.z = vAttachPosHeight

	-- ability instance vars saved in ability table for reference in other functions
	hAbility.fProjectileSpeed = hAbility:GetSpecialValueFor("projectile_speed")
	hAbility.fProjectileDistance = hAbility:GetSpecialValueFor("projectile_distance")
	hAbility.fPortalDuration = hAbility:GetSpecialValueFor("portal_duration")
	hAbility.fPortalRadius = hAbility:GetSpecialValueFor("portal_radius")

	if hAbility.fProjectileDistance > (hAbility:GetCursorPosition() - hCaster:GetOrigin()):Length2D() then
		hAbility.fProjectileDistance = (hAbility:GetCursorPosition() - hCaster:GetOrigin()):Length2D()
	end

	-- projectile table
	local tProjectileInfo = {
		EffectName 			= "",
		Ability 			= hAbility,
		vSpawnOrigin 		= hAbility.vSpawnPoint,
		vVelocity 			= vDirection * hAbility.fProjectileSpeed,
		fDistance 			= hAbility.fProjectileDistance,
		fStartRadius		= 0,
		fEndRadius			= 0,
		Source 				= hCaster
	}
	
	-- saved projectile index for determining projectile finish vector location
	hAbility.nProjectileIndex = ProjectileManager:CreateLinearProjectile(tProjectileInfo)
end

function edgewalkerCascadeEvent_OnProjectileFinish(event)
	-- handles
	local hAbility, hCaster = event.ability, event.caster

	-- determine vLocation from projectile velocity
	local vDirection = ProjectileManager:GetLinearProjectileVelocity(hAbility.nProjectileIndex) / hAbility.fProjectileSpeed
	local vLocation = hAbility.vSpawnPoint + vDirection * hAbility.fProjectileDistance

	-- for debugging  
	DebugDrawSphere(vLocation, Vector(255,0,0), 255, hAbility.fPortalRadius, false, hAbility.fPortalDuration)

	-- particle
	local nParticleIndex = ParticleManager:CreateParticle("particles/heroes/hero_edgewalker/edgewalker_cascade_event_portal.vpcf", PATTACH_ABSORIGIN, hAbility:GetCaster())
	ParticleManager:SetParticleControl(nParticleIndex, 0, vLocation)
	Timers:CreateTimer(hAbility.fPortalDuration, function() 
		ParticleManager:DestroyParticle(nParticleIndex, false)
		ParticleManager:ReleaseParticleIndex(nParticleIndex)
	end)

	-- modifier implementation
	hAbility:ApplyDataDrivenModifier(hCaster, hCaster, "modifier_cascade_event_portal_tooltip", {})

	-- portal table to store portal locations
	hCaster.tPortalHistory = hCaster.tPortalHistory or {}
	local t = hCaster.tPortalHistory
	local fNow = GameRules:GetGameTime()
	t[fNow] = vLocation

	-- delete portal location kv after portal duration
	for k in pairs(t) do
		if tonumber(k) <= GameRules:GetGameTime() - hAbility.fPortalDuration then
			t[k] = nil
		end
	end	
end