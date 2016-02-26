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

--//////////////////////////////////
--//Author: Nibuja
--//Date: 23.02.2016
--//Project: Line Intersection
--//////////////////////////////////
--//Description:
--//'b' and 'c' are points, which can be locations of units, etc or any other points in the world
--//'a' is the location of the player, which will be tested, if he walks over the line
--//Use this with a timer in a short interval or set the tolerance higher
function TestForLineIntersection(a, b, c)
 
    local caster_loc = a
    local Test_Point = b
    local Test_Point_2 = c
 
    --/////Create Line
    local Vect_1 = Test_Point_2 - Test_Point
 
    --/////Check t1 & t2
    local t1 = ((caster_loc.x - Test_Point.x) / Vect_1.x) * 10
    local t2 = ((caster_loc.y - Test_Point.y) / Vect_1.y) * 10
 
    local t1r = math.floor(t1)
    local t2r = math.floor(t2)
 
    --/////Check for Intersection
    local tolerance = -(  10  )  --edit here for more or less tolerance
    local i = tolerance
    while i <= -(tolerance) do     
        if (t1r == t2r or t1r== (t2r + i)) then
            --/// Anything wanted in here
        end
        i = i + 1
    end
end