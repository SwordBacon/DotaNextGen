function CancelAttack (keys)
	local caster = keys.caster
	local attacker = keys.target

	if caster:GetTeamNumber() ~= attacker:GetTeamNumber() then
		caster:Stop()
	end
end

function ThrowHammer (keys)
	local caster = keys.caster
	local ability = keys.ability

	hammer_point = keys.target_points[1]

	if utherhammer == nil or utherhammer:IsNull() then
		utherhammer = CreateUnitByName("npc_hammer_unit",caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
		ability:ApplyDataDrivenModifier(caster,utherhammer,"modifier_hammer_moving_dummy",{duration = 1})
		ability:ApplyDataDrivenModifier(caster,utherhammer,"modifier_hammer_dummy",{duration = -1})
		utherdirection = (hammer_point - caster:GetAbsOrigin()):Normalized()
	else
		ability:ApplyDataDrivenModifier(caster,utherhammer,"modifier_hammer_moving_dummy",{duration = 1})
		utherdirection = (hammer_point - utherhammer:GetAbsOrigin() ):Normalized()
		caster:RemoveModifierByName("modifier_hammer_stationary_dummy")
	end
	local hammer_speed = (hammer_point - utherhammer:GetAbsOrigin()):Length2D() * 0.1
	local hammer_size = ability:GetLevelSpecialValueFor("Hammer_Size",ability:GetLevel()-1)

	local projectileTable =
			{
			EffectName = "",
			Ability = ability,
			vSpawnOrigin = utherhammer:GetAbsOrigin(),
			vVelocity = (hammer_speed * 10) * utherdirection,
			fDistance = hammer_speed * 10,
			fStartRadius = hammer_size,
			fEndRadius = hammer_size,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = true,
			bProvidesVision = true,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			iVisionRadius = hammer_size,
			iVisionTeamNumber = caster:GetTeamNumber()
			}
	local projectileID = ProjectileManager:CreateLinearProjectile( projectileTable )

	--Cooldown on innate to prevent bugs
	caster:FindAbilityByName("Hail_Back"):StartCooldown(1)
end

function HammerPosition (keys)
	local ability = keys.ability
	local caster = keys.caster
	local hammer_speed = (hammer_point - utherhammer:GetAbsOrigin()):Length2D() * 0.1
	local hammer_size = ability:GetLevelSpecialValueFor("Hammer_Size",ability:GetLevel()-1)

	utherhammer:SetAbsOrigin(utherhammer:GetAbsOrigin() + utherdirection * hammer_speed)
end



function PickUpHammer (keys)
	local caster = keys.caster
	if (caster:GetAbsOrigin() - utherhammer:GetAbsOrigin()):Length2D() < 200 then
		caster:RemoveModifierByName("modifier_hammer_thrown")
		caster:RemoveModifierByName("modifier_hammer_stationary_dummy")
		utherhammer:RemoveSelf()
	end

end
function RemoveHammer (keys)
	if not utherhammer:IsNull() then
		utherhammer:RemoveSelf()
	end
end

function ReturnHammer (keys)
	if utherhammer ~= nil and not utherhammer:IsNull() then
		local caster = keys.caster
		local ability = caster:FindAbilityByName("Hurl_Hammer")
		local hammer_speed = (caster:GetAbsOrigin() - utherhammer:GetAbsOrigin()):Length2D() * 0.1
		local direction = (caster:GetAbsOrigin() - utherhammer:GetAbsOrigin()):Normalized()
		local hammer_size = ability:GetLevelSpecialValueFor("Hammer_Size",ability:GetLevel()-1)

		local projectileTable =
				{
				EffectName = "",
				Ability = ability,
				vSpawnOrigin = utherhammer:GetAbsOrigin(),
				vVelocity = (hammer_speed * 10) * direction,
				fDistance = hammer_speed * 10,
				fStartRadius = hammer_size,
				fEndRadius = hammer_size,
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = true,
				bProvidesVision = true,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				iVisionRadius = hammer_size,
				iVisionTeamNumber = caster:GetTeamNumber()
				}
		local projectileID = ProjectileManager:CreateLinearProjectile( projectileTable )

		Timers:CreateTimer(function()
			local direction = (caster:GetAbsOrigin() - utherhammer:GetAbsOrigin()):Normalized()
			if caster:HasModifier("modifier_hammer_stationary_dummy") and not utherhammer:IsNull() then
				utherhammer:SetAbsOrigin(utherhammer:GetAbsOrigin() + direction * hammer_speed)
				return 0.1
			end

			return nil
		end)
	end
end
