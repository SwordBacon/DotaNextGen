function GravityEffect(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	if target:GetTeam() == caster:GetTeam() and not target:IsBuilding() then 
		local pushLength = ability:GetSpecialValueFor("push_length")
		target:EmitSound("Hero_Dark_Seer.Vacuum")
		local modifier = target:AddNewModifier(caster,ability,"modifier_item_forcestaff_active",{ push_length = pushLength })
		local particle = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_jewel_of_aeons/fv_time_walk_jewel.vpcf",PATTACH_ABSORIGIN_FOLLOW,target)
		modifier:AddParticle(particle, false, false, 1, false, false)
	else
		ability.pullSpeed = ability:GetSpecialValueFor("pull_speed") / 30

		if caster:HasModifier("modifier_item_gravity_blade_pull") then
			caster:RemoveModifierByName("modifier_item_gravity_blade_pull") 
		end

		if target:HasModifier("modifier_item_gravity_blade_pull") then
			target:RemoveModifierByName("modifier_item_gravity_blade_pull")
		end

		if not target:IsBuilding() then
			caster:EmitSound("Hero_Dark_Seer.Vacuum")
			caster:InterruptMotionControllers(false)
			
			target:EmitSound("Hero_Dark_Seer.Vacuum")
			target:InterruptMotionControllers(false)

			ability:ApplyDataDrivenModifier(caster,caster,"modifier_item_gravity_blade_pull",{Duration = -1})
			ability:ApplyDataDrivenModifier(caster,target,"modifier_item_gravity_blade_pull",{Duration = -1})

			
		else
			caster:EmitSound("Hero_Dark_Seer.Vacuum")
			caster:SetForwardVector((target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized())
			local modifier = caster:AddNewModifier(caster,ability,"modifier_item_forcestaff_active",{ push_length = pushLength })
			local particle = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_jewel_of_aeons/fv_time_walk_jewel.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
			modifier:AddParticle(particle, false, false, 1, false, false)
			Timers:CreateTimer(0, function()
				if (caster:GetOrigin() - target:GetOrigin()):Length() <= 200 then
					caster:RemoveModifierByName("modifier_item_forcestaff_active")
					return
				end
				return 0.03
			end)
		end

		local cooldown = ability:GetCooldownTimeRemaining() / 2
		ability:EndCooldown()
		ability:StartCooldown(cooldown)

		if not caster:IsRangedAttacker() then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_double_strike", {Duration = 2.0})
		end

		caster:MoveToTargetToAttack(target)
	end
end

function GravityPull( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	if caster ~= target then
		local modifier1 = caster:FindModifierByName("modifier_item_gravity_blade_pull")
		local modifier2 = target:FindModifierByName("modifier_item_gravity_blade_pull")

		local particle1 = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_jewel_of_aeons/fv_time_walk_jewel.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
		local particle2 = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_jewel_of_aeons/fv_time_walk_jewel.vpcf",PATTACH_ABSORIGIN_FOLLOW,target)

		modifier1:AddParticle(particle1, false, false, 1, false, false)
		modifier2:AddParticle(particle2, false, false, 1, false, false)
		Timers:CreateTimer(0, function()
			if (caster:GetOrigin() - target:GetOrigin()):Length() > 128 and (caster:GetOrigin() - target:GetOrigin()):Length() < 1200 then
				local enemyVector = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Normalized()
				local casterVector = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
				caster:SetAbsOrigin(caster:GetAbsOrigin() + casterVector * ability.pullSpeed)
				target:SetAbsOrigin(target:GetAbsOrigin() + enemyVector * ability.pullSpeed)
				return 0.03
			else
				FindClearSpaceForUnit(caster,caster:GetAbsOrigin(),true)
				FindClearSpaceForUnit(target,target:GetAbsOrigin(),true)
				caster:RemoveModifierByName("modifier_item_gravity_blade_pull")
				target:RemoveModifierByName("modifier_item_gravity_blade_pull")
				return nil
			end
		end)
	end
end