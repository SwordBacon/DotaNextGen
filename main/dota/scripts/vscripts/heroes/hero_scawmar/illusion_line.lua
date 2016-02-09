function CreateIllusions( keys )
	local caster = keys.caster
	local ability = keys.ability
	local player = caster:GetPlayerID()
	
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )
	local delay = ability:GetLevelSpecialValueFor("illusion_delay", ability:GetLevel() - 1 )
	local incomingDamage = ability:GetLevelSpecialValueFor("incoming_damage", ability:GetLevel() - 1 )
	local outgoingDamage = ability:GetLevelSpecialValueFor("outgoing_damage", ability:GetLevel() - 1 )
	
	local origin = caster:GetAbsOrigin()
	local forwardVec = caster:GetForwardVector()
	local sideVec = caster:GetRightVector()
	local randomPos = RandomInt(1,5)

	local vec1 = origin + sideVec * 350
	local vec2 = origin + sideVec * 175
	local vec3 = origin
	local vec4 = origin + sideVec * -175
	local vec5 = origin + sideVec * -350

	caster:Stop()
	ProjectileManager:ProjectileDodge(caster)
	caster:AddNoDraw()
	caster:AddNewModifier(caster, ability, "modifier_disabled_invulnerable", {Duration = delay})
	
	Timers:CreateTimer(delay, function()
		caster:RemoveNoDraw()
		if randomPos == 1 then
			FindClearSpaceForUnit(caster, vec1, false) 
			caster:MoveToPositionAggressive(vec1)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_fire_spawn", {})
		else 
			local illusion1 = CreateUnitByName(caster:GetName(), vec1, true, caster, nil, caster:GetTeamNumber())
			illusion1:SetPlayerID(caster:GetPlayerID())
			illusion1:SetControllableByPlayer(player, true)
			FindClearSpaceForUnit(illusion1, vec1, false) 
			illusion1:SetForwardVector(forwardVec)
			local casterLevel = caster:GetLevel()
			for i=1,casterLevel-1 do
				illusion1:HeroLevelUp(false)
			end

			-- Set the skill points to 0 and learn the skills of the caster
			illusion1:SetAbilityPoints(0)
			for abilitySlot=0,15 do
				local ability = caster:GetAbilityByIndex(abilitySlot)
				if ability ~= nil then 
					local abilityLevel = ability:GetLevel()
					local abilityName = ability:GetAbilityName()
					local illusionAbility1 = illusion1:FindAbilityByName(abilityName)
					illusionAbility1:SetLevel(abilityLevel)
				end
			end

			-- Recreate the items of the caster
			for itemSlot=0,5 do
				local item = caster:GetItemInSlot(itemSlot)
				if item ~= nil then
					local itemName = item:GetName()
					local newItem = CreateItem(itemName, illusion, illusion)
					illusion1:AddItem(newItem)
				end
			end
			illusion1:SetHealth(caster:GetHealth())		
			illusion1:SetOwner(caster)
			illusion1:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
			ability:ApplyDataDrivenModifier(caster, illusion1, "modifier_illusion_line_death", {})
			illusion1:MakeIllusion()
			
		end

		if randomPos == 2 then
			FindClearSpaceForUnit(caster, vec2, false) 
			caster:MoveToPositionAggressive(vec2)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_fire_spawn", {})
		else 
			local illusion2 = CreateUnitByName(caster:GetName(), vec2, true, caster, nil, caster:GetTeamNumber())
			illusion2:SetPlayerID(caster:GetPlayerID())
			illusion2:SetControllableByPlayer(player, true)
			FindClearSpaceForUnit(illusion2, vec2, false) 	
			illusion2:SetForwardVector(forwardVec)	
			local casterLevel = caster:GetLevel()
			for i=1,casterLevel-1 do
				illusion2:HeroLevelUp(false)
			end

			-- Set the skill points to 0 and learn the skills of the caster
			illusion2:SetAbilityPoints(0)
			for abilitySlot=0,15 do
				local ability = caster:GetAbilityByIndex(abilitySlot)
				if ability ~= nil then 
					local abilityLevel = ability:GetLevel()
					local abilityName = ability:GetAbilityName()
					local illusionAbility2 = illusion2:FindAbilityByName(abilityName)
					illusionAbility2:SetLevel(abilityLevel)
				end
			end

			-- Recreate the items of the caster
			for itemSlot=0,5 do
				local item = caster:GetItemInSlot(itemSlot)
				if item ~= nil then
					local itemName = item:GetName()
					local newItem = CreateItem(itemName, illusion, illusion)
					illusion2:AddItem(newItem)
				end
			end
			illusion2:SetHealth(caster:GetHealth())		
			illusion2:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
			ability:ApplyDataDrivenModifier(caster, illusion2, "modifier_illusion_line_death", {})
			illusion2:SetOwner(caster)
			illusion2:MakeIllusion()
			
		end

		if randomPos == 3 then
			FindClearSpaceForUnit(caster, vec3, false) 
			caster:MoveToPositionAggressive(vec3)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_fire_spawn", {})
		else 
			local illusion3 = CreateUnitByName(caster:GetName(), vec3, true, caster, nil, caster:GetTeamNumber())
			illusion3:SetPlayerID(caster:GetPlayerID())
			illusion3:SetControllableByPlayer(player, true)
			FindClearSpaceForUnit(illusion3, vec3, false) 
			illusion3:SetForwardVector(forwardVec)		
			local casterLevel = caster:GetLevel()
			for i=1,casterLevel-1 do
				illusion3:HeroLevelUp(false)
			end

			-- Set the skill points to 0 and learn the skills of the caster
			illusion3:SetAbilityPoints(0)
			for abilitySlot=0,15 do
				local ability = caster:GetAbilityByIndex(abilitySlot)
				if ability ~= nil then 
					local abilityLevel = ability:GetLevel()
					local abilityName = ability:GetAbilityName()
					local illusionAbility3 = illusion3:FindAbilityByName(abilityName)
					illusionAbility3:SetLevel(abilityLevel)
				end
			end

			-- Recreate the items of the caster
			for itemSlot=0,5 do
				local item = caster:GetItemInSlot(itemSlot)
				if item ~= nil then
					local itemName = item:GetName()
					local newItem = CreateItem(itemName, illusion, illusion)
					illusion3:AddItem(newItem)
				end
			end
			illusion3:SetHealth(caster:GetHealth())	
			illusion3:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
			ability:ApplyDataDrivenModifier(caster, illusion3, "modifier_illusion_line_death", {})
			illusion3:SetOwner(caster)
			illusion3:MakeIllusion()
		end

		if randomPos == 4 then
			FindClearSpaceForUnit(caster, vec4, false) 
			caster:MoveToPositionAggressive(vec4)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_fire_spawn", {})
		else 
			local illusion4 = CreateUnitByName(caster:GetName(), vec4, true, caster, nil, caster:GetTeamNumber())
			illusion4:SetPlayerID(caster:GetPlayerID())
			illusion4:SetControllableByPlayer(player, true)
			FindClearSpaceForUnit(illusion4, vec4, false) 
			illusion4:SetForwardVector(forwardVec)		
			local casterLevel = caster:GetLevel()
			for i=1,casterLevel-1 do
				illusion4:HeroLevelUp(false)
			end

			-- Set the skill points to 0 and learn the skills of the caster
			illusion4:SetAbilityPoints(0)
			for abilitySlot=0,15 do
				local ability = caster:GetAbilityByIndex(abilitySlot)
				if ability ~= nil then 
					local abilityLevel = ability:GetLevel()
					local abilityName = ability:GetAbilityName()
					local illusionAbility4 = illusion4:FindAbilityByName(abilityName)
					illusionAbility4:SetLevel(abilityLevel)
				end
			end

			-- Recreate the items of the caster
			for itemSlot=0,5 do
				local item = caster:GetItemInSlot(itemSlot)
				if item ~= nil then
					local itemName = item:GetName()
					local newItem = CreateItem(itemName, illusion, illusion)
					illusion4:AddItem(newItem)
				end
			end
			illusion4:SetHealth(caster:GetHealth())		
			illusion4:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
			ability:ApplyDataDrivenModifier(caster, illusion4, "modifier_illusion_line_death", {})
			illusion4:SetOwner(caster)
			illusion4:MakeIllusion()
		end

		if randomPos == 5 then
			FindClearSpaceForUnit(caster, vec5, false)
			caster:MoveToPositionAggressive(vec5)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_fire_spawn", {})		
		else 
			local illusion5 = CreateUnitByName(caster:GetName(), vec5,  true, caster, nil, caster:GetTeamNumber())
			illusion5:SetPlayerID(caster:GetPlayerID())
			illusion5:SetControllableByPlayer(player, true)
			FindClearSpaceForUnit(illusion5, vec5, false) 		
			illusion5:SetForwardVector(forwardVec)			
			local casterLevel = caster:GetLevel()
			for i=1,casterLevel-1 do
				illusion5:HeroLevelUp(false)
			end

			-- Set the skill points to 0 and learn the skills of the caster
			illusion5:SetAbilityPoints(0)
			for abilitySlot=0,15 do
				local ability = caster:GetAbilityByIndex(abilitySlot)
				if ability ~= nil then 
					local abilityLevel = ability:GetLevel()
					local abilityName = ability:GetAbilityName()
					local illusionAbility5 = illusion5:FindAbilityByName(abilityName)
					illusionAbility5:SetLevel(abilityLevel)
				end
			end

			-- Recreate the items of the caster
			for itemSlot=0,5 do
				local item = caster:GetItemInSlot(itemSlot)
				if item ~= nil then
					local itemName = item:GetName()
					local newItem = CreateItem(itemName, illusion, illusion)
					illusion5:AddItem(newItem)
				end
			end
			illusion5:SetHealth(caster:GetHealth())		
			illusion5:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
			ability:ApplyDataDrivenModifier(caster, illusion5, "modifier_illusion_line_death", {})
			illusion5:SetOwner(caster)
			illusion5:MakeIllusion()
		end
	end)
end

function CheckDeath( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local target = keys.unit
	local ability = keys.ability

	if target:GetHealth() < 2 then
		
		local projTable = {
            EffectName = "particles/scawmar_illusion_line_fireball.vpcf",
            Ability = ability,
            Target = attacker,
            Source = target,
            bDodgeable = true,
            bProvidesVision = false,
            vSpawnOrigin = target:GetAbsOrigin(),
            iMoveSpeed = 700,
            iVisionRadius = 0,
            iVisionTeamNumber = caster:GetTeamNumber(),
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
        }
        ProjectileManager:CreateTrackingProjectile(projTable)
        target:ForceKill(false)
	end

end