function GardenCheck( keys )
	local caster = keys.caster
	local ability = keys.ability
	local health_cost = caster:GetMaxHealth()/200.0
	
	if caster:GetHealth() > health_cost then
		caster:ModifyHealth( caster:GetHealth() - health_cost, ability, false, 0 )
	else 
		caster:Stop()
		caster:RemoveModifierByName("modifier_garden_channel")
	end
end

function SetAbilityLevel( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target


	for i=0,5 do
		local flowerAbility = target:GetAbilityByIndex(i)
		flowerAbility:SetLevel(ability:GetLevel())
	end
end

function PlantSetHealth( keys )
	local caster = keys.caster
	local owner = caster:GetOwner()
	local target = keys.target
	local ability = keys.ability
	local abilityLevel = ability:GetLevel()
	local health = ability:GetLevelSpecialValueFor("flower_health", abilityLevel - 1 )
	local whiteDamage = ability:GetLevelSpecialValueFor("white_flower_damage", abilityLevel - 1 )
	local redDamage = ability:GetLevelSpecialValueFor("red_flower_damage", abilityLevel - 1 )
	
	print(target:GetUnitName())
	print(health)
	print(whiteDamage)
	print(redDamage)
	
	target:SetControllableByPlayer(owner:GetPlayerID(), true)
	target:SetBaseMaxHealth(health)
	if target:GetUnitName() == "white_flower" then
		target:SetBaseDamageMin(whiteDamage - 5)
		target:SetBaseDamageMax(whiteDamage + 5)
	elseif target:GetUnitName() == "red_flower" then
		target:SetBaseDamageMin(redDamage - 10)
		target:SetBaseDamageMax(redDamage + 10)
	end
end

function DamageCooldown( keys )
	local caster = keys.caster
	local ability = keys.ability

	ability:StartCooldown(3)
end

function PlantWhite( keys )
	local caster = keys.caster
	local owner = caster:GetOwner()
	local owner_ability = owner:GetAbilityByIndex(3)
	--local flower_health = owner_ability:GetLevelSpecialValueFor("flower_health", (ability:GetLevel() - 1))
	--local flower_damage = owner_ability:GetLevelSpecialValueFor("white_flower_damage", (ability:GetLevel() - 1))
	
	owner.white_flower_count = owner.white_flower_count or 0
	owner.white_flower_table = owner.white_flower_table or {}
	
	local max_flowers = 6
	local caster_location = caster:GetAbsOrigin()
	local white_flower = CreateUnitByName( "white_flower", caster_location, false, owner, owner, owner:GetTeamNumber() )
	owner_ability:ApplyDataDrivenModifier(owner, white_flower, "modifier_white_flower", {})
	--white_flower:SetBaseMaxHealth(flower_health)
	--white_flower:SetBaseDamageMax(flower_damage + 5)
	--white_flower:SetBaseDamageMin(flower_damage - 5)
	
	owner.white_flower_count = owner.white_flower_count + 1
	table.insert(owner.white_flower_table, white_flower)
	
	if owner.white_flower_count > max_flowers then
		owner.white_flower_table[1]:ForceKill(true)
	end

	
	caster:ForceKill(true)
end

function OnDestroyWhite( keys )
	local owner = keys.unit:GetOwner()
	local unit = keys.unit
	for i = 1, #owner.white_flower_table do
		if owner.white_flower_table[i] == unit then
			table.remove(owner.white_flower_table, i)
			owner.white_flower_count = owner.white_flower_count - 1
			break
		end
	end
end

function PlantRed( keys )
	local caster = keys.caster
	local owner = caster:GetOwner()
	local owner_ability = owner:GetAbilityByIndex(3)
	--local flower_health = owner_ability:GetLevelSpecialValueFor("flower_health", (ability:GetLevel() - 1))
	--local flower_damage = owner_ability:GetLevelSpecialValueFor("red_flower_damage", (ability:GetLevel() - 1))
	
	owner.red_flower_count = owner.red_flower_count or 0
	owner.red_flower_table = owner.red_flower_table or {}
	
	local max_flowers = 6
	local caster_location = caster:GetAbsOrigin()
	local red_flower = CreateUnitByName( "red_flower", caster_location, false, owner, owner, owner:GetTeamNumber() )
	owner_ability:ApplyDataDrivenModifier(owner, red_flower, "modifier_red_flower", {})
	--red_flower:SetBaseMaxHealth(flower_health)
	--red_flower:SetBaseDamageMax(flower_damage + 10)
	--red_flower:SetBaseDamageMin(flower_damage - 10)

	owner.red_flower_count = owner.red_flower_count + 1
	table.insert(owner.red_flower_table, red_flower)
	
	if owner.red_flower_count > max_flowers then
		owner.red_flower_table[1]:ForceKill(true)
	end

	caster:ForceKill(true)
end

function OnDestroyRed( keys )
	local owner = keys.unit:GetOwner()
	local unit = keys.unit
	for i = 1, #owner.red_flower_table do
		if owner.red_flower_table[i] == unit then
			table.remove(owner.red_flower_table, i)
			owner.red_flower_count = owner.red_flower_count - 1
			break
		end
	end
end

function PlantPink( keys )
	local caster = keys.caster
	local owner = caster:GetOwner()
	local owner_ability = owner:GetAbilityByIndex(3)
	--local flower_health = owner_ability:GetLevelSpecialValueFor("flower_health", (ability:GetLevel() - 1))
	
	owner.pink_flower_count = owner.pink_flower_count or 0
	owner.pink_flower_table = owner.pink_flower_table or {}
	
	local max_flowers = 4
	local caster_location = caster:GetAbsOrigin()
	local pink_flower = CreateUnitByName( "pink_flower", caster_location, false, owner, owner, owner:GetTeamNumber() )
	owner_ability:ApplyDataDrivenModifier(pink_flower, pink_flower, "modifier_pink_flower", {})
	--pink_flower:SetBaseMaxHealth(flower_health)

	owner.pink_flower_count = owner.pink_flower_count + 1
	table.insert(owner.pink_flower_table, pink_flower)
	
	if owner.pink_flower_count > max_flowers then
		owner.pink_flower_table[1]:ForceKill(true)
	end

	caster:ForceKill(true)
end

function FindHealUnits( keys ) -- currently unused
	local caster = keys.caster
	local distance = keys.distance
	local count = 0
	local max_count = 3
	local result = {}
	
	local nearby_allied_units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, distance,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	for i, unit in ipairs(nearby_allied_units) do 
		if unit:GetHealthPercentage() < 100 then
			table.insert(result, unit)
			count = count + 1
			if count == max_count then 
				return result 
			end
		end
		print(count)
	end
	return result
end

function OnDestroyPink( keys )
	local owner = keys.unit:GetOwner()
	local unit = keys.unit
	for i = 1, #owner.pink_flower_table do
		if owner.pink_flower_table[i] == unit then
			table.remove(owner.pink_flower_table, i)
			owner.pink_flower_count = owner.pink_flower_count - 1
			break
		end
	end
end

function PlantBlue( keys )
	local caster = keys.caster
	local owner = caster:GetOwner()
	local owner_ability = owner:GetAbilityByIndex(3)
	--local flower_health = owner_ability:GetLevelSpecialValueFor("flower_health", (ability:GetLevel() - 1))
	
	owner.blue_flower_count = owner.blue_flower_count or 0
	owner.blue_flower_table = owner.blue_flower_table or {}
	
	local max_flowers = 4
	local caster_location = caster:GetAbsOrigin()
	local blue_flower = CreateUnitByName( "blue_flower", caster_location, false, owner, owner, owner:GetTeamNumber() )
	owner_ability:ApplyDataDrivenModifier(blue_flower, blue_flower, "modifier_blue_flower", {})
	--blue_flower:SetBaseMaxHealth(flower_health)

	owner.blue_flower_count = owner.blue_flower_count + 1
	table.insert(owner.blue_flower_table, blue_flower)
	
	if owner.blue_flower_count > max_flowers then
		owner.blue_flower_table[1]:ForceKill(true)
	end

	caster:ForceKill(true)
end

function BlueFlowerRestoreMana( keys )
	keys.caster:EmitSound("DOTA_Item.ArcaneBoots.Activate")
	ParticleManager:CreateParticle("particles/items_fx/arcane_boots.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster)

	local nearby_allied_units = FindUnitsInRadius(keys.caster:GetTeam(), keys.caster:GetAbsOrigin(), nil, keys.ReplenishRadius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
	for i, individual_unit in ipairs(nearby_allied_units) do  --Restore mana and play a particle effect for every found ally.
		individual_unit:GiveMana(keys.ReplenishAmount)
		ParticleManager:CreateParticle("particles/items_fx/arcane_boots_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, individual_unit)
	end
end

function OnDestroyBlue( keys )
	local owner = keys.unit:GetOwner()
	local unit = keys.unit
	for i = 1, #owner.blue_flower_table do
		if owner.blue_flower_table[i] == unit then
			table.remove(owner.blue_flower_table, i)
			owner.blue_flower_count = owner.blue_flower_count - 1
			break
		end
	end
end

function PlantYellow( keys )
	local caster = keys.caster
	local owner = caster:GetOwner()
	local owner_ability = owner:GetAbilityByIndex(3)
	--local flower_health = owner_ability:GetLevelSpecialValueFor("flower_health", (ability:GetLevel() - 1))
	
	owner.yellow_flower_count = owner.yellow_flower_count or 0
	owner.yellow_flower_table = owner.yellow_flower_table or {}
	
	local max_flowers = 2
	local caster_location = caster:GetAbsOrigin()
	local yellow_flower = CreateUnitByName( "yellow_flower", caster_location, false, owner, owner, owner:GetTeamNumber() )
	owner_ability:ApplyDataDrivenModifier(yellow_flower, yellow_flower, "modifier_yellow_flower", {})
	--yellow_flower:SetBaseMaxHealth(flower_health)

	owner.yellow_flower_count = owner.yellow_flower_count + 1
	table.insert(owner.yellow_flower_table, yellow_flower)
	
	if owner.yellow_flower_count > max_flowers then
		owner.yellow_flower_table[1]:ForceKill(true)
	end

	caster:ForceKill(true)
end

function OnDestroyYellow( keys )
	local owner = keys.unit:GetOwner()
	local unit = keys.unit
	for i = 1, #owner.yellow_flower_table do
		if owner.yellow_flower_table[i] == unit then
			table.remove(owner.yellow_flower_table, i)
			owner.yellow_flower_count = owner.yellow_flower_count - 1
			break
		end
	end
end
function PlantPurple( keys )
	local caster = keys.caster
	local owner = caster:GetOwner()
	local owner_ability = owner:GetAbilityByIndex(3)
	--local flower_health = owner_ability:GetLevelSpecialValueFor("flower_health", (ability:GetLevel() - 1))
	
	owner.purple_flower_count = owner.purple_flower_count or 0
	owner.purple_flower_table = owner.purple_flower_table or {}
	
	local max_flowers = 2
	local caster_location = caster:GetAbsOrigin()
	local purple_flower = CreateUnitByName( "purple_flower", caster_location, false, owner, owner, owner:GetTeamNumber() )
	owner_ability:ApplyDataDrivenModifier(purple_flower, purple_flower, "modifier_purple_flower", {})
	--purple_flower:SetBaseMaxHealth(flower_health)

	owner.purple_flower_count = owner.purple_flower_count + 1
	table.insert(owner.purple_flower_table, purple_flower)
	
	if owner.purple_flower_count > max_flowers then
		owner.purple_flower_table[1]:ForceKill(true)
	end

	caster:ForceKill(true)
end

function OnDestroyPurple( keys )
	local owner = keys.unit:GetOwner()
	local unit = keys.unit
	for i = 1, #owner.purple_flower_table do
		if owner.purple_flower_table[i] == unit then
			table.remove(owner.purple_flower_table, i)
			owner.purple_flower_count = owner.purple_flower_count - 1
			break
		end
	end
end

function DestroyGarden( keys )
	keys.caster:ForceKill(true)
end