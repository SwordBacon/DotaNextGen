--Hero: Vardor
--Ability: Piercing Shot
--Author: Nibuja
--Date: 29.12.2015

--[[ PiercingShotCast
Creates a tracking projectile, firing at a POINT or TARGET
]]
function PiercingShotCast(keys)

	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	target_point = keys.target_points[1]
	enemies_found = nil
	target_bool = false

	local ability_partner = caster:FindAbilityByName("vardor_mental_thrusts")	
	local yari_stack = caster:GetModifierStackCount("modifier_hold_yari", ability_partner)


	if yari_stack > 0 then

	hero_search = FindUnitsInRadius(caster:GetTeamNumber(), target_point, nil,  50, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO,  DOTA_UNIT_TARGET_FLAG_NOT_SUMMONED, FIND_CLOSEST, false)


	if #hero_search == 1 then


		
		target_bool = true

		local lance_projectile_tracking = keys.lance_projectile_tracking

		local lance_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
		local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)
		local area_of_effect = ability:GetLevelSpecialValueFor("AOE", ability_level)
		local arrow_width = ability:GetLevelSpecialValueFor("radius", ability_level)
		local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
		local direction = (target_point - caster_location):Normalized()
		local distance = caster_location - target_point
		local duration = ability:GetLevelSpecialValueFor("duration_spear", ability_level)
		local modifierName2 = "modifier_thinker"
		local lance_projectile2 = keys.lance_projectile_tracking
		local dmg_Table = {
							attacker = caster,
							damage = damage,
							damage_type = DAMAGE_TYPE_MAGICAL,
							}
		
		for _,hero in pairs(hero_search) do
			local projectileTable = 
			{
				Source = caster,
				Target = hero,
				Ability = ability,	
				EffectName = lance_projectile2,
        		iMoveSpeed = lance_speed * 2,
				vSourceLoc= caster_location,                -- Optional (HOW)
				bDrawsOnMinimap = false,                          -- Optional
        		bDodgeable = false,                                -- Optional
        		bIsAttack = false,                                -- Optional
        		bVisibleToEnemies = true,                         -- Optional
        		bReplaceExisting = false,                         -- Optional
				bProvidesVision = true,                           -- Optional
				iVisionRadius = 400,                              -- Optional
				iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
			}
			
			ProjectileManager:CreateTrackingProjectile(projectileTable)
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_stuck", {Duration = duration})
			dmg_Table.victim = hero
			ApplyDamage(dmg_Table)
		end
		ability:ApplyDataDrivenModifier(caster, caster, modifierName2, {Duration = duration + 5})
		


		

	else


		local target_teams = ability:GetAbilityTargetTeam()
		local target_types = ability:GetAbilityTargetType()
		local target_flags = ability:GetAbilityTargetFlags()

		local modifierName1 = "modifier_prevent_movement"

		local lance_projectile = keys.lance_projectile

	


		local lance_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
		local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)
		local area_of_effect = ability:GetLevelSpecialValueFor("AOE", ability_level)
		local arrow_width = ability:GetLevelSpecialValueFor("radius", ability_level)
		local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
		local direction = (target_point - caster_location):Normalized()
		local distance = caster_location - target_point
		local duration = ability:GetLevelSpecialValueFor("duration", ability_level)


		local projectileTable = 
		{
			EffectName = lance_projectile,
    	    Ability = ability,
        	vSpawnOrigin = caster_location,
        	vVelocity = direction * lance_speed,
    	    fDistance = (caster_location - target_point):Length(), 
    	    fStartRadius = arrow_width,
    	    fEndRadius = arrow_width,
    		Source = caster,
    	    bHasFrontalCone = false,
    	    bReplaceExisting = false,
    	    iUnitTargetTeam = ability:GetAbilityTargetTeam(),
    	    iUnitTargetFlags = ability:GetAbilityTargetFlags(),
    	    iUnitTargetType = ability:GetAbilityTargetType(),
   	     	bProvidesVision = true,
    	    iVisionRadius = vision_radius,
        	iVisionTeamNumber = caster:GetTeamNumber()
		}
		ProjectileManager:CreateLinearProjectile(projectileTable)



		enemies_found = FindUnitsInRadius(caster:GetTeamNumber(), target_point, nil, area_of_effect, target_teams, target_types, target_flags, FIND_CLOSEST, false) 

		
	end

	

	caster:SetModifierStackCount("modifier_hold_yari", ability_partner, yari_stack - 1)

	local yari_stack = caster:GetModifierStackCount("modifier_hold_yari", ability_partner)

	if yari_stack < 1 then

	SubAbility(caster, ability)

	end


	else 

	FireGameEvent("show_center_message", {message = "No more Yari's!", duration = 2, clear_message_queue = true})
	end
end

function LanceHit(keys)
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target

	local target_teams = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
	local target_flags = ability:GetAbilityTargetFlags()

	local modifierName1 = "modifier_prevent_movement"

	local lance_projectile = keys.lance_projectile
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local lance_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)
	local area_of_effect = ability:GetLevelSpecialValueFor("AOE", ability_level)
	local arrow_width = ability:GetLevelSpecialValueFor("radius", ability_level)
	local duration_spear = ability:GetLevelSpecialValueFor("duration_spear", ability_level)
	local direction = (target_point - caster_location):Normalized()
	local distance = caster_location - target_point
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)

	local damage_table = {}
		damage_table.attacker = caster
		damage_table.ability = ability
		damage_table.damage_type = ability:GetAbilityDamageType() 
		damage_table.damage = damage 




	for _,hero in pairs(enemies_found) do
		damage_table.victim = hero
		ApplyDamage(damage_table)
		ability:ApplyDataDrivenModifier(caster, hero, modifierName1, {Duration = duration})
	end  




	dummy = CreateUnitByName("dummy_unit" , target_point, false, caster, caster, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_dummy_health", nil)
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_dummy_slow_aura", nil)
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_kill", {Duration = duration_spear})


	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_light_strike_array_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
end

function SubAbility(caster, ability)
	local sub_ability_name = "vardor_return_of_the_yari"
	local main_ability_name = ability:GetAbilityName()


	caster:SwapAbilities(sub_ability_name, main_ability_name , true, false)
end

function SubAbilityEnd(keys)
	local caster = keys.caster
	local ability = keys.ability
	local sub_ability_name = "vardor_return_of_the_yari"
	local main_ability_name = ability:GetAbilityName()
	local modifier_yari = "modifier_yari"
	local modifierName2 = "modifier_thinker"


	local ability_partner = caster:FindAbilityByName("vardor_mental_thrusts")	
	local yari_stack = caster:GetModifierStackCount("modifier_hold_yari", ability_partner)

	caster:SetModifierStackCount("modifier_hold_yari", ability, yari_stack + 1)

	if target_bool == false and not caster:HasModifier("modifier_celestial") then
		dummy:ForceKill(false)
	end

	caster:RemoveModifierByName(modifier_yari)
	
	if yari_stack < 1 then
		caster:SwapAbilities(main_ability_name, sub_ability_name, true, false)
	end

	caster:RemoveModifierByName(modifierName2)
	ability:ApplyDataDrivenModifier(caster, caster, modifierName2, {Duration = 4})

	for _,hero in pairs(hero_search) do
		hero:RemoveModifierByName("modifier_stuck")
	end

	
end

function SwapBack(keys)
	local caster = keys.caster
	local ability = keys.ability
	local sub_ability_name = "vardor_return_of_the_yari"
	local main_ability_name = ability:GetAbilityName()
	local ability_partner = caster:FindAbilityByName("vardor_mental_thrusts")	
	local yari_stack = caster:GetModifierStackCount("modifier_hold_yari", ability_partner)

	if target_bool == false and not caster:HasModifier("modifier_celestial") then
		dummy:ForceKill(false)
	end


	caster:SwapAbilities(main_ability_name, sub_ability_name, true, false)


	local modifier_yari = "modifier_yari"
	local modifierName1 = "modifier_thinker"

	caster:RemoveModifierByName(modifier_yari)

	caster:RemoveModifierByName(modifierName1)

	for _,hero in pairs(hero_search) do
		hero:RemoveModifierByName("modifier_stuck")
	end

	if caster:HasModifier("modifier_celestial") then
		caster:SetModifierStackCount("modifier_hold_yari", ability, yari_stack + 2)
	else
		caster:SetModifierStackCount("modifier_hold_yari", ability, yari_stack + 1)
	end

end



function OnUpgrade(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = keys.ability:GetLevel()
	local sub_ability_name = "vardor_return_of_the_yari"
	local ability_handle = caster:FindAbilityByName(sub_ability_name)
	local sub_ability_level = ability_handle:GetLevel()
	local modifier_1 = "modifier_hold_yari"
	local ability_partner = caster:FindAbilityByName("vardor_mental_thrusts")

	if sub_ability_level ~= ability_level then
        ability_handle:SetLevel(ability_level)
    end

	if caster:HasModifier(modifier_1) then
	else
		ability_partner:ApplyDataDrivenModifier(caster, caster, modifier_1, {})
	end

	local current_stack = caster:GetModifierStackCount( modifier_1 , ability_partner )
	if current_stack == 0 then
		caster:SetModifierStackCount(modifier_1, ability_partner, 1)
	end 
end

--[[ TEST
function CDOTA_BaseNPC:FindModifierByName(vardor_mental_thrusts)
	modifier_1 = "modifier_mental_thrusts_target_datadriven"
	modifier_2 = "mental_thrusts_debuff"


end
]]

function ApplyMentalThrusts(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = keys.ability:GetLevel()
	local ability_partner = caster:FindAbilityByName("vardor_mental_thrusts")
	local ability_partner_level = ability_partner:GetLevel()
	--local modifier_1 = caster:FindModifierByName("modifier_mental_thrusts_target_datadriven")
	--local modifier_2 = caster:FindModifierByName("mental_thrusts_debuff")
	local modifier_1 = "modifier_mental_thrusts_target_datadriven"
	local modifier_2 = "mental_thrusts_debuff"
	local modifier_3 = "modifier_stuck"
	local duration_spear = ability:GetLevelSpecialValueFor("duration_spear", ability_level)


	if ability_partner_level > 0 then
	for _,hero in pairs(hero_search) do
		ability_partner:ApplyDataDrivenModifier(caster, hero, modifier_1, {Duration=duration_spear})
		ability_partner:ApplyDataDrivenModifier(caster, hero, modifier_2, {Duration=duration_spear})
		local current_stack = hero:GetModifierStackCount( modifier_1 , ability_partner )
		if current_stack < 0 then
		hero:SetModifierStackCount(modifier_1, ability_partner, 1)
		hero:SetModifierStackCount(modifier_2, ability_partner, 1)
		end
	end
	end
	


end

function IncreaseMentalThrusts(keys)
	
	local caster = keys.caster

	local modifier_1 = "modifier_mental_thrusts_target_datadriven"
	local modifier_2 = "mental_thrusts_debuff"
	local ability_partner = caster:FindAbilityByName("vardor_mental_thrusts")
	local ability_partner_level = ability_partner:GetLevel()
	
	if ability_partner_level > 0 then
	for _,hero in pairs(hero_search) do
		local current_stack = hero:GetModifierStackCount(modifier_1, ability_partner)

		if hero:HasModifier(modifier_1) and hero:IsAlive() then
			if current_stack > 0 then
				ability_partner:ApplyDataDrivenModifier( caster, hero, modifier_1, {})
				ability_partner:ApplyDataDrivenModifier( caster, hero, modifier_2, {})
				hero:SetModifierStackCount( modifier_1, ability_partner , current_stack + 1)
				hero:SetModifierStackCount( modifier_2, ability_partner , current_stack + 1)
			else
				ability_partner:ApplyDataDrivenModifier( caster, hero, modifier_1, {})
				ability_partner:ApplyDataDrivenModifier( caster, hero, modifier_2, {})
				hero:SetModifierStackCount( modifier_1, ability_partner, 1)
				hero:SetModifierStackCount( modifier_2, ability_partner, 1)
			end
		end
	end
	end

			
	
end

