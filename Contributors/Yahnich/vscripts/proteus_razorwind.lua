function RazorWind( keys )
	local caster = keys.caster
	local target = keys.target
	local caster_location = caster:GetAbsOrigin()
	local target_point = target:GetAbsOrigin()
	local ability = keys.ability
	local modifier = keys.modifier
	-- Distance calculations
	local speed = ability:GetSpecialValueFor("push_speed")
	local distance = 350 + 0.5*( ability:GetCastRange() - (target_point - caster_location):Length2D() )
	local direction = (target_point - caster_location):Normalized()
	if distance > ability:GetSpecialValueFor("max_push_distance") then distance = ability:GetSpecialValueFor("max_push_distance") end
	-- Saving the data in the ability
	ability.distance = distance
	EmitSoundOn("Hero_NagaSiren.Ensnare.Cast", caster)
	EmitSoundOn("Hero_NagaSiren.Ensnare.Target", target)
	local abilityFX = ParticleManager:CreateParticle("particles/proteus_razorwind_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	local projectileTable = {
        Ability = ability,
        EffectName = "particles/proteus_razorwind_projectile.vpcf",
        vSpawnOrigin = target_point,
        fDistance = 850,
        fStartRadius = 200,
        fEndRadius = 200,
        fExpireTime = GameRules:GetGameTime() + 3,
        Source = caster,
		bHasFrontalCone = true,
        bReplaceExisting = false,
        bProvidesVision = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        iUnitTargetType = DOTA_UNIT_TARGET_ALL,
        bDeleteOnHit = false,
        vVelocity = caster:GetForwardVector() * 850
    }
    local projectile = ProjectileManager:CreateLinearProjectile( projectileTable )
	ParticleManager:SetParticleControl(abilityFX , 0, caster:GetAbsOrigin())
	ability.speed = speed / 30 -- 1/30 is how often the motion controller ticks
	ability.direction = direction
	ability.traveled_distance = 0
	
	local healdamage = ability:GetSpecialValueFor("damage_heal")
	ability:ApplyDataDrivenModifier(caster, target, modifier, {})
	if target:GetTeamNumber() == caster:GetTeamNumber() then
		target:Heal(healdamage, caster)
	else
		ApplyDamage({victim = target, attacker = caster, damage = healdamage, damage_type = ability:GetAbilityDamageType(), ability = ability})
	end
end

function RazorWindMotion(keys)
	local caster = keys.target
	local ability = keys.ability
	-- Move the caster while the distance traveled is less than the original distance upon cast
	local original_position = caster:GetAbsOrigin()
	if ability.traveled_distance < ability.distance then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.direction * ability.speed)
		ability.traveled_distance = ability.traveled_distance + ability.speed
		local abilityFX = ParticleManager:CreateParticle("particles/proteus_razorwind_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(abilityFX , 0, caster:GetAbsOrigin())
	else
		-- Remove the motion controller once the distance has been traveled
		caster:InterruptMotionControllers(true)
		caster:RemoveModifierByName("modifier_proteus_razorwind_push")
	end
end