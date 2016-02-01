function PlainsRunnerInitialize( keys )
	local caster = keys.caster
	local ability = keys.ability

		
	caster.thinker_location = caster:GetAbsOrigin()
	caster.distance = 0
	caster.thinker_altitude = GetGroundHeight(caster:GetAbsOrigin(), caster)
	caster.altitude = 0
	caster.forwardVec = caster:GetForwardVector().y

	local level = ability:GetLevel()

	if level ~= 1 then
		caster:RemoveModifierByName('modifier_movespeed_cap_' .. level - 1)
	else 
		stacks = 0
	end
	caster:AddNewModifier(caster, ability, 'modifier_movespeed_cap_' .. level, {})

	
end

function PlainsRunnerDistanceCheck( keys )
	local caster = keys.caster
	local ability = keys.ability
	
	local caster_location = caster:GetAbsOrigin()
	local caster_vector = caster:GetForwardVector().y
	caster.distance = (caster_location - caster.thinker_location):Length2D() + caster.distance
	local check_distance = ability:GetLevelSpecialValueFor("distance", (ability:GetLevel() - 1))
	
	local caster_altitude = GetGroundHeight(caster:GetAbsOrigin(), caster)
	caster.altitude = (caster_altitude - caster.thinker_altitude) + caster.altitude

	local angle_difference = (caster_vector - caster.forwardVec) * 180
	local pi_angle = angle_difference / math.pi
	-- See the opening block comment for why I do this. Basically it's to turn negative angles into positive ones and make the math simpler.
	result_angle = math.abs(pi_angle)

	
	while caster.distance >= check_distance do
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_plains_runner_bonus", {})
		stacks = stacks + 1
		caster:SetModifierStackCount("modifier_plains_runner_bonus", ability, math.floor(stacks))
		caster.distance = caster.distance - check_distance
		if caster.distance > 1200 then caster.distance = 0 end
	end

	while caster.altitude >= 6.4 do
		stacks = stacks * (0.96593632892)
		if stacks < 1 and caster:HasModifier("modifier_plains_runner_bonus") then
			caster:RemoveModifierByName("modifier_plains_runner_bonus")
		else 
			caster:SetModifierStackCount("modifier_plains_runner_bonus", ability, math.floor(stacks))
		end
		caster.altitude = caster.altitude - 6.4
	end
	
	while caster.altitude <= -6.4 do
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_plains_runner_bonus", {})
		stacks = stacks + 0.5
		caster:SetModifierStackCount("modifier_plains_runner_bonus", ability, math.floor(stacks))
		caster.altitude = caster.altitude + 6.4
	end

	while result_angle > 5 and not caster:HasModifier("modifier_thrill_active") do
		stacks = stacks * (0.961)
		caster:SetModifierStackCount("modifier_plains_runner_bonus", ability, math.floor(stacks))
		result_angle = result_angle - 5
		print(result_angle)
	end
	
	caster.thinker_altitude = GetGroundHeight(caster:GetAbsOrigin(), caster)
	caster.thinker_location = caster:GetAbsOrigin()
	caster.forwardVec = caster:GetForwardVector().y
	
end

function PlainsRunnerResetStacks ( )
	stacks = 0
end

function PlainsRunnerAgility( keys )
	local caster = keys.caster
	local ability = keys.ability
	local agi_bonus = ability:GetLevelSpecialValueFor("agility_bonus", ability:GetLevel() - 1)/100
	local extra_movespeed = caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed()) - caster:GetBaseMoveSpeed()

	local total_bonus = math.floor(extra_movespeed * agi_bonus)

	if total_bonus > 0 then
		if not caster:HasModifier("modifier_plains_runner_agility") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_plains_runner_agility", {})
		end
		caster:SetModifierStackCount("modifier_plains_runner_agility", ability, total_bonus)
	else
		if caster:HasModifier("modifier_plains_runner_agility") then
			caster:RemoveModifierByName("modifier_plains_runner_agility")
		end
	end
end

modifier_movespeed_cap_1 = class({})
modifier_movespeed_cap_2 = class({})
modifier_movespeed_cap_3 = class({})
modifier_movespeed_cap_4 = class({})
LinkLuaModifier("modifier_movespeed_cap_1", "heroes/hero_veera/plains_runner", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_movespeed_cap_2", "heroes/hero_veera/plains_runner", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_movespeed_cap_3", "heroes/hero_veera/plains_runner", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_movespeed_cap_4", "heroes/hero_veera/plains_runner", LUA_MODIFIER_MOTION_NONE)

function modifier_movespeed_cap_1:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_movespeed_cap_1:GetModifierMoveSpeed_Max( params )
    return 600
end

function modifier_movespeed_cap_1:GetModifierMoveSpeed_Limit( params )
    return 600
end

function modifier_movespeed_cap_1:IsHidden()
    return true
end

function modifier_movespeed_cap_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end



function modifier_movespeed_cap_2:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_movespeed_cap_2:GetModifierMoveSpeed_Max( params )
    return 650
end

function modifier_movespeed_cap_2:GetModifierMoveSpeed_Limit( params )
    return 650
end

function modifier_movespeed_cap_2:IsHidden()
    return true
end

function modifier_movespeed_cap_2:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end



function modifier_movespeed_cap_3:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_movespeed_cap_3:GetModifierMoveSpeed_Max( params )
    return 700
end

function modifier_movespeed_cap_3:GetModifierMoveSpeed_Limit( params )
    return 700
end

function modifier_movespeed_cap_3:IsHidden()
    return true
end

function modifier_movespeed_cap_3:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end


function modifier_movespeed_cap_4:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_movespeed_cap_4:GetModifierMoveSpeed_Max( params )
    return 750
end

function modifier_movespeed_cap_4:GetModifierMoveSpeed_Limit( params )
    return 750
end

function modifier_movespeed_cap_4:IsHidden()
    return true
end

function modifier_movespeed_cap_4:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end