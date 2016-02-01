function TrapSend( keys )
	local caster = keys.caster
	local ability = keys.ability
	local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 2000, 
	DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
	for i, individual_unit in ipairs(units) do
		if individual_unit:HasModifier("modifier_box_2_aura") and not individual_unit:HasModifier("modifier_roshan_bash") and not individual_unit:IsMagicImmune() then
			individual_unit:Stop()
			FindClearSpaceForUnit(individual_unit, caster:GetAbsOrigin(), false)
		end
	end
end

function TrapReceive( keys )
	local caster = keys.caster
	local ability = keys.ability
	local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 2000, 
	DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
	for i, individual_unit in ipairs(units) do
		if individual_unit:HasModifier("modifier_box_1_aura") and not individual_unit:HasModifier("modifier_roshan_bash") and not individual_unit:IsMagicImmune() then
			individual_unit:Stop()
			FindClearSpaceForUnit(individual_unit, caster:GetAbsOrigin(), false)
		end
	end
end

function ItemTrapSend( keys )
	local caster = keys.caster
	local ability = keys.ability
	local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 2000, 
	DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
	for i, individual_unit in ipairs(units) do
		if individual_unit:HasModifier("item_modifier_box_2_aura") and not individual_unit:HasModifier("modifier_roshan_bash") and not individual_unit:IsMagicImmune() then
			individual_unit:Stop()
			FindClearSpaceForUnit(individual_unit, caster:GetAbsOrigin(), false)
		end
	end
end

function ItemTrapReceive( keys )
	local caster = keys.caster
	local ability = keys.ability
	local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 2000, 
	DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
	for i, individual_unit in ipairs(units) do
		if individual_unit:HasModifier("item_modifier_box_1_aura") and not individual_unit:HasModifier("modifier_roshan_bash") and not individual_unit:IsMagicImmune() then
			individual_unit:Stop()
			FindClearSpaceForUnit(individual_unit, caster:GetAbsOrigin(), false)
		end
	end
end

function LevelUpAbility( keys )
	local ability = keys.target:GetAbilityByIndex(0)
	ability:SetLevel(1)
end

function SetForwardVector( keys )
	local caster = keys.caster
	local target = keys.target

	local casterVec = caster:GetForwardVector()
	target:SetForwardVector(casterVec)
end

function SetBackwardVector( keys )
	local caster = keys.caster
	local target = keys.target

	local casterVec = (caster:GetOrigin() - target:GetOrigin()):Normalized()
	target:SetForwardVector(casterVec)
end