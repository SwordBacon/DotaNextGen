function LevelUpAbility( keys )
	local caster = keys.caster
	local ability = keys.ability
end

function SUMMONTHEONETRUEICEFROG( keys )
	local caster = keys.caster
	local player = caster:GetPlayerID()
	local ability = keys.ability
	local unit_name = caster:GetUnitName()

	local time = 0
	local maxTime = 15

	-- Mango count
	local mango_3_count = 6
	local mango_2_count = 2
	local mango_1_count = 5
	local mango_count = 1

	-- Mango circle
	local mango_3_circumference = 6 -- x6 rows
	local mango_2_circumference = 9 -- x3 rows
	local mango_1_circumference = 3 -- x1 rows
	local mango_circumference = 3

	-- Mango rows
	local mango_3_rows = 6
	local mango_2_rows = 4
	local mango_1_rows = 2

	-- Mango circle radius
	local mango_3_radius = 900
	local mango_2_radius = 500
	local mango_1_radius = 425
	local mango_radius = 128

	-- Mango spread distance
	local mango_3_spread = 50
	local mango_2_spread = 25
	local mango_1_spread = 32.2

	local point = keys.target_points[1]
	local forwardVec = keys.caster:GetForwardVector()
	ability:CreateVisibilityNode(point, mango_3_radius + 322, maxTime + 10)

	-- Mango delay
	local delay3 = 5
	local delay2 = 3.5
	local delay1 = 2.5
	local delay = 1

	-- Camera effects
	local camera_distance = 1200
	local cameraDelay = 5


	-- PART 1 - Spawning the Mangos
	local item = CreateItem("item_enchanted_mango",nil,nil)
	local drop = CreateItemOnPositionForLaunch(point, item)
	item:LaunchLoot(false, 322, 0.75, point)
	Timers:CreateTimer(maxTime, function()
		if not item:IsNull() then
			item:Kill()
			if not drop:IsNull() then drop:Kill() end
		end
	end)

	Timers:CreateTimer(delay2, function()
		GridNav:DestroyTreesAroundPoint(point, 600, true)
	end)

	local rotateVar3 = 0
	local spreadVar3 = 0
	local rotateOffsetVar3 = 0
	local spreadAngle3 = 0

	for i = 1, mango_3_count do
		for j = 0, mango_3_circumference do
			for k = 0, mango_3_rows do
				local rotate_distance = point + forwardVec * (mango_3_radius + spreadVar3)

				local rotate_angle = QAngle(0,rotateVar3 + rotateOffsetVar3 + spreadAngle3,0)
				rotateVar3 = rotateVar3 + 360/mango_3_circumference
				local rotate_position = RotatePosition(point, rotate_angle, rotate_distance)

				Timers:CreateTimer(delay3, function()
					local item = CreateItem("item_mango",nil,nil)
					local drop = CreateItemOnPositionForLaunch(point, item)
					item:LaunchLoot(false, 750, delay3 / 5, rotate_position)
					Timers:CreateTimer(maxTime, function()
						if not item:IsNull() then
							item:Kill()
							if not drop:IsNull() then drop:Kill() end
						end
					end)
				end)	
			end
			spreadAngle3 = spreadAngle3 + 2
			delay3 = delay3 + 0.1
			spreadVar3 = spreadVar3 + mango_3_spread

		end
		rotateOffsetVar3 = rotateOffsetVar3 + 5
		spreadVar3 = 0
	end

	local rotateVar2 = 0
	local spreadVar2 = 0
	local spreadAngle2 = 0
	for i=1, mango_2_count do
		rotateVar2 = rotateVar2 + 30
	    spreadVar2 = 0
		for j = 0, mango_2_circumference do
			for k = 0, mango_2_rows do
				local rotate_distance = point + forwardVec * (mango_2_radius + spreadVar2)

				local rotate_angle = QAngle(0,rotateVar2 + spreadAngle2,0)
				rotateVar2 = rotateVar2 + 360/mango_2_circumference
				local rotate_position = RotatePosition(point, rotate_angle, rotate_distance)

				Timers:CreateTimer(delay2, function()
					local item = CreateItem("item_mango",nil,nil)
					local drop = CreateItemOnPositionForLaunch(point, item)
					item:LaunchLoot(false, 322, 0.75, rotate_position)
					Timers:CreateTimer(maxTime, function()
						if not item:IsNull() then
							item:Kill()
							if not drop:IsNull() then drop:Kill() end
						end
					end)
				end)
			end
			spreadAngle2 = spreadAngle2 - 1
			delay2 = delay2 + 0.1
			spreadVar2 = spreadVar2 + mango_2_spread
		end
	end

	local rotateVar1 = 0
	local rotateOffsetVar1 = 0
	local spreadVar1 = 0
	local spreadAngle1 = 0
	for i=1, mango_1_count do
		rotateVar1 = rotateVar1 + 30
		spreadVar1 = 0
		for j = 0, mango_1_circumference do
			for k = 0, mango_1_rows do
				local rotate_distance = point + forwardVec * (mango_1_radius + spreadVar1)

				local rotate_angle = QAngle(0,rotateVar1 + spreadAngle1 + rotateOffsetVar1,0)
				rotateVar1 = rotateVar1 + 360/mango_1_circumference
				local rotate_position = RotatePosition(point, rotate_angle, rotate_distance)

				Timers:CreateTimer(delay1, function()
					local item = CreateItem("item_mango",nil,nil)
					local drop = CreateItemOnPositionForLaunch(point, item)
					item:LaunchLoot(false, 322, 0.75, rotate_position)
					Timers:CreateTimer(maxTime, function()
						if not item:IsNull() then
							item:Kill()
							if not drop:IsNull() then drop:Kill() end
						end
					end)
				end)
			end
			spreadAngle1 = spreadAngle1 + 10
			delay1 = delay1 + 0.05
			spreadVar1 = spreadVar1
		end
		rotateOffsetVar1 = rotateOffsetVar1 + 15
	end

	for i=1, mango_count do
		local rotateVar = 0
		for j = 0, mango_circumference do
			local rotate_distance = point + forwardVec * mango_radius

			local rotate_angle = QAngle(0,rotateVar,0)
			rotateVar = rotateVar + 360/mango_circumference
			local rotate_position = RotatePosition(point, rotate_angle, rotate_distance)

			Timers:CreateTimer(delay, function()
				local item = CreateItem("item_mango",nil,nil)
				local drop = CreateItemOnPositionForLaunch(point, item)
				item:LaunchLoot(false, 322, 0.75, rotate_position)
				Timers:CreateTimer(maxTime, function()
					if not item:IsNull() then
						item:Kill()
						if not drop:IsNull() then drop:Kill() end
					end
				end)
			end)
		end
	end


	-- PART 2 - Dynamic Camera Changes

	Timers:CreateTimer(0, function()
		time = time + 1/30

		if time < maxTime then
			return 1/30
		else
			return nil
		end
	end)

	Timers:CreateTimer(cameraDelay, function()
		if time < 9 then
			camera_distance = camera_distance + 10
			GameRules:GetGameModeEntity():SetCameraDistanceOverride( camera_distance )
			return 1/30
		elseif time < 12 then
			camera_distance = camera_distance - 2
			GameRules:GetGameModeEntity():SetCameraDistanceOverride( camera_distance )
			return 1/30
		elseif time < 14 then
			camera_distance = camera_distance - 8
			GameRules:GetGameModeEntity():SetCameraDistanceOverride( camera_distance )
			return 1/30
		elseif time < maxTime then
			camera_distance = camera_distance - 16
			GameRules:GetGameModeEntity():SetCameraDistanceOverride( camera_distance )
			return 1/30
		else
			camera_distance = 1200
			GameRules:GetGameModeEntity():SetCameraDistanceOverride( camera_distance )
			return nil
		end
	end)




	-- PART 3 - Spawning heroes to autocast spells
	-- Setup a table of potential spawn positions

	-- Spawn Count
	local pugnaCount = 5
	local wispCount = 3
	local ODCount = 8
	local scawCount = 9
	
	-- Spawn Rows
	local wispRow = 12
	local scawRow = 3

	-- Spawn Radius
	local pugnaRadius = 900
	local ODRadius = 1200
	local wispRadius = 300
	local scawRadius = 600
	local rotateVar = 0

	-- Spawn delay
	local pugnaDelay = 3
	local scawDelay = 8
	local ODDelay = 11

	
	-- Spawn pugnas
	local vSpawnPosPugna = {}
	for i=1, pugnaCount do
		local rotate_distance = point + forwardVec * pugnaRadius
		local rotate_angle = QAngle(0,rotateVar,0)
		rotateVar = rotateVar + 360/pugnaCount
		local rotate_position = RotatePosition(point, rotate_angle, rotate_distance)
		table.insert(vSpawnPosPugna, rotate_position)
	end

	local pugna = {}

	for j = 1, pugnaCount do
		Timers:CreateTimer(pugnaDelay, function()
			local origin = table.remove( vSpawnPosPugna, 1 )
			local illusionForwardVec = (point - origin):Normalized()

			-- handle_UnitOwner needs to be nil, else it will crash the game.
			pugna[j] = CreateUnitByName("ritual_pugna", origin, false, caster, nil, caster:GetTeamNumber())
			pugna[j]:SetForwardVector((point - origin):Normalized())
			
			local lifeDrain = pugna[j]:FindAbilityByName("ritual_pugna_life_drain")
			lifeDrain:SetLevel(3)


			-- Set the unit as an illusion
			-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
			pugna[j]:AddNewModifier(caster, ability, "modifier_kill", { duration = maxTime - pugnaDelay, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
			ability:ApplyDataDrivenModifier(caster, pugna[j], "modifier_icefrogged", {})

			-- Sets the illusion to begin channeling Fire Bomb
			if j > pugnaCount - 2 then
				Timers:CreateTimer( 0.322, function()
					pugna[j]:CastAbilityOnTarget(pugna[j + 2 - pugnaCount], lifeDrain, -1 )
				end)
			else
				Timers:CreateTimer( 0.322, function()
					pugna[j]:CastAbilityOnTarget(pugna[j + 2], lifeDrain, -1 )
				end)
			end
		end)
		pugnaDelay = pugnaDelay + 0.05
	end

	-- Spawn Scawmars
	local vSpawnPosScaw = {}
	for j = 1, scawRow do
		for i=1, scawCount do
			local rotate_distance = point + forwardVec * scawRadius
			local rotate_angle = QAngle(0,rotateVar,0)
			rotateVar = rotateVar + 360/scawCount
			local rotate_position = RotatePosition(point, rotate_angle, rotate_distance)
			table.insert(vSpawnPosScaw, rotate_position)
		end
		scawRadius = scawRadius + 322
	end

	for j = 1, scawRow do
		for k = 1, scawCount do
			
			Timers:CreateTimer(scawDelay, function()
				local origin = table.remove( vSpawnPosScaw, 1 )
				local illusionForwardVec = (point - origin):Normalized()

				-- handle_UnitOwner needs to be nil, else it will crash the game.
				local scaw = CreateUnitByName("npc_dota_hero_phoenix", origin, false, caster, nil, caster:GetTeamNumber())
				scaw:SetForwardVector((point - origin):Normalized())
				
				local fireBomb = scaw:AddAbility("scryer_fire_bomb")
				fireBomb:SetLevel(1)

				-- Set the unit as an illusion
				-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
				scaw:AddNewModifier(caster, ability, "modifier_kill", { duration = 4.8, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
				ability:ApplyDataDrivenModifier(caster, scaw, "modifier_icefrogged", {})
				scaw:MakeIllusion()
				-- Sets the illusion to begin channeling Fire Bomb
				Timers:CreateTimer( 0.122, function()
					scaw:CastAbilityOnPosition(point, fireBomb, -1)
				end)

				-- calculates rotation
				scaw.speed = 800
				scaw.distance = scaw:GetAbsOrigin() - point
				scaw.distanceLength = scaw.distance:Length()
				scaw.randomSpeed = scaw.speed / scaw.distanceLength

				local height = 0
				scaw.increaseSpeed = scaw.randomSpeed / 8
				scaw.variableSpeed = scaw.increaseSpeed
				local jump = 0.6
				local gravity = 0.1

				if j == 2 then 
					scaw.randomSpeed = - scaw.randomSpeed 
					scaw.increaseSpeed = - scaw.increaseSpeed
					scaw.variableSpeed = - scaw.variableSpeed
				end

				Timers:CreateTimer( 0.322, function()
					if time > maxTime then 
						return nil
					end

					local ground_position = GetGroundPosition(scaw:GetAbsOrigin() , scaw)
					local height = height + jump
					local origin = caster:GetAbsOrigin()
					local distance = scaw:GetAbsOrigin() - point
					local vector = distance:Normalized()
					local newDistanceLength = distance:Length()
					local rotate_position = point + vector * newDistanceLength
					
					local rotate_angle = QAngle(0, scaw.randomSpeed, 0)
					local rotate_point = RotatePosition(point, rotate_angle, rotate_position)
					local randomDistance = newDistanceLength + scaw.increaseSpeed

					jump = jump + (gravity / 5)
					scaw:SetAbsOrigin(rotate_point + Vector(0,0,jump) )
					scaw.randomSpeed = scaw.randomSpeed + scaw.variableSpeed
					scaw.variableSpeed = scaw.variableSpeed / 1.03
					return 1/30
				end)
			end)
		end
		scawDelay = scawDelay + 0.75
	end

	-- Spawn ODs
	local vSpawnPosOD = {}
	for i=1, ODCount do
		local rotate_distance = point + forwardVec * ODRadius
		local rotate_angle = QAngle(0,rotateVar,0)
		rotateVar = rotateVar + 360/ODCount
		local rotate_position = RotatePosition(point, rotate_angle, rotate_distance)
		table.insert(vSpawnPosOD, rotate_position)
	end

	local OD = {}

	for j = 1, ODCount do
		Timers:CreateTimer(ODDelay, function()
			local origin = table.remove( vSpawnPosOD, 1 )
			local illusionForwardVec = (point - origin):Normalized()

			-- handle_UnitOwner needs to be nil, else it will crash the game.
			OD[j] = CreateUnitByName("npc_dota_hero_obsidian_destroyer", origin, false, caster, nil, caster:GetTeamNumber())
			OD[j]:SetForwardVector((point - origin):Normalized())
			
			local sanityEclipse = OD[j]:FindAbilityByName("obsidian_destroyer_sanity_eclipse")
			sanityEclipse:SetLevel(3)


			-- Set the unit as an illusion
			-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
			OD[j]:AddNewModifier(caster, ability, "modifier_kill", { duration = 3.5, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
			OD[j]:MakeIllusion()
			ability:ApplyDataDrivenModifier(caster, OD[j], "modifier_icefrogged", {})

			-- Sets the illusion to begin channeling Fire Bomb
			if j > ODCount - 2 then
				Timers:CreateTimer( 0.322, function()
					OD[j]:CastAbilityOnPosition(point,sanityEclipse,-1)
				end)
			else
				Timers:CreateTimer( 0.322, function()
					OD[j]:CastAbilityOnPosition(point,sanityEclipse,-1)
				end)
			end
		end)
		ODDelay = ODDelay + 0.2
	end

end

--[[local distance = (rotate_position - point):Length2D()
	local vector = (rotate_position - point):Normalized()
	local speed = distance / delay
	local projectileTable =
	{
		EffectName = "particles/econ/items/magnataur/shock_of_the_anvil/magnataur_shockanvil.vpcf",
		Ability = ability,
		vSpawnOrigin = point,
		vVelocity = Vector( vector.x * speed, vector.y * speed, 0 ),
		fDistance = distance,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
	}

	vProjPos[i] = ProjectileManager:CreateLinearProjectile(projectileTable)]]